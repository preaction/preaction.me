
use v5.24;
use Mojolicious::Lite;
use experimental qw( signatures postderef );
use Mojo::SQLite;
use Mojo::JSON qw( encode_json decode_json );

helper sqlite => sub {
    state $sqlite = Mojo::SQLite->new( 'sqlite::temp:' );
    return $sqlite;
};
app->sqlite->auto_migrate(1)->migrations->from_data;
plugin AutoReload =>;

# Login sessions expire after one week
app->sessions->default_expiration( 60 * 60 * 24 * 7 );

if ( my $path = $ENV{MOJO_REVERSE_PROXY} ) {
    app->sessions->cookie_path( $ENV{MOJO_REVERSE_PROXY} );
    my @parts = grep { $_ } split m{/}, $path;
    app->hook( before_dispatch => sub {
        my ( $c ) = @_;
        my $url = $c->req->url;
        my $base = $url->base;
        # Append to the base path
        push @{ $base->path }, @parts;
        # The base must end with a slash, making http://example.com/todo/
        $base->path->trailing_slash(1);
        # and the URL must not, so that relative links on the home page work
        # correctly
        $url->path->leading_slash(0);
    });
}

plugin Yancy => {
    backend => { Sqlite => app->sqlite },
    read_schema => 1,
};
if ( $ENV{GITHUB_AUTH_SECRET} ) {
    app->yancy->plugin( 'Auth::Github', {
        schema => 'users',
        client_id => $ENV{GITHUB_AUTH_CLIENT},
        client_secret => $ENV{GITHUB_AUTH_SECRET},
        username_field => 'username',
    } );
}

my @subscribers;
my @publishers;
my $room = {};
helper room => sub { $room };

helper send_status => sub( $c ) {
    $_->send( encode_json [ status => { users => @subscribers + @publishers } ] )
        for @publishers;
};

websocket '/' => sub( $c ) {
    $c->inactivity_timeout( 60000 );
    push @subscribers, $c;
    $c->on(
        finish => sub( $c, @ ) {
            @subscribers = grep { $_ ne $c } @subscribers;
            $c->send_status;
        },
    );
    if ( $room->{url} ) {
        $c->send( encode_json [ location => $room->{url} ] );
    }
    if ( $room->{text} ) {
        $c->send( encode_json [ 'text.show' => $room->{text} ] );
    }
    $c->send_status;
}, 'subscribe';

post '/ask' => sub( $c ) {
    my $question = $c->req->json;
    for my $pub ( @publishers ) {
        $pub->send( encode_json [ 'question.add', $question ] );
    }
    $c->render(
        json => [ 'OK' ],
    );
}, 'question.add';

get '/' => 'index';

websocket '/new' => sub( $c ) {
    $c->inactivity_timeout( 60000 );
    if ( !@publishers ) {
        $room = {
            topic => $c->param( 'topic' ),
        };
    }
    push @publishers, $c;
    $c->on( finish => sub( $c, @ ) {
        @publishers = grep { $_ ne $c } @publishers;
        $c->send_status;
    } );
    $c->on( message => sub( $c, $msg ) {
        my ( $event, $data ) = @{ decode_json $msg };
        if ( $event eq 'location' ) {
            $room->{url} = $data;
        }
        elsif ( $event eq 'text.show' ) {
            $room->{text} = $data;
        }
        elsif ( $event eq 'text.hide' ) {
            delete $room->{text};
        }
        $_->send( $msg ) for @subscribers;
    } );
    $c->send_status;
    $_->send( encode_json [ location => $room->{url} ] ) for @subscribers;
}, 'publish';

get '/test/1' => 'test/1';
get '/test/2' => 'test/2';
get '/test/3' => 'test/3';

if ( app->yancy->can( 'auth' ) ) {
    under app->yancy->auth->require_user;
}
get '/new' => 'new';

app->start;
__DATA__

@@ layouts/default.html.ep
<!DOCTYPE html>
%= stylesheet '/yancy/font-awesome/css/font-awesome.css'
%= stylesheet '/yancy/bootstrap.css'
%= stylesheet begin
    html, body, #app {
        margin: 0;
        padding: 0;
        height: 100%;
        position: relative;
    }
    #app {
        display: flex;
        flex-flow: column;
    }
    .user header {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        transition: 1s;
        height: 36px;
        background: white;
        border-bottom: 3px solid black;
        display: flex;
        align-items: center;
        z-index: 20;
    }
    .user header .toggle {
        position: absolute;
        top: 33px;
        right: 32px;
        border: 3px solid black;
        border-radius: 0 0 5px 5px;
        height: 25px;
        width: 34px;
        border-top: none;
        background: white;
        text-align: center;
    }
    iframe {
        flex: 1 1 100%;
        border: 0;
        margin: 0;
        padding: 0;
    }
    iframe.disabled {
        pointer-events: none;
    }
    header, header > form {
        flex: 1 1 auto;
        padding: 0.1rem;
        margin: 0;
        border-bottom: 3px solid black;
        display: flex;
        align-items: center;
    }
    header > *, header > form > * {
        margin-right: .25rem;
    }
    header > :last-child, header > form > :last-child {
        margin-right: 0;
    }
    header > form {
        border-bottom: none;
        padding: 0;
    }
    [name=url], .user header .status {
        flex: 1 1 60vw;
    }
    .sidebar {
        position: fixed;
        top: 32px;
        right: 0;
        width: 20vw;
        min-width: 300px;
        height: 80vh;
        min-height: 300px;
        background: white;
        z-index: 25;
        border: 3px solid black;
        border-top-color: white;
        overflow: scroll;
    }
    .sidebar form {
        margin: 0.1em;
    }
    .overlay {
        position: absolute;
        top: 36px;
        right: 0;
        left: 0;
        bottom: 0;
        background: white;
        z-index: 5;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .user .overlay {
        top: 0;
    }
    .showingText {
        font-size: 6rem;
        white-space: pre-wrap;
        text-align: center;
        padding: 1em;
    }
% end
%= javascript '/yancy/jquery.js'
%= javascript '/yancy/popper.js'
%= javascript '/yancy/bootstrap.js'
%= javascript '/yancy/vue.js'
%= javascript 'https://cdnjs.cloudflare.com/ajax/libs/dexie/2.0.4/dexie.min.js'
%= javascript 'https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.11/lodash.min.js'

%= content

@@ new.html.ep
% layout 'default';
<main id="app">
    <header>
        <form @submit.prevent="handleSubmit">
            <i class="fa fa-compass fa-lg" aria-label="URL"></i>
            <input v-model="currentPath" placeholder="URL" name="url" />
            <button class="btn btn-success btn-sm">
                <i class="fa fa-arrow-right fa-lg" aria-label="Go"></i>
            </button>
            <button :class="buttonClass('questions')" @click="showPanel('questions')"
                class="btn btn-sm" type="button"
            >
                <i class="fa fa-question-circle fa-lg" aria-label="Questions"></i>
            </button>
            <button :class="buttonClass('text')" @click="showPanel('text')"
                class="btn btn-sm" type="button"
            >
                <i class="fa fa-pencil-square-o fa-lg" aria-label="Show Text"></i>
            </button>
            <button :class="panel == 'settings' ? 'btn-secondary' : 'btn-outline-secondary'"
                @click="showPanel('settings')" class="btn btn-sm" type="button"
            >
                <i class="fa fa-gear fa-lg" aria-label="Session Settings"></i>
            </button>
        </form>
    </header>

    <div v-show="panel" class="sidebar" style="display: none">
        <div v-show="panel == 'questions'">
            <div class="btn-group btn-group-toggle">
                <label class="btn btn-outline-secondary" :class="!listAllQuestions ? 'active' : ''">
                    <input type="radio" name="listAllQuestions" autocomplete="off" v-model="listAllQuestions" checked @click="listAllQuestions = false" :value="false"> Unread
                </label>
                <label class="btn btn-outline-secondary" :class="listAllQuestions ? 'active' : ''">
                    <input type="radio" name="listAllQuestions" v-model="listAllQuestions" @click="listAllQuestions = true" :value="true" autocomplete="off"> All
                </label>
            </div>
            <ul class="list-group list-group-flush">
                <li v-for="question in listQuestions" @click="showQuestion( question )"
                    class="list-group-item list-group-item-action"
                    :class="showingQuestion === question ? 'active' : question.read ? 'list-group-item-light' : 'list-group-item-info'"
                >
                    <i>{{ question.name || 'Anonymous' }}</i>: {{ question.text }}
                    <div v-if="question.email">{{ question.email }}</div>
                </li>
            </ul>
        </div>
        <div v-show="panel == 'text'">
            <form class="form" @submit.prevent="showText">
                <div class="form-group">
                    <textarea id="textToShow" v-model="textToShow"
                        @keydown.ctrl.enter.prevent="showText"
                        @keydown.meta.enter.prevent="showText"
                        class="form-control" placeholder="Text to Display"
                    ></textarea>
                </div>
                <button v-if="!showingText" class="btn btn-primary">Show</button>
                <button v-if="showingText" class="btn btn-primary">Update</button>
                <button @click.prevent="hideText(); panel = null; showHeader = false;"
                    class="btn btn-secondary">Remove</button>
            </form>
        </div>
        <div v-show="panel == 'settings'">
            <div>{{ status ? status.users : 0 }} connected</div>
            <button class="btn btn-outline-danger">Close Room</button>
        </div>
    </div>

    <div v-show="showingQuestion || showingText" class="overlay" style="display: none">
        <h1 v-if="showingQuestion">{{ showingQuestion.text }}</h1>
        <h1 v-if="showingText" class="showingText">{{ showingText }}</h1>
    </div>

    <iframe ref="iframe"></iframe>
</main>

%= javascript begin
window.live = new Vue({
    el: '#app',
    data: function () {
        var queryString = location.href.substring( location.href.indexOf('?') + 1 );
        var query = {};
        queryString.split( '&' ).forEach( function (pair) {
            var parts = pair.split( '=' );
            query[ parts[0] ] = decodeURIComponent( parts[1] );
        } );

        return {
            status: {
                users: 0
            },
            currentPath: query.url,
            ws: null,
            panel: null,
            showingQuestion: null,
            questions: [ ],
            status: {
                users: 0
            },
            listAllQuestions: false,
            showingText: '',
            textToShow: ''
        };
    },

    methods: {
        updateHistory: _.throttle( function ( newPath ) {
            history.replaceState( {}, newPath, '?url=' + encodeURIComponent( newPath ) );
        }, 500, { leading: true, trailing: true } ),

        updateLocation: function ( newLocation ) {
            var newPath = newLocation.replace( location.origin, '' );
            if ( newPath == this.currentPath ) {
                return;
            }
            this.currentPath = newPath;
            this.sendLocation();
        },

        handleSubmit: function () {
            this.sendLocation();
            this.$refs.iframe.contentWindow.location.href = this.currentPath;
        },

        sendLocation: function () {
            this.updateHistory( this.currentPath );
            this.sendEvent( 'location', this.currentPath );
        },

        sendEvent: function ( name, data ) {
            if ( !this.ws || !this.ws.send ) {
                // XXX: We might need to queue these up to send them later...
                return;
            }
            this.ws.send( JSON.stringify( [ name, data ] ) );
        },

        handleEvent: function ( name, data ) {
            switch ( name ) {
                case 'question.add':
                    data.read = false;
                    this.questions.push( data );
                    break;
                case 'status':
                    this.status = data;
                    break;
            }
        },

        showPanel: function ( name ) {
            this.showingQuestion = null;
            this.sendEvent( 'question.hide' );
            if ( this.panel == name ) {
                this.panel = null;
            }
            else {
                this.panel = name;
                if ( name == 'text' ) {
                    this.$nextTick( function () {
                        $( '#textToShow' ).focus();
                    } );
                }
            }
        },

        showQuestion: function ( question ) {
            if ( this.showingQuestion === question ) {
                this.showingQuestion = null;
                this.sendEvent( 'question.hide' );
            }
            else {
                question.read = true;
                this.showingQuestion = question;
                this.sendEvent( 'question.show', question );
            }
        },

        showText: function ( ) {
            this.showingText = this.textToShow;
            this.textToShow = '';
            this.sendEvent( 'text.show', this.showingText );
        },

        hideText: function ( ) {
            this.showingText = '';
            this.sendEvent( 'text.hide' );
        },

        buttonClass: function ( name ) {
            switch ( name ) {
                case 'questions':
                    return this.panel == 'questions' && this.unreadQuestions.length > 0 ? 'btn-danger'
                        : this.panel == 'questions' ? 'btn-secondary'
                        : this.unreadQuestions.length > 0 ? 'btn-outline-danger'
                        : 'btn-outline-secondary';
                case 'text':
                    return this.showingText ? 'btn-primary'
                        : this.panel == 'text' ? 'btn-secondary'
                        : 'btn-outline-secondary';
            }
        },

        connect: function () {
            var self = this;
            var ws = this.ws = new WebSocket( '<%= url_for( 'publish' )->to_abs->scheme( 'ws' ) %>' );
            ws.onmessage = function ( msg ) {
                var event = JSON.parse( msg.data );
                self.handleEvent( event[0], event[1] );
            };
            ws.onopen = function () {
                self.$refs.iframe.addEventListener( 'load', function ( event ) {
                    self.updateLocation( self.$refs.iframe.contentWindow.location.toString() );
                    // Add all window/document listeners here. These are removed
                    // after every unload, so we have to add them again each time.
                    self.$refs.iframe.contentWindow.addEventListener( 'hashchange', function ( event ) {
                        self.updateLocation( event.newURL );
                    } );
                } );
                if ( self.currentPath ) {
                    self.$refs.iframe.contentWindow.location.href = self.currentPath;
                    self.sendLocation();
                }
            };
        },

    },

    computed: {
        unreadQuestions: function () {
            return this.questions.filter( function (q) { return !q.read } );
        },
        listQuestions: function () {
            return this.listAllQuestions ? this.questions : this.unreadQuestions;
        }
    },

    created: function () {
        this.connect();
    }
});

% end

@@ index.html.ep
% layout 'default';
<main class="user" id="app">
    <header ref="header" :style="showHeader ? '' : 'top: -35px'"
    >
        <span class="status">{{ status }}
            <a v-if="currentLocation" @click.prevent="window.open(currentLocation)"
                :href="currentLocation">{{ currentLocation }}</a>
        </span>
        <button :class="buttonClass('question')" @click="showPanel('question')"
            class="btn btn-sm"
        >Ask a Question</button>
        <div @click="showHeader ? showHeader = false : showHeader = true" class="toggle">
            <i class="fa fa-caret-up"
                style="transition: 1s; transform: rotate(0deg)"
                :style="showHeader ? 'transform: rotate(180deg)' : ''"
            ></i>
        </div>
    </header>
    <iframe :class="mouseDisabled ? 'disabled' : ''" ref='iframe'
    ></iframe>
    <div v-show="panel" class="sidebar" style="display: none">
        <div v-show="panel == 'question'">
            <form class="form" @submit.prevent="postQuestion">
                <div class="form-group">
                    <label for="questionName">Name</label>
                    <input type="text" class="form-control" id="questionName"
                        placeholder="Enter name" v-model="question.name"
                    >
                </div>
                <div class="form-group">
                    <label for="questionEmail">Email</label>
                    <input type="text" class="form-control" id="questionEmail"
                        placeholder="Enter email" v-model="question.email"
                    >
                    <small>Will not be shared. If I can't answer your question right away, I can e-mail you an answer.</small>
                </div>
                <div class="form-group">
                    <label for="questionText">Question</label>
                    <textarea id="questionText" v-model="question.text"
                        @keydown.ctrl.enter.prevent="postQuestion"
                        @keydown.meta.enter.prevent="postQuestion"
                        class="form-control" placeholder="Question"
                    ></textarea>
                </div>
                <button class="btn btn-primary">Submit</button>
                <button @click.prevent="panel = null; showHeader = false;"
                    class="btn btn-secondary">Close</button>
                <span v-if="questionSubmitting"><i class="fa fa-pulse fa-spinner"></i></span>
                <span v-if="questionSuccess">Submitted!</span>
            </form>
        </div>
    </div>

    <div v-show="showingQuestion || showingText" class="overlay" style="display: none">
        <h1 v-if="showingQuestion">{{ showingQuestion.text }}</h1>
        <h1 v-if="showingText" class="showingText">{{ showingText }}</h1>
    </div>

</main>

%= javascript begin
window.live = new Vue({
    el: '#app',
    data: function () {
        return {
            ws: null,
            mouseDisabled: true,
            currentLocation: null,
            showHeader: true,
            status: 'Connecting...',
            panel: null,
            question: {
                name: '',
                text: ''
            },
            showingQuestion: null,
            questionSubmitting: false,
            questionSuccess: false,
            showingText: null
        };
    },
    methods: {
        buttonClass: function ( name ) {
            switch ( name ) {
                case 'question':
                    return this.panel == 'question' ? 'btn-secondary'
                        : 'btn-outline-secondary';
            }
        },

        showPanel: function ( name ) {
            this.showHeader = true;
            if ( this.panel == name ) {
                this.panel = null;
            }
            else {
                this.panel = name;
                if ( this.panel == 'question' ) {
                    this.$nextTick( function () {
                        $( '#questionName' ).focus();
                    } );
                }
            }
        },

        sendEvent: function ( name, data ) {
            if ( !this.ws || !this.ws.send ) {
                // XXX: We might need to queue these up to send them later...
                return;
            }
            this.ws.send( JSON.stringify( [ name, data ] ) );
        },

        updateLocation: function ( newLocation ) {
            var iframe = this.$refs.iframe;
            this.status = '';
            this.showHeader = !!this.panel;
            iframe.style.display = 'block';
            if ( newLocation.match( /^\// ) ) {
                newLocation = location.protocol + '//' + location.host + newLocation;
            }
            iframe.contentWindow.location.href = this.currentLocation = newLocation;
        },

        connect: function () {
            var self = this;
            var ws = this.ws = new WebSocket( '<%= url_for( 'subscribe' )->to_abs->scheme( 'ws' ) %>/' );
            ws.onmessage = function ( msg ) {
                var event = JSON.parse( msg.data );
                self.handleEvent( event[0], event[1] );
            };
            this.status = 'Waiting for presenter...';
        },

        handleEvent: function ( name, data ) {
            switch ( name ) {
                case 'location':
                    this.updateLocation( data );
                    break;
                case 'question.show':
                    this.showingQuestion = data;
                    break;
                case 'question.hide':
                    this.showingQuestion = null;
                    break;
                case 'text.show':
                    this.showingText = data;
                    break;
                case 'text.hide':
                    this.showingText = null;
                    break;
            }
        },

        postQuestion: function () {
            if ( !this.question.text ) {
                return;
            }
            this.questionSuccess = false;
            this.questionSubmitting = true;
            var self = this;
            $.post({
                url: '<%= url_for "question.add" %>',
                dataType: 'json',
                headers: {
                    'Content-Type': 'application/json'
                },
                data: JSON.stringify( this.question )
            })
            .done( function () {
                self.questionSuccess = true;
                self.questionSubmitting = false;
                setTimeout( function () { self.questionSuccess = false }, 3000 );
                self.question.text = '';
            } );
        }

    },
    created: function () {
        setTimeout( _.bind( this.connect, this ), 3000 );
    }
});
% end

@@ test/1.html.ep
<h1>Test 1</h1>
<a href="/test/2">Next</a>
<a href="#down">Down</a>
<div style="height: 500em"></div>
<h1 id="down">Test Down</h1>

@@ test/2.html.ep
<h1>Test 2</h1>
<a href="/test/1">Prev</a>
<a href="/test/3">Next</a>

@@ test/3.html.ep
<h1>Test 3</h1>
<a href="/test/2">Prev</a>

@@ migrations
-- 1 up
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100)
);
INSERT INTO users ( username ) VALUES ( 'preaction' );
-- 1 down
DROP TABLE users;

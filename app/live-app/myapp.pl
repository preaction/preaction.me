
use v5.24;
use Mojolicious::Lite;
use experimental qw( signatures postderef );

if ( my $path = $ENV{MOJO_REVERSE_PROXY} ) {
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

my @subscribers;
my @publishers;
my $room = {};
helper room => sub { $room };

websocket '/' => sub( $c ) {
    $c->inactivity_timeout( 60000 );
    push @subscribers, $c;
    $c->on(
        finish => sub( $c, @ ) {
            @subscribers = grep { $_ ne $c } @subscribers;
        },
    );
    if ( $room->{url} ) {
        $c->send( $room->{url} );
    }
}, 'subscribe';

get '/' => 'index';

websocket '/new' => sub( $c ) {
    $c->inactivity_timeout( 60000 );
    if ( !@publishers ) {
        $room = {
            topic => $c->param( 'topic' ),
            url => $c->param( 'url' ),
        };
    }
    push @publishers, $c;
    $c->on( finish => sub( $c, @ ) {
        @publishers = grep { $_ ne $c } @publishers;
    } );
    $c->on( message => sub( $c, $msg ) {
        $room->{url} = $msg;
        $_->send( $msg ) for @subscribers;
    } );
}, 'publish';

get '/new' => 'new';

get '/test/1' => 'test/1';
get '/test/2' => 'test/2';
get '/test/3' => 'test/3';

app->start;
__DATA__

@@ layouts/default.html.ep
%= stylesheet begin
    html, body {
        margin: 0;
        padding: 0;
        min-height: 100%;
    }
    body {
        display: flex;
        flex-flow: column;
    }
    iframe {
        display: none;
        flex: 1 1;
        border: 0;
        margin: 0;
        padding: 0;
    }
    form {
        padding: 0.1em 0.4em;
        margin: 0;
        border-bottom: 3px solid black;
    }
% end
%= content

@@ new.html.ep
% layout 'default';
%= tag form => begin
    %= label_for topic => 'Topic'
    %= text_field topic => ( id => 'topic' )
    %= label_for url => 'URL'
    %= text_field url => ( id => 'url' )
    %= submit_button
% end
<iframe></iframe>
%= javascript begin
window.addEventListener( 'DOMContentLoaded', function ( event ) {
    var iframe = document.querySelector( 'iframe' );
    var form = document.querySelector( 'form' );
    var topicField = form.querySelector( '[name=topic]' );
    var urlField = form.querySelector( '[name=url]' );
    var ws;

    function sendLocation( newLocation ) {
        urlField.value = newLocation.replace( location.origin, '' );
        var state = {
            "topic": topicField.value,
            "location": newLocation
        };
        history.replaceState( state, "Ignore", '?' + queryString() );
        ws.send( newLocation );
    }

    function queryString() {
        var topic = topicField.value;
        var url = urlField.value;
        return 'topic=' + encodeURIComponent( topic ) + '&url=' + encodeURIComponent( url );
    }

    form.addEventListener( 'submit', function ( event ) {
        event.preventDefault();
        var query = queryString();
        ws = new WebSocket( '<%= url_for( 'publish' )->to_abs->scheme( 'ws' ) %>?' + query );
        ws.onopen = function () {
            iframe.addEventListener( 'load', function ( event ) {
                sendLocation( iframe.contentWindow.location.toString() );
                // Add all window/document listeners here. These are removed
                // after every unload, so we have to add them again each time.
                iframe.contentWindow.addEventListener( 'hashchange', function ( event ) {
                    sendLocation( event.newURL );
                } );
            } );
            iframe.style.display = 'block';
            iframe.contentWindow.location.href = urlField.value;
        };
    } );
} );

% end

@@ index.html.ep
% layout 'default';
<div id="welcome">
    % if ( my $topic = $c->room->{topic} ) {
        Connecting to <%= $topic %>
    % }
    % else {
        Waiting for presenter...
    % }
</div>
<iframe></iframe>
%= javascript begin
window.addEventListener( 'DOMContentLoaded', function ( event ) {
    var welcome = document.querySelector( '#welcome' );
    var iframe = document.querySelector( 'iframe' );
    var ws = new WebSocket( '<%= url_for( 'subscribe' )->to_abs->scheme( 'ws' ) %>/' );
    ws.onmessage = function ( msg ) {
        welcome.style.display = 'none';
        iframe.style.display = 'block';
        iframe.contentWindow.location.href = msg.data;
    };
} );
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


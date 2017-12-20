use Mojolicious::Lite;
use Mojo::Pg;

my $pg = Mojo::Pg->new( 'postgres://localhost/blog' );
$pg->migrations->from_data->migrate;

plugin Yancy => {
    backend => 'pg://localhost/blog',
    collections => {
        blog => {
            required => [ 'title', 'markdown', 'html' ],
            properties => {
                id => {
                    type => 'integer',
                    readOnly => 1,
                },
                title => {
                    type => 'string',
                },
                markdown => {
                    type => 'string',
                    format => 'markdown',
                    'x-html-field' => 'html',
                },
                html => {
                    type => 'string',
                },
            },
        },
        blog_comment => {
            'x-list-columns' => [qw( id blog_id author_name author_email )],
            required => [qw( author_name author_email content )],
            properties => {
                id => {
                    type => 'integer',
                    readOnly => 1,
                },
                blog_id => {
                    type => 'integer',
                },
                author_name => {
                    type => 'string',
                },
                author_email => {
                    type => 'string',
                },
                content => {
                    type => 'string',
                },
            },
        },
    },
};

get '/' => sub {
    my ( $c ) = @_;
    my @posts = $c->yancy->list( blog => {}, { order_by => { -desc => 'created' } } );
    for my $post ( @posts ) {
        $post->{comments} = [
            $c->yancy->list(
                blog_comment => { blog_id => $post->{id} },
                { order_by => { -desc => 'created' } },
            )
        ];
    }
    return $c->render( 'index', posts => \@posts );
};

post '/blog/:id/comment' => sub {
    my ( $c ) = @_;
    # Create the new comment
    my %item;
    for my $field (qw( author_name author_email content )) {
        $item{ $field } = $c->param( $field );
    }
    $item{ blog_id } = 0+$c->stash( 'id' );
    eval { $c->yancy->create( blog_comment => \%item ) };
    if ( $@ ) {
        use Data::Dumper;
        $c->app->log->debug( Dumper $@ );
        return $c->reply->exception( Dumper $@ );
    }
    # Back to the blog
    $c->res->headers->location( '/' );
    return $c->rendered( 302 );
};

app->start;

__DATA__
@@ index.html.ep
<!doctype html>
<html lang="en">
  <head>
    <title>Hello, world!</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
  </head>
  <body>
    <main role="main" class="container">
    % for my $post ( @{ stash 'posts' } ) {
        <%== $post->{html} %>
        <h2>Comments</h2>
        <form class="form" method="POST" action="/blog/<%= $post->{id} %>/comment">
            <div class="form-group row">
                <label class="col-form-label col-2">Name</label>
                <input name="author_name" class="form-control col-4" />
            </div>
            <div class="form-group row">
                <label class="col-form-label col-2">E-mail</label>
                <input name="author_email" class="form-control col-4" />
            </div>
            <div class="form-group row">
                <label class="col-form-label col-2">Comment</label>
                <textarea name="content" rows="6" class="form-control col-4"></textarea>
            </div>
            <button class="btn btn-primary">Submit</button>
        </form>
        % for my $comment ( @{ $post->{comments} } ) {
            <h3>
                <%= $comment->{author_name} %>
            </h3>
            <date><%= $comment->{created} %></date>
            <p style="white-space: pre-line"><%= $comment->{content} %></p>
        % }
    % }
    </main>

    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>
  </body>
</html>

@@ migrations
-- 1 up
CREATE TABLE blog (
    id SERIAL PRIMARY KEY,
    title VARCHAR NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    markdown TEXT NOT NULL,
    html TEXT NOT NULL
);
-- 1 down
DROP TABLE blog;
-- 2 up
CREATE TABLE blog_comment (
    id SERIAL PRIMARY KEY,
    blog_id INTEGER REFERENCES blog ON DELETE CASCADE,
    created TIMESTAMP NOT NULL DEFAULT NOW(),
    author_name VARCHAR NOT NULL,
    author_email VARCHAR NOT NULL,
    content TEXT NOT NULL
);
-- 2 down
DROP TABLE blog_comment;

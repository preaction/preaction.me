---
title: Mark Todo Completed - Todo App - Yancy Tutorial
links:
    prev:
        href: display-todo-list.html
        title: 6. Display the to-do list
    next:
        href: navigate-todo-list.html
        title: 8. Navigate between dates
template: tutorial-page.html
---

# Mark To-do Items as Completed

Once we've displayed our to-do list, we need to be able to mark our
to-do items as completed. We will turn each of our todo log entries into
a form with a button. Clicking on the button will mark the item as
completed, or, if it's already completed, will mark it as incomplete (in
case we mistakenly complete something we haven't done).

## Building the Update Route Handler

First, we should build a route to mark an entry as completed. This will
be a `POST` request, so we use the `post` function. We're going to put
the ID of the log entry in the URL to make it REST-like.

    post '/log/:log_id' => sub {
        my ( $c ) = @_;

The `:` in the route path introduces a placeholder. The text following
the `:` is where Mojolicious will save the value in the `stash`, which
is a general storage area for the current request. So, we can get the ID
out using the `stash()` method of the controller object.

        my $id = $c->stash( 'log_id' );

Our form will have a button that will have a value of true (`1`) or
false (`0`) if we are marking the item as complete or incomplete. Form
values are retrieved by using the `param()` method of the controller
object. If the item is complete, we want to store the date that the item
was completed. Otherwise we want to set the completed date to `null`
(from the Perl side, we use `undef`).

        my $complete = $c->param( 'complete' )
            ? DateTime->today->ymd
            : undef;

Then we can execute a SQL `UPDATE` query to update our log entry.

        my $sql = 'UPDATE todo_log SET complete = ? WHERE id = ?';
        $c->pg->db->query( $sql, $complete, $id );

Finally, we redirect the user back to where they were, our `index` page,
with the `redirect_to()` method, which takes the name of the route to
redirect to as an argument.

        return $c->redirect_to( 'index' );

This route needs a name, so we'll give it a name of `update_log`. We're
going to use this name to build a form that gets submitted to the right
URL.

## Creating the Button Form

Down in our template, rather than displaying an unordered list, now
we're going to render a form for every item in the list.

    @@ index.html.ep
    %% layout 'default';
    %% title 'Welcome';
    <h1><%%= $date->ymd %></h1>
    %% for my $item ( @$items ) {
        %%= form_for 'update_log', { log_id => $item->{id} }, begin
            %%= $item->{title}
            %% if ( !$item->{complete} ) {
                <button name="complete" value="1">Complete</button>
            %% }
            %% else {
                <button name="complete" value="0">Undo</button>
            %% }
        %% end
    %% }

This uses the `form_for` helper. Helper functions are also available in
every template (making them truly helpful). The `form_for` helper is
part of a set of helpers installed by default from the
[Mojolicious::Plugin::TagHelpers](http://mojolicious.org/perldoc/Mojolicious/Plugin/TagHelpers)
module. It takes the name of a route, a hash reference of placeholder
values (in this case, we need to give it the ID of the log entry), and
then we use the `begin` function.

The `begin` function allows us to add a template as an argument to
a function. The `end` function marks the end of the content, and then
the whole thing is given to the original function (in this case,
`form_for`). In this way, the `form_for` function will wrap our content
in `<form>` HTML tags.

Inside our form we print out the text of the todo item.

Finally, we add the button. If the item is not completed, we'll make
a button that marks the item as complete. If the item is completed,
we'll make a button that marks the item as incomplete.

Now we can see our button and click on it to complete our to-do list!

![The todo list with complete/undo buttons](mark-todo-completed.png)

Our full code looks like this:

%= include 'component/collapse.html.ep', title => 'Expand code', content => markdown begin

    #!/usr/bin/env perl
    use Mojolicious::Lite;
    use Mojo::Util qw( unindent trim );
    use Mojo::Pg;
    use DateTime::Event::Recurrence;
    use DateTime;

    helper pg => sub { state $pg = Mojo::Pg->new( 'postgres:///myapp' ) };
    app->pg->auto_migrate(1)->migrations->from_data;

    plugin Yancy => {
        backend => { Pg => app->pg },
        read_schema => 1,
        schema => {
            mojo_migrations => {
                'x-ignore' => 1,
            },
            todo_item => {
                title => 'To-Do Item',
                description => unindent( trim q{
                    A recurring task to do. Tasks are available during a `period`, and
                    recur after an `interval`. For example:

                    * A task with an interval of `1` and a period of `day` should be
                      completed once every day.
                    * A task with an interval of `1` and a period of `week` should be
                      completed once every week.
                    * A task with an interval of `2` and a period of `day` will show up
                      once every 2 days and should be completed that day.
                    * A task with an interval of `2` and a period of `week` will show up
                      once every 2 weeks and should be completed that week.
                }),
                example => {
                    period => "day",
                    title => "Did you brush your teeth?",
                    interval => 1,
                },
                properties => {
                    period => {
                        description => 'How long a task is available to do.',
                    },
                    interval => {
                        description => 'The number of periods each between each instance.',
                    },
                    start_date => {
                        description => 'The date to start using this item. Defaults to today.',
                    },
                },
                'x-list-columns' => [qw( title interval period )],
            },
            todo_log => {
                title => 'To-Do Log',
                description => unindent( trim q{
                    A log of the to-do items that have passed. Items can either be completed
                    or uncompleted.
                } ),
                properties => {
                    complete => {
                        description => 'The date which this item was completed, if any.',
                    },
                },
            },
        },
    };

    my %RECUR_METHOD = (
        day => 'daily',
        week => 'weekly',
        month => 'monthly',
    );
    sub _build_recurrence {
        my ( $todo_item ) = @_;
        my $method = $RECUR_METHOD{ $todo_item->{ period } };
        return DateTime::Event::Recurrence->$method(
            interval => $todo_item->{ interval },
        );
    }

    sub _build_end_dt {
        my ( $todo_item, $start_dt ) = @_;
        if ( $todo_item->{ period } eq 'day' ) {
            return $start_dt->clone;
        }
        elsif ( $todo_item->{ period } eq 'week' ) {
            return $start_dt->clone->add( days => 6 );
        }
        elsif ( $todo_item->{ period } eq 'month' ) {
            return $start_dt->clone->add( months => 1 )->subtract( days => 1 );
        }
    }

    helper _log_exists => sub {
        my ( $c, $todo_item, $start_dt ) = @_;
        my $exists_sql = <<'    SQL';
            SELECT COUNT(*) FROM todo_log
            WHERE todo_item_id = ? AND start_date = ?
        SQL
        my $result = $c->pg->db->query( $exists_sql, $todo_item->{id}, $start_dt->ymd );
        my $exists = !!$result->array->[0];
        return $exists;
    };

    helper ensure_log_item_exists => sub {
        my ( $c, $todo_item, $start_dt ) = @_;
        if ( !$c->_log_exists( $todo_item, $start_dt ) ) {
            my $end_dt = _build_end_dt( $todo_item, $start_dt );
            my $insert_sql = <<'        SQL';
                INSERT INTO todo_log ( todo_item_id, start_date, end_date )
                VALUES ( ?, ?, ? )
            SQL
            $c->pg->db->query( $insert_sql,
                $todo_item->{id}, $start_dt->ymd, $end_dt->ymd,
            );
        }
    };

    helper build_todo_log => sub {
        my ( $c, $dt ) = @_;
        $dt //= DateTime->today;
        my $sql = 'SELECT * FROM todo_item WHERE start_date <= ?';
        my $result = $c->pg->db->query( $sql, $dt->ymd );
        my $todo_items = $result->hashes;
        for my $todo_item ( @$todo_items ) {
            my $series = _build_recurrence( $todo_item );
            if ( my $start_dt = $series->current( $dt ) ) {
                $c->ensure_log_item_exists( $todo_item, $start_dt );
            }
        }
    };

    get '/' => sub {
        my ( $c ) = @_;
        my $dt = DateTime->today;
        $c->build_todo_log( $dt );
        my $sql = <<'    SQL';
            SELECT log.id, item.title, log.complete
            FROM todo_log log
            JOIN todo_item item
                ON log.todo_item_id = item.id
            WHERE log.start_date <= ?::date
                AND log.end_date >= ?::date
        SQL
        my $result = $c->pg->db->query( $sql, ( $dt->ymd ) x 2 );
        my $items = $result->hashes;
        return $c->render(
            template => 'index',
            date => $dt,
            items => $items,
        );
    } => 'index';

    post '/log/:log_id' => sub {
        my ( $c ) = @_;
        my $id = $c->stash( 'log_id' );
        my $complete = $c->param( 'complete' )
            ? DateTime->today->ymd
            : undef;
        my $sql = 'UPDATE todo_log SET complete = ? WHERE id = ?';
        $c->pg->db->query( $sql, $complete, $id );
        return $c->redirect_to( 'index' );
    } => 'update_log';

    app->start;
    __DATA__

    @@ index.html.ep
    %% layout 'default';
    %% title 'Welcome';
    <h1><%%= $date->ymd %></h1>
    %% for my $item ( @$items ) {
        %%= form_for 'update_log', { log_id => $item->{id} }, begin
            %%= $item->{title}
            %% if ( !$item->{complete} ) {
                <button name="complete" value="1">Complete</button>
            %% }
            %% else {
                <button name="complete" value="0">Undo</button>
            %% }
        %% end
    %% }

    @@ layouts/default.html.ep
    <!DOCTYPE html>
    <html>
        <head><title><%%= title %></title></head>
        <body>
            %%= content
        </body>
    </html>

    @@ migrations
    -- 1 up
    CREATE TYPE todo_interval AS ENUM ( 'day', 'week', 'month' );
    CREATE TABLE todo_item (
        id SERIAL PRIMARY KEY,
        title TEXT,
        period todo_interval NOT NULL,
        interval INTEGER DEFAULT 1 CHECK ( interval >= 1 ) NOT NULL,
        start_date DATE NOT NULL DEFAULT CURRENT_DATE
    );
    CREATE TABLE todo_log (
        id SERIAL PRIMARY KEY,
        todo_item_id INTEGER REFERENCES todo_item ( id ) NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        complete DATE DEFAULT NULL
    );
    -- 1 down
    DROP TABLE todo_log;
    DROP TABLE todo_item;
    DROP TYPE todo_interval;

% end

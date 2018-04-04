---
title: Populate To-do List - Todo App - Yancy Tutorial
links:
    prev:
        href: add-yancy.html
        title: 4. Add and configure Yancy
    next:
        href: display-todo-list.html
        title: 6. Display the to-do list
template: tutorial-page.html
---

# Build the Todo List

Now that we have some items in our to-do list, we need to display the
list of the things we should do today. To do that, we first need to
figure out which things in our todo list can be done today. We created
a table for this, `todo_log`, and now we need to populate that table
with things to do.

For that, we're going to use the
[DateTime::Event::Recurrence](http://metacpan.org/pod/DateTime::Event::Recurrence)
module, and a Mojolicious helper.  Helpers are little subroutines that
are available throughout the Mojolicious application, and are created
using the `helper` method of the app. Let's create some code that will
generate log items for a given date.

Our code will take a todo item (which has a period and an interval) and a date
and ensure that a log item exists (creating a new log item with a start date
and an end date if necessary). For example, for a daily task, if we give it
the date "2018-02-14", it will look for a log item with a start date of
"2018-02-14" and if not, create one with start date of "2018-02-14" and an end
date of "2018-02-14". For a weekly task, if we give it the date "2018-02-14"
(which is a Wednesday), it will look for a log item with a start date of
"2018-02-12" (the previous Monday). If that doesn't exist, it will create a log
item with a start date of "2018-02-12" and an end date of "2018-02-18".

To build the todo log item, we'll need to go through a few steps:

1. Build a DateTime::Event::Recurrence object to find the start date of
   the new todo log item
2. Calculate the end date of the new todo log item
3. Check to see if a log item for the given todo item, start date, and
   end date exists
4. Create a log item for the given todo item, start date, and end date
   (if necessary)

Finally, we'll need a routine to loop over all our todo items and build
log items for it.

## Build a DateTime::Event::Recurrence object

For the first step, we need a routine that will configure
a DateTime::Event::Recurrence object for our todo item. This is how
we'll calculate the new start date for our log entry.
DateTime::Event::Recurrence has different constructors for each kind of
recurrence: `daily` for daily, `weekly` for weekly, and `monthly` for
monthly. So, we could write a subroutine like this:

    sub _build_recurrence {
        my ( $todo_item ) = @_;
        if ( $todo_item->{ period } eq 'day' ) {
            return DateTime::Event::Recurrence->daily(
                interval => $todo_item->{ interval },
            );
        }
        elsif ( $todo_item->{ period } eq 'week' ) {
            return DateTime::Event::Recurrence->weekly(
                interval => $todo_item->{ interval },
            );
        }
        elsif ( $todo_item->{ period } eq 'month' ) {
            return DateTime::Event::Recurrence->monthly(
                interval => $todo_item->{ interval },
            );
        }
    }

But we've got a lot of repetition here. Each block varies only in the method
being run. So, let's refactor this to reduce the repetition. It will increase
maintainability and improve our ability to add features. We can reduce the
repetition with a mapping of the todo item period (`day`, `week`, `month`) to
the method we need to call (`daily`, `weekly`, `monthly`).

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

## Calculate the log end date

Next, we will need a routine to calculate the end date for a todo log entry
from the todo item and its start date: A daily item should be shown for a day,
a weekly item should be shown for a week, and a monthly item should be shown
for the entire month. Here's the code to do that:

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

Since we'll be showing an item for every day between its start and end dates,
inclusive, we make a weekly item's end date 6 days away and a monthly item's
end date at the last day of the month.

## Check if a log item exists

Now we can build a routine that checks to see if a log item exists. This
time we're going to build a Mojolicious `helper` so that we have access
to the database helper (our `pg` helper from before). The first argument
to every helper is
a [Mojolicious::Controller](http://mojolicious.org/pod/Mojolicious/Controller)
object which has access to all other helpers.

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

The `query` method runs a SQL query. The first argument to the `query`
method is the SQL query to run, and the remaining arguments are values
to fill in to placeholders (designated in the SQL query by `?`). This
method returns a Mojo::Pg::Results object through which we can access
the results of the query. Since our query only returns one row, we can
just call the `array` method to get that first row, and then access the
first element of that array to get our count. `!!` normalizes this into
a boolean.

## Create a single log item

Now we can build the routine that creates log items (after verifying
that they do not already exist). We're going to build another helper
(because we need the database), and we're going to call some of the
previous functions we made.

    helper ensure_log_item_exists => sub {

This helper will accept a todo item and a DateTime object representing a start
date, and all helpers get a controller object as their first argument

        my ( $c, $todo_item, $start_dt ) = @_;

First, we check to see if a log entry exists with the given id and start date.

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

Finally, if the log entry does not exist, we can insert it. Again we write a
SQL query with some placeholders, we use the `query` method to execute it
passing in our values for our placeholders.

## Build the To-do Log

Last, we can build another helper that will loop over all the todo items we
have and ensure that they have an associated log entry for the given date. This
helper will calculate the start date for the log entry (using
DateTime::Event::Recurrence object we built earlier), and then call our helper
that ensures the log entry exists.

    helper build_todo_log => sub {
        my ( $c, $dt ) = @_;
        $dt //= DateTime->today;

This helper takes a DateTime object, and if it's not given one, it defaults to
building the todo log for today.

    my $sql = 'SELECT * FROM todo_item WHERE start_date <= ?';
    my $result = $c->pg->db->query( $sql, $dt->ymd );
    my $todo_items = $result->hashes;

This time, since our query will return multiple rows, we can quickly get all of
them as an array reference of hashes by using the `hashes` method.

    for my $todo_item ( @$todo_items ) {
        my $series = _build_recurrence( $todo_item );

We loop over our todo items and build the DateTime::Event::Recurrence object.
This object comes with a `current` method that takes a DateTime object for a
given date and gives us a DateTime object for the start of the period that
contains our date. This is our log entry start date. If the date is not inside
of a recurrence, it returns `undef`, so we don't need to show that item.

    if ( my $start_dt = $series->current( $dt ) ) {
        $c->ensure_log_item_exists( $todo_item, $start_dt );
    }

## Running helpers with `eval`

Once we've written this, how do we run it? To start, we can use the Mojolicious
`eval` command to run our helper to test that it works currectly. The `eval`
command loads your app and then runs the code you give on the command line.
Since helpers are also available as methods on the `app` object, we can do
things like `app->build_todo_log` to run our `build_todo_log` helper.

So, we can build the todo log for today using `carton exec ./myapp.pl eval
'app->build_todo_log'`. Then we can go into our database and see that our items
exist.

    $ psql myapp -c 'SELECT * FROM todo_log JOIN todo_item ON todo_item_id = todo_item.id'
     id | todo_item_id | start_date |  end_date  | complete | id |             title             | period | interval | start_date
    ----+--------------+------------+------------+----------+----+-------------------------------+--------+----------+------------
      1 |            1 | 2018-02-22 | 2018-02-22 |          |  1 | Did you brush your teeth?     | day    |        1 | 2018-02-22
      2 |            2 | 2018-02-22 | 2018-02-22 |          |  2 | Did you clean the cat litter? | day    |        1 | 2018-02-22
      3 |            3 | 2018-02-19 | 2018-02-25 |          |  3 | Did you write a blog post?    | week   |        1 | 2018-02-22
      4 |            4 | 2018-02-22 | 2018-02-22 |          |  4 | Did you take your vitamin?    | day    |        1 | 2018-02-22
      5 |            5 | 2018-02-22 | 2018-02-22 |          |  5 | Did you eat breakfast?        | day    |        1 | 2018-02-22
    (5 rows)

Our full code now looks like this:

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
        collections => {
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

    get '/' => 'index';

    app->start;
    __DATA__

    @@ index.html.ep
    %% layout 'default';
    %% title 'My Application';
    Hello, world!

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


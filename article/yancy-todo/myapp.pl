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

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'My Application';
<h1><%= $date->ymd %></h1>
% for my $item ( @$items ) {
<p><%= $item->{title} %></p>
% }

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
    <head><title><%= title %></title></head>
    <body>
        %= content
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

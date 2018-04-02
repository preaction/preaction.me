#!/usr/bin/env perl
use Mojolicious::Lite;
use Mojo::Util qw( unindent trim );
use Mojo::Pg;

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

get '/' => 'index';

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'My Application';
Hello, world!

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

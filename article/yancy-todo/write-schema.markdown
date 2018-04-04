---
title: Create Schema - Todo App - Yancy Tutorial
links:
    prev:
        href: start-lite-app.html
        title: 2. Start a new Mojolicious application
    next:
        href: add-yancy.html
        title: 4. Add and configure Yancy
template: tutorial-page.html
---

# Create the Schema

Before we can develop our web app to manipulate data, we need to figure
out what our data looks like.

> Show me your flowcharts and conceal your tables, and I shall continue
> to be mystified. Show me your tables, and I won’t usually need your
> flowcharts; they’ll be obvious. -- Fred Brooks, The Mythical Man-Month

## Setup Postgres

We could choose a lot of data stores for this simple project: SQLite
would be perfect, MySQL would work fine. We're choosing Postgres for no
particular reason except for the Mojo::Pg project being officially part
of the Mojolicious project.

So, once we've installed Postgres, we'll need to initialize a database
for us to use. If you installed Postgres through your package manager,
it might have come with a default database. If not, Postgres comes with
an `initdb` command which will initialize a database in a directory. For
example, we could run `initdb db` to initialize the database in the `db`
directory. Once the database is initialized, we can run a database
daemon with `pg_ctl -D db -l db.log start`.

Once Postgres is running, we can create a database for our application
with the `createdb` command: `createdb myapp`.

Now we need to populate that database with some tables to store our
data.

## Plan Schema

We need two tables.

1. A place to store things to do and how often we have to do them
2. A place to store the things we did or didn't do

The things to do is going to be the most complicated. Remember, we want
to be able to specify tasks to do every `$n` days, weeks, and months.
So, each thing to do has a day where it's made available to do, and
a period in which we display it. After the period is over, we no longer
display the item.

So we give each to-do item a period: "day", "week", or "month". And an
interval, an integer which says how many periods to skip: "1 day" is
daily, "2 weeks" is bi-weekly. The interval also tells us how long to
display the item: An item that should be done every "2 days" should
appear for one day out of every two, and an item that should be done
every "2 weeks" should appear for one week out of two. Finally, a start
date of when we created this item.

    CREATE TYPE todo_interval AS ENUM ( 'day', 'week', 'month' );
    CREATE TABLE todo_item (
        id SERIAL PRIMARY KEY,
        title TEXT,
        period todo_interval NOT NULL,
        interval INTEGER DEFAULT 1 CHECK ( interval >= 1 ) NOT NULL,
        start_date DATE NOT NULL DEFAULT CURRENT_DATE
    );

Now we need the log of the things we did. This will also be a log of the
things we need to do, and the things we didn't do. Every day we will add
to the log. Each item in the log should have a start and end date, which
represents the period we display the thing. And we should store the day
we completed the thing (which will be `null` if we have not completed
the thing).

    CREATE TABLE todo_log (
        id SERIAL PRIMARY KEY,
        todo_item_id INTEGER REFERENCES todo_item ( id ) NOT NULL,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        complete DATE DEFAULT NULL
    );

Mojo::Pg has an easy way of allowing us to upgrade (and downgrade) our database
called "migrations". To use it, we create a new file in our `__DATA__` section
called `migrations`. Inside that, we create a section called `-- 1 up` to
upgrade to version 1 of our database, and `-- 1 down` to downgrade from version
1 of our database.

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
    DROP TABLE todo_item;
    DROP TABLE todo_log;
    DROP TYPE todo_interval;

Then we have to make Mojo::Pg migrate our database. For that we need
a database connection, which we will create a helper for. Helpers are
subroutines that are available to us throughout our application, and are
frequently used to hold on to database connections and other objects
that we need to interact with a lot. This works well with Perl 5.10's
[`state`](https://perldoc.perl.org/functions/state.html) keyword.

    #!/usr/bin/env perl
    use Mojolicious::Lite;
    use Mojo::Pg;
    helper pg => sub { state $pg = Mojo::Pg->new( 'postgres:///myapp' ) };

Now we can tell Mojo::Pg to automatically migrate, and then tell it where our
migrations are:

    app->pg->auto_migrate(1)->migrations->from_data;

Now if we ever add a version 2 of our database, we will be automatically
migrated to it.

Here's our full app so far:

%= include 'component/collapse.html.ep', title => 'Expand code', content => markdown begin

    #!/usr/bin/env perl
    use Mojolicious::Lite;
    use Mojo::Pg;

    helper pg => sub { state $pg = Mojo::Pg->new( 'postgres:///myapp' ) };
    app->pg->auto_migrate(1)->migrations->from_data;

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

% end

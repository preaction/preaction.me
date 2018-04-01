---
title: Add Yancy - Todo App - Yancy Tutorial
links:
    prev:
        href: write-schema.html
        title: 3. Build the application schema
    next:
        href: populate-data.html
        title: 5. Populate the recurring to-do data
template: tutorial-page.html
---

# Add Yancy

Yancy helps us manage the content on our site. We can use Yancy to
easily add new To-do items to our site.

To add Yancy, we use the Mojolicious::Lite `plugin` function. For Yancy
to work, we need to configure it with our database and tell it to read
our schema to build its forms. Yancy can generate its configuration from
our database schema and give us a rich form to edit our data.

    #!/usr/bin/env perl
    use Mojolicious::Lite;

    helper pg => sub { state $pg = Mojo::Pg->new( 'postgres:///myapp' ) };
    app->pg->auto_migrate(1)->migrations->from_data;

    plugin Yancy => {
        backend => { Pg => app->pg },
        read_schema => 1,
    };

## Using Yancy

With the Yancy plugin added to our site, we can now manage our data from
our website. Start the app using `carton exec ./myapp.pl daemon` and
then navigate to `http://127.0.0.1:3000/yancy` to see the Yancy editor.

![The initial Yancy editor showing the mojo_migrations
table](add-yancy-1.png)

The first thing we see is the first table alphabetically,
`mojo_migrations`. Mojo::Pg uses this to keep track of what database
migrations have been applied. We don't need to use Yancy to manage this,
so we'll go over how to remove this later.

The left-side menu lists all of the tables we have in our database,
which Yancy calls "Collections". Click on the "todo_item" collection to
see the todo item table, and then click on the "Add Item" button to add
new rows.

![The Yancy editor showing the add new item form for new todo
items](add-yancy-2.png)

Yancy has read our database schema and produced a form to edit our todo
items. The `period` field is a dropdown menu to select one of the three
possible periods, and the `interval` field is a numeric input.

## Configuring Yancy

Right now, Yancy only knows what it read from our database. We can give
Yancy more information to make the forms better, adding titles,
descriptions, and additional validations.

Yancy configures collections using [JSON
schema](http://json-schema.org). Each collection corresponds to
a database table and describes a single row in that table. Additional,
Yancy-specific fields help to control Yancy itself. These custom fields
begin with a `x-` to prevent overlap with future JSON schema
development.

First, we'll remove the `mojo_migrations` table. We don't need Yancy to
manage that. For that, we'll use the `x-ignore` Yancy option to tell
Yancy to ignore the `mojo_migrations` collection.

    plugin Yancy => {
        backend => { Pg => app->pg },
        read_schema => 1,
        collections => {
            mojo_migrations => {
                'x-ignore' => 1,
            },
        },
    };

Now if we reload the editor, we'll see only the two tables we want:
`todo_item` and `todo_log`.

XXX

* Title / Description
* property descriptions
* x-list-columns
* example value


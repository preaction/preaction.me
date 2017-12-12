---
tags: mojolicious, web
title: Start a New Yancy App
---
[Yancy](http://metacpan.org/pod/Yancy) is a new content management
plugin for the [Mojolicious web framework](http://mojolicious.org).
Yancy allows you to easily administrate your site’s content just by
describing it using [JSON Schema](http://json-schema.org). Yancy
supports [multiple backends](http://metacpan.org/pod/Yancy::Backend), so
your site's content can be in
[Postgres](http://metacpan.org/pod/Yancy::Backend::Pg),
[MySQL](http://metacpan.org/pod/Yancy::Backend::Mysql), and
[DBIx::Class](http://metacpan.org/pod/Yancy::Backend::Dbic).

For an demonstration application, let’s create a simple blog using
[Mojolicious::Lite](http://mojolicious.org/perldoc/Mojolicious/Lite).
First we need to create a database schema for our blog posts. Let's use
[Mojo::Pg](http://metacpan.org/pod/Mojo::Pg) and its [migrations
feature](http://metacpan.org/pod/Mojo::Pg::Migrations) to create a table
called "blog" with fields for an ID, a title, some markdown, and some
HTML.

%= highlight Perl => "# myapp.pl\n" . include -raw => '01-migrate.pl'

Next we add [the Yancy
plugin](http://metacpan.org/pod/Mojolicious::Plugin::Yancy) and tell it
about our backend and data. Yancy deals with data as a set of
collections which contain items. For a relational database like
Postgres, a collection is a table, and an item is a row in that table.

Yancy uses a JSON schema to describe each item in a collection.
For our `blog` collection, we have four fields:

1. `id` which is an auto-generated integer and should be read-only
2. `title` which is a free-form string which is required
3. `markdown` which is a required Markdown-formatted string
4. `html`, a string which holds the rendered Markdown and is also required

Here's our configured Yancy `blog` collection:

%= highlight Perl => "# myapp.pl\n" . include -raw => '02-yancy.pl'

Yancy will build us a rich form for our collection from the field types
we tell it. Some fields, like the `markdown` field, take additional
configuration: `x-html-field` tells the Markdown field where to save the
rendered HTML. There's plenty of customization options in [the Yancy
configuration documentation](http://metacpan.org/pod/Yancy#CONFIGURATION).

Now we can start up our app and go to <http://127.0.0.1:3000/yancy> to
manage our site's content:

    $ perl myapp.pl daemon
    Server available at http://127.0.0.1:3000

![Screen shot of adding a new blog item with Yancy](adding-item.png)
![Screen shot of Yancy after the new blog item is added](item-added.png)

Finally, we need some way to display our blog posts.  [Yancy provides
helpers to access our
data](http://metacpan.org/pod/Mojolicious::Plugin::Yancy#HELPERS). Let's
use the `list` helper to display a list of blog posts. This helper takes
a collection name and gives us a list of items in that collection:

%= highlight Perl => "# myapp.pl\n" . include -raw => '03-list.pl'

Now we just need an HTML template to go with our route!

%= highlight Perl => "# myapp.pl\n" . include -raw => '04-template.pl'

And then we can test to see our blog post:

    $ perl myapp.pl daemon
    Server available at http://127.0.0.1:3000

![The rendered blog post with our template](blog-post.png)

Yancy provides a rapid way to get started building a Mojolicious
application (above Mojolicious’s already rapid development). Yancy
provides a basic level of content management so site developers can
focus on what makes their site unique.


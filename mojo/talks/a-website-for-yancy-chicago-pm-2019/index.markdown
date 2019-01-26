---
title: A Website For Yancy
layout: reveal.html
data:
    topic_url: preaction.me/mojo
---

<div class="slides">
%= include 'deck/title.html.ep', title => $self->title

<section>

<section>
<h2>A Website For Yancy</h2>
<ul>
<li class="fragment">Project Intro</li>
<li class="fragment">Links</li>
<li class="fragment">Documentation</li>
<li class="fragment">Static Site</li>
</ul>
<aside class="notes">I've been working on my Yancy CMS for more than
a year now, and I decided it needed its own website. Not a huge deal,
but a simple introduction of the project, links to the various project
resources, and the project documentation. Finally, to keep it easy to
maintain, the site should be a static website.</aside>
</section>

<section>
<h1>No Static Site Generator</h1>
<aside class="notes">I could use one of those fancy static website
generators, like the one I wrote (Statocles), but I felt it'd be nice to
show Yancy hosting its own website. By the time I was done, I was very
pleased with how easy and fun the process ended up being.</aside>
</section>

<section>
<h2>A Yancy Markdown Site</h2>
<ul>
<li class="fragment">Mojolicious</li>
<li class="fragment">Yancy</li>
<li class="fragment">(Bootstrap)</li>
<li class="fragment">Mojo::SQLite</li>
</ul>
<aside class="notes">So, I decided to make a Yancy markdown site. Before
I get started with my site, I need to install some modules. I'm using
the Mojolicious web framework, of course, and Yancy. Yancy comes with
the Bootstrap UI library, so I'll use that for styling. I want a simple
site, so I'll use SQLite for a database with Mojo::SQLite. I can install
all these modules from CPAN.</aside>
</section>

<section>
<h1><code>myapp.pl</code></h1>
<pre><code data-noescape class="lang-perl">#!/usr/bin/env perl
use Mojolicious::Lite;
</code></pre>
<aside class="notes">With these modules installed, I can start my
application. The first thing I do is import the Mojolicious::Lite
module. Mojolicious::Lite is the easiest way to use Mojolicious for
small projects (though, if my project grows, I can easily inflate my
script into a full Mojolicious application module).</aside>
</section>

<section>
<h1>Database Schema</h1>
<aside class="notes">The next thing I should do is create my database
schema. Before I do that, I need to connect to my database using
Mojo::SQLite.</aside>
</section>

<section>
<h1><code>db</code> Helper</h1>
<pre><code data-noescape class="lang-perl">#!/usr/bin/env perl
use Mojolicious::Lite;
<span class="fragment">use Mojo::SQLite;</span>
<span class="fragment">helper db => sub {</span>
    <span class="fragment">state $db = Mojo::SQLite->new( 'sqlite:docs.db' );</span>
    <span class="fragment">return $db;
};</span>
</code></pre>
<aside class="notes">I'll write a helper that lets me get my database
connection. Helpers are small utility functions that are available
throughout my Mojolicious app, which is perfect for database
connections.</aside>
</section>

<section>
<h2>Schema Migrations</h2>
<pre><code data-noescape class="lang-perl">app-&gt;db-&gt;migrations-&gt;from_string( &lt;&lt;ENDSQL );
<span class="fragment">-- 1 up</span>
<span class="fragment">CREATE TABLE pages (</span>
    <span class="fragment">path VARCHAR PRIMARY KEY,</span>
    <span class="fragment">markdown TEXT,</span>
    <span class="fragment">html TEXT
);
ENDSQL</span>
<span class="fragment">app-&gt;db-&gt;auto_migrate(1);</span>
</code></pre>
<aside class="notes">Then I can write my schema using Mojo::SQLite
migrations. Migrations are neat because they let me upgrade my database
automatically to change things. I just need to write the SQL to do it.</aside>
</section>

<section>
<h1>Configure Yancy</h1>
<pre><code data-noescape class="lang-perl"
><span class="fragment">plugin 'Yancy', {</span>
    <span class="fragment">backend => { Sqlite => app->db },</span>
    <span class="fragment">read_schema => 1,</span>
    <span class="fragment">collections => {
        pages => {
            properties => {</span>
                <span class="fragment">markdown => {</span>
                    <span class="fragment">format => 'markdown',</span>
                    <span class="fragment">'x-html-field' => 'html',
                },
            },
        },
    },
};</span>
</code></pre>
<aside class="notes"><p>With my database schema ready, I can configure
Yancy. Yancy will provide the UI for me to update my content. For the
most part Yancy can configure itself from my schema, but I have to give
it a database connection to use and tell it to read my schema. I can
also add some annotations to make the editor easier to use!</p>
<p>I add Yancy like any other Mojolicious plugin, using the `plugin`
function. I tell it to use the `Sqlite` backend, and give it my database
connection by calling my `db` helper. Then I tell it to read my schema
from the database.</p>
<p>I need to do one more thing to configure Yancy: I need to tell Yancy how
to take my Markdown and where to put the HTML. Yancy calls tables
"collections", and uses JSON schema to configure them. Since most of the
schema was configured with `read_schema`, I only need to configure the
"markdown" column to say it should be formatted as "markdown" and that
the HTML should be stored in the "html" column.</p>
</aside>
</section>

<section>
<h1>Routes</h1>
<pre><code data-noescape class="lang-perl"
><span class="fragment">get</span> <span class="fragment">'/*id' =&gt; ...;</span>
</code></pre>
<aside class="notes">Last, I need a way to display my pages. To display
content, I need to create a route. Specifically I want a `get` route.
I want the route to find any page I create in the database, so I use
`'/*id'` as the path. The '/' matches the leading slash, and the `*id`
matches the rest of the path, including slashes, and puts it in the "id"
stash variable. More on that later.</aside>
</section>

<section>
<h1>Destination</h1>
<pre class="fragment"><code data-noescape class="lang-perl">get '/*id' =&gt; 'index';</code></pre>
<pre class="fragment"><code data-noescape class="lang-perl">get '/*id' =&gt; sub {
    my ( $c ) = @_;
    $c->render( text => 'Hello' );
};</code></pre>
<aside class="notes">Now I need to configure my route's destination.
I could just give the route a name, which would make Mojolicious render
the named template (with the ".html.ep" extention). I could also give it
a sub, which would allow me to write Perl code to create whatever
response I want. Instead of me writing the code to get the right page
from the database, that code has already been written for me in the
"yancy" controller (Yancy::Controller::Yancy).</aside>
</section>

<section>
<h1>Yancy Controller</h1>
<pre><code data-noescape class="lang-perl">get '/*id' =&gt; {
    <span class="fragment">controller => 'yancy', # Yancy::Controller::Yancy</span>
    <span class="fragment">action => 'get',</span>
    <span class="fragment">collection => 'pages',</span>
    <span class="fragment">template => 'pages',</span>
    <span class="fragment">id => 'index', # Default to index page
};</span>
</code></pre>
<aside class="notes">So, for my route, I'll use the `yancy` controller,
and the `get` action (which is the name of a subroutine in the
Yancy::Controller::Yancy module). The `get` action will display a single
item from the database based on the "id" stash variable, which we have
in our route path. The controller needs to know what `collection` to
use, and I need to give it the name of a template (which I'll create
next). Last, I want to specify a default ID of "index" so that if no
path is given, the user sees my index page. So, with this route, a user
can go to any path on our site, and the application will fetch that page
from the database and display it with the "pages" template.</aside>
</section>

<section>
<h1>Finish the App</h1>
<pre><code data-noescape class="lang-perl"
><span class="fragment">app-&gt;start;</span>
</code></pre>
<aside class="notes">Now I need to write the template, but first I need
to finish the code. The last line of every Mojolicious::Lite app needs
to be `app->start`. That starts the application.</aside>
</section>

<section>
<h1>Template</h1>
<pre><code data-noescape class="lang-perl">__DATA__
<span class="fragment">@@ pages.html.ep</span>
<span class="fragment">%== $item->{html}</span>
</code></pre>
<aside class="notes"><p>Now I can add the template to the file. Mojolicious
allows templates to be in the `DATA` section of our application. Each
file in the data section starts with `@@` and the file name,
`pages.html.ep` (`html` because it's HTML, and `ep` because we're using
the "Embedded Perl" template language, Mojolicious's default).</p>
<p>For this template, all I need to do is display the page's HTML. The
Yancy controller puts the page in the variable `$item`, and I grab the
"html" column from it.</p>
</aside>
</section>

<section>
<h1>Try it out!</h1>
<pre class="fragment"><code data-noescape class="lang-shell">$ perl myapp.pl daemon
<span class="fragment">[Wed Jan 23 23:24:28 2019] [info] Listening at "http://*:3000"
Server available at http://127.0.0.1:3000</span></pre>
<aside class="notes">And that's my application. Now I can start it up
and try it out:</aside>
</section>

<section>
<img src="page-not-found.png">
<aside class="notes">Er... Page not found? Oh, right, we haven't created
an index page yet. Let's do that using the Yancy editor.</aside>
</section>

<section>
<h3>Yancy Editor</h3>
<img src="editor-main.png">
<aside class="notes"></aside>
</section>

<section>
<h3>Add Item</h3>
<img src="editor-add-item.png">
<aside class="notes"></aside>
</section>

<section>
<h3>Item Added</h3>
<img src="editor-item-added.png">
<aside class="notes"></aside>
</section>

<section>
<h3>Index Page</h3>
<img src="index-unstyled.png">
<aside class="notes"></aside>
</section>

</section><section>

<section>
<h1>Up Next</h1>
<ul>
<li class="fragment">Documentation</li>
<li class="fragment">Style</li>
<li class="fragment">Deploy</li>
</ul>
<aside class="notes"></aside>
</section>

</section><section>

<section>
<h1>PODViewer</h1>
Mojolicious::Plugin::PODViewer
<aside class="notes">Rendering the documentation is done by the
PODViewer plugin.</aside>
</section>

<section>
<h1>Add Plugin</h1>
<pre><code data-noescape class="lang-perl"><span class="fragment">plugin 'PODViewer', {</span>
    <span class="fragment">default_module => 'Yancy',</span>
    <span class="fragment">allow_modules => [qw(
        Yancy Mojolicious::Plugin::Yancy
    )],
};</span>
</code></pre>
<aside class="notes">Like the Yancy module, I want to add some
configuration. The default documentation page to display should be the
main 'Yancy' module, and the only modules that should be displayed are
the Yancy modules. Any other module linked in the documentation will be
redirected to MetaCPAN, the main documentation site for CPAN modules.</aside>
</section>

<section>
<h3>Take a Look!</h3>
<img src="perldoc-unstyled.png">
<aside class="notes">By default, the PODViewer plugin takes the path
`/perldoc`, so let's take a look. Holy ugly. Alright. Well, that brings
us to our next issue: Making the site look nice.</aside>
</section>

</section><section>

<section>
<h1>Style</h1>
<ul>
<li class="fragment">Bootstrap Layout</li>
<li class="fragment">Navigation Bar</li>
<li class="fragment">Code Style</li>
</ul>
<aside class="notes"></aside>
</section>

<section>
<h1>Layouts</h1>
<aside class="notes">Layout templates are the Mojolicious way to share
the common site framing between different pages of the site. Things like
the site headers, navigation, footers, sidebars, advertisements, and the
like. Layout templates even have hooks to add extra tags from an
individual page (if, for example, I need to import a special stylesheet
or script on a page).</aside>
</section>

<section>
<h1><code>default</code> Layout</h1>
<pre><code data-noescape class="lang-perl">__DATA__
<span class="fragment">@@ layouts/default.html.ep</span>
</code></pre>
<aside class="notes">Like the pages template, I can add my layout
template to the DATA section. Layout templates are in the `layouts`
directory, so my file name is `layouts/default.html.ep` (the extension
is the same). This is the biggest part of the entire application.
Unfortunately, I don't have the time to introduce Bootstrap and discuss
how its responsive navbars work, but I will point out a few key things
about how to make layout templates.</aside>
</section>

<section>
<h1>Building a Layout</h1>
<pre><code data-noescape class="lang-perl">__DATA__
@@ layouts/default.html.ep
<span class="fragment">&lt;!DOCTYPE html&gt;
&lt;html&gt;
    &lt;head&gt;
        <span class="fragment">&lt;title&gt;&lt;%= title %&gt;&lt;/title&gt;</span>
        <span class="fragment">%= stylesheet "/yancy/bootstrap.css"</span>
</code></pre>
<aside class="notes">1. The layout template surrounds the content, so
this is where you can put the DOCTYPE, the <html> tag, the <head> tag,
and so on. 2. It's a template, so we can use template directives. The
best practice is to use the `title` helper here so that our page can
control the title.
3. Always use the `stylesheet` and `javascript` helpers. These helpers
(to me) read better, but when you pass paths/URLs into them they will
get fixed if you're behind a reverse proxy that lives at a different
path. Not a common scenario, but a difficult one to diagnose.</aside>
</section>

<section>
<h1>Building a Layout</h1>
<pre><code data-noescape class="lang-perl"
>&lt;main class="container"&gt;
    &lt;%= content %&gt;
&lt;/main&gt;
</code></pre>
<aside class="notes">4. The main page content is added to the layout by
the `content` helper. This is the most important part of the layout.</aside>
</section>

<section>
<h1>Content Sections</h1>
<pre class="fragment"><code data-noescape class="lang-perl"
>@@ pages.html.ep
<span class="fragment">% content_for 'head' =&gt; begin</span>
    <span class="fragment">%= javascript 'vue.js'
%% end</span>
</code></pre>
<pre class="fragment"><code data-noescape class="lang-perl"
>@@ layouts/default.html
<span class="fragment">&lt;head&gt;
    %%= content 'head'
&lt;/head&gt;</span>
<span class="fragment">&lt;body&gt;
    %%= content
&lt;/body&gt;</span>
</code></pre>
<aside class="notes">5. If you want to have additional places where the
page can add content to the layout, use the `% content_for $name, '...'`
helper in your page template, and the `content` helper in the layout,
passing in the same name (`%= content $name`)</aside>
</section>

<section>
<h1>Code Style</h1>
<pre><code data-noescape class="lang-css"
><span class="fragment">pre {
    border: 1px solid #ccc;
    border-radius: 5px;
    background: #f6f6f6;
    padding: 0.6em;
}</span>
<span class="fragment">.crumbs .more {
    font-size: small;
}</span>
</code></pre>
<aside class="notes">6. Last, here's my extra CSS rules for making the
docs look better. For well-developed markup, just some CSS changes can
be all you need (so be sure to write good, semantic markup).</aside>
</section>

<section>
<h1>Use the Layout</h1>
<pre><code data-noescape class="lang-perl"
>plugin 'PODViewer', {
    <span class="fragment" data-fragment-index="0">layout =&gt; 'default',</span>
};
get '/*id' => {
    <span class="fragment" data-fragment-index="0">layout =&gt; 'default',</span>
};
</code></pre>
<pre class="fragment"><code data-noescape class="lang-perl"
>app-&gt;defaults({ layout =&gt; 'default' });
</code></pre>
<aside class="notes">Once I create the layout template, I need to tell
the PODViewer plugin to use it, and my route to use it. I can add
`layout => 'default'` in both places, or I can set the default layout
for all pages everywhere using `app->defaults({ layout => 'default' })`.
</aside>
</section>

<section>
<h3>Before/After</h3>
<div style="display: flex">
<img style="height: 50vh" src="index-unstyled.png">
<img style="height: 50vh" src="index-styled.png">
</div>
<aside class="notes"></aside>
</section>

<section>
<h3>Before/After</h3>
<div style="display: flex">
<img style="height: 50vh" src="perldoc-unstyled.png">
<img style="height: 50vh" src="perldoc-styled.png">
</div>
<aside class="notes"></aside>
</section>

<section>
<h3>Before/After</h3>
<div style="display: flex">
<img style="height: 50vh" src="perldoc-code-unstyled.png">
<img style="height: 50vh" src="perldoc-code-styled.png">
</div>
<aside class="notes"></aside>
</section>

</section><section>

<section>
<h1>Static Export</h1>
<ul>
<li class="fragment">Rewrite redirects</li>
<li class="fragment">Prefix <code>/yancy</code></li>
<aside class="notes">To upload my site, first I need to write it as
HTML. There are a lot of ways to do this, but I have some specific
needs:
1. Any links to redirects my site might make need to be rewritten as
links to the redirect's destination
2. Since I will be deploying this to http://preaction.me/yancy, All
of the internal links in my site need to have `/yancy` prepended
This is a bit more than `wget --mirror` can handle, but
Mojolicious includes an amazing DOM library which can make quick
work of a problem like this. And, as luck would have it, someone
(me) already did that work to create the `export` Mojolicious
command.</aside>
</section>

<section>
<h1><code>export</code> Command</h1>
Mojolicious::Command::export
<aside class="notes">To use this, I just install the
"Mojolicious::Command::export" module from CPAN. Now in addition to the
`daemon` command I used before to run my webapp, I have an `export`
command that will export my site as static HTML files</aside>
</section>

<section>
<h1>Run an Export</h1>
<pre><code data-noescape class="lang-shell">$ <span class="fragment">perl myapp.pl export \</span>
    <span class="fragment">--base /yancy \</span>
    <span class="fragment">--to ./deploy</span>
</code></pre>
<aside class="notes">This grabs my index page and writes it to the
"deploy" directory. It then looks at all the links on the index page,
fetches those pages, and writes them to the "deploy" directory, and so
on recursively until all the reachable pages are in the "deploy"
directory. If all you've got is a static, informational website, this
tool is perfect for making a deployable version of it!</aside>
</section>

<section>
<h1>Deploy</h1>
<pre class="fragment"><code data-noescape class="lang-shell"
># [r]ecursive, [v]erbose, [z]ipped, [m]odified dates
# --delete files from destination not in source
rsync -rvzm --delete ./deploy/. \
    preaction.me:/var/www/yancy/.
</code></pre>
<aside class="notes">And now to deploy it, I can use whatever I want:
FTP, SCP, Rsync. I wrote a very small shell script which uses this
`rsync` command to do it:</aside>
</section>

</section>

<section>
<h3>Final Product</h3>
<img src="index-final.png">
<aside class="notes"></aside>
</section>

<!-- Wrap-up -->
<section>
<h1>Questions?</h1>
<ul>
<li>Full slides: <a href="http://preaction.me/mojo">http://preaction.me/mojo</a></li>
<li><a href="myapp.pl">View the app</a></li>
<li><a href="http://mojolicious.org">Mojolicious website</a></li>
<li><a href="http://preaction.me/yancy">Yancy website</a></li>
</ul>
<div style="text-align: center">
    <a href="http://preaction.me">
        <img src="http://preaction.me/images/avatar-small.jpg" style="display: inline-block; max-width: 100%"/>
    </a>
</div>
</section>
</div>


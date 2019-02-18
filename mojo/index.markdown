---
title: Mojolicious - Web Framework
---

# Mojolicious

[Mojolicious](http://mojolicious.org) is a [web
framework](https://en.wikipedia.org/wiki/Web_framework) for the [Perl
programming language](http://perl.org). Easy and powerful, Mojolicious
makes web development fun!

## Projects

### [Yancy - Flexible Content Management](http://preaction.me/yancy)

A content management tool including a mobile-friendly editor for your
database along with controllers and plugins to make building
content-driven websites easy and fun!

### [Statocles - Static site generator](http://preaction.me/statocles)

A static website generator using Mojolicious. Currently
undergoing a rewrite to make it more compatible with Mojolicious and
Yancy for better dynamic content editing.

### [Mercury - WebSocket Message Broker](http://preaction.me/mercury)

Mercury is a [WebSocket](https://en.wikipedia.org/wiki/WebSocket)
[message broker](https://en.wikipedia.org/wiki/Message_broker). It is
built using Mojolicious and allows websites to easily set up common
messaging patterns to enable communication between worker processes on
the backend or between clients on the frontend.

### Plugins

Some plugins I've written for Mojolicious:

* [Mojolicious::Command::export - Export a site to static files](http://metacpan.org/pod/Mojolicious::Command::export)
  A command to crawl a Mojolicious app and write the result as
  a static website.
* [Mojolicious::Plugin::AutoReload - Automatically update pages in web browsers](http://metacpan.org/pod/Mojolicious::Plugin::AutoReload)
  A plugin to make design and content changes less work: Automatically
  reloading any open browser windows when needed.
* [Mojolicious::Plugin::DBIC - Mojolicious &lt;3 DBIx::Class](http://metacpan.org/pod/Mojolicious::Plugin::DBIC)
  A simple plugin to make [the DBIx::Class ORM](https://metacpan.org/pod/DBIx::Class)
  easier to use in Mojolicious.
* [Mojolicious::Plugin::PODViewer - Documentation website](http://metacpan.org/pod/Mojolicious::Plugin::PODViewer)
  This module was forked from the original Mojolicious::Plugin::PODRenderer when that was deprecated.

## Talks

### [A Website For Yancy - A Practical Introduction to Mojolicious](talks/a-website-for-yancy-chicago-pm-2019)

This is a 45-minute talk based on my series of three posts for the [2018
Mojolicious Advent Calendar](http://mojolicious.io): [A Website For
Yancy](https://mojolicious.io/blog/2018/12/17/a-website-for-yancy/), [A
View To A POD](https://mojolicious.io/blog/2018/12/18/a-view-to-a-pod/),
and [You Only Export
Twice](https://mojolicious.io/blog/2018/12/19/you-only-export-twice/).
This talk gets into a bit more detail about how to get started using
Mojolicious.

I gave this talk to [Chicago.PM](http://chicago.pm.org) in January 2019.
For a future version of the talk, I intend to explain route destinations
a little better and explain more about the template syntax.

## Articles

### Mojolicious Blogs

* [Mojolicious &lt;3 DBIx::Class](https://mojolicious.io/blog/2019/02/18/mojolicious-and-dbix-class/) - Introducing [Mojolicious::Plugin::DBIC](http://metacpan.org/pod/Mojolicious::Plugin::DBIC).
* [Writing Reusable Controllers](https://mojolicious.io/blog/2019/01/21/writing-reusable-controllers/) - How to write reusable controllers to minimize the code you have to write.
* [Writing Extensible Controllers](https://mojolicious.io/blog/2019/01/28/writing-extensible-controllers/) - Following after Writing Reusable Controllers, how to subclass controllers.

### 2018 Mojolicious Advent Calendar

I wrote 8 total articles for the calendar, a feat I doubt I will repeat.

1. [Automatic Reload for Rapid Development](https://mojolicious.io/blog/2018/12/02/automatic-reload-for-rapid-development/) - An article about [Mojolicious::Plugin::AutoReload](http://metacpan.org/pod/Mojolicious::Plugin::AutoReload)
2. [Testing Hooks and Helpers](https://mojolicious.io/blog/2018/12/04/testing-hooks-and-helpers/) - Techniques for using [Test::Mojo](http://mojolicious.org/perldoc/Test/Mojo)
3. [Making a list with Yancy](https://mojolicious.io/blog/2018/12/06/making-a-list-with-yancy/) - Another simple webapp with Yancy. A better version of the 2017 article.
4. [Minion Stands Alone](https://mojolicious.io/blog/2018/12/10/minion-stands-alone/) - Using the [Minion job queue](http://mojolicious.org/perldoc/Minion) without a Mojolicious site
5. [Who Watches the Minions](https://mojolicious.io/blog/2018/12/11/who-watches-the-minions/) - Getting data about running Minion system, including [Minion's admin UI](https://mojolicious.org/perldoc/Mojolicious/Plugin/Minion/Admin)
6. [A Website for Yancy](https://mojolicious.io/blog/2018/12/17/a-website-for-yancy/) - The first of a three-part series: Starting a simple Markdown-based website using [Yancy](http://preaction.me/yancy)
7. [A View To A POD](https://mojolicious.io/blog/2018/12/18/a-view-to-a-pod/) - The second part: Using [Mojolicious::Plugin::PODViewer](http://metacpan.org/pod/Mojolicious::Plugin::PODViewer) to view [Perl POD documentation](https://perldoc.pl/perlpod)
8. [You Only Export Twice](https://mojolicious.io/blog/2018/12/19/you-only-export-twice/) - The third and final part: Using [Mojolicious::Command::export](http://metacpan.org/pod/Mojolicious::Command::export) to export the site to static HTML files

### 2017 Mojolicious Advent Calendar

* [Mocking a REST API](https://mojolicious.io/blog/2017/12/08/day-8-mocking-a-rest-api/)
* [Start a new Yancy App](https://mojolicious.io/blog/2017/12/15/day-15-start-a-new-yancy-app/) This was a very early article about [Yancy](http://preaction.me/yancy)

<!-- ## Related Topics -->

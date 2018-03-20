---
title: Setup Carton - Todo App - Yancy Tutorial
links:
    prev:
        href: ./
        title: Introduction
    next:
        href: start-lite-app.html
        title: 2. Start a new Mojolicious Application
template: tutorial-page.html
---

# Setting up a development environment

Before we can start developing an application, we need to set up
a development environment. This will hold all of the files our
application needs.

For this small project, setting up our environment is pretty easy: We
just need to create a new directory, any directory. Whenever we create
a new file, we will put it in this directory.

## Install Libraries with Carton

Our application is going to involve some libraries. We could install those
libraries using `cpan`, but that would put the libraries in global places and
may interfere with our system. We could use
[local::lib](http://metacpan.org/pod/local::lib) to install our modules, but
it'd be nice if we had an easy way to install our modules when we deploy our
app.

For this, we have [Carton](http://metacpan.org/pod/Carton). We can install
Carton once globally (`cpan Carton`) and then use Carton to manage our
dependencies. The `carton install` command will install our dependencies to a
directory, `local`, and then we use `carton exec` to execute commands with our
dependencies.

We define our dependencies in a `cpanfile`. We will need
[Mojolicious](http://mojolicious.org),
[Yancy](http://metacpan.org/pod/Yancy), and
[Mojo::Pg](http://mojolicious.org/perldoc/Mojo/Pg). Since we're making
recurring events, we'll also need to pull in the
[DateTime](http://metacpan.org/pod/DateTime) and
[DateTime::Event::Recurrence](http://metacpan.org/pod/DateTime::Event::Recurrence)
modules.

Create a new file in your application directory named "cpanfile", then
add the following:

    requires 'Mojolicious', '7';
    requires 'Mojolicious::Plugin::Yancy', '1';
    requires 'Mojo::Pg', '4';
    requires 'DateTime';
    requires 'DateTime::Event::Recurrence';

This says we want to use Mojolicious version 7 or higher,
Mojolicious::Plugin::Yancy (the plugin for the Yancy CMS) version 1 or
higher, Mojo::Pg version 4 or higher, and any version of DateTime and
DateTime::Event::Recurrence.

With our `cpanfile` written, we install them with `carton install`.

    $ carton install
    Installing modules using /Users/doug/perl/didio/cpanfile
    Successfully installed ExtUtils-Config-0.008
    Successfully installed ExtUtils-InstallPaths-0.011
    Successfully installed ExtUtils-Helpers-0.026
    Successfully installed Module-Build-Tiny-0.039
    Successfully installed File-ShareDir-Install-0.11
    Successfully installed Mojolicious-7.60
    Successfully installed JSON-Validator-1.08
    Successfully installed Mojolicious-Plugin-OpenAPI-1.23
    Successfully installed Yancy-0.015
    ...

Carton reports on every distribution that it installs as it goes.
Notice that we have a lot of modules we didn't define. These are the
dependencies of our dependencies, and Carton installs them, too.

Carton installs everything to the `local` directory. To see the modules
in this directory, we can run the `carton exec` command. For example, to
read the documentation for Mojolicious, we can run `carton exec perldoc
Mojolicious`.


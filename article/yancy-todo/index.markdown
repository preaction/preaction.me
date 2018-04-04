---
title: Todo App - Yancy Tutorial
links:
    next:
        href: setup-carton.html
        title: 1. Setting up a Development Environment
---

# Todo App - Yancy Tutorial

This tutorial shows how to get started using the [Mojolicious web
framework](http://mojolicious.org) with the [Yancy content management
system](http://metacpan.org/pod/Yancy). The tutorial walks through
starting a new Mojolicious application in a development environment
using [Carton](https://metacpan.org/pod/Carton), setting up
a [Postgres](http://postgresql.org) database with
[Mojo::Pg](http://mojolicious.org/perldoc/Mojo::Pg), configuring and
using Yancy to manage content, and building a basic To-Do list web
application.

## Introduction

I want to build an app that helps me remember the little things I should
be doing. It should be able to:

* Store a list of to-do items with different time periods and
  frequencies
* List all of the items that could be done today
* Allow clicking a button to complete the item

I should be able to navigate between days to see what I have to do
tomorrow, or fix something I missed yesterday.

![The completed todo list app](index.png)

## Prerequisites

This tutorial assumes that you already have Perl 5 installed on your
system. Mojolicious requires at least Perl 5.10, which is included by
default in most Linux distributions. [See learn.perl.org for help
installing Perl](https://learn.perl.org/installing/)

Once you have Perl installed, you should also install
[the Carton module](http://metacpan.org/pod/Carton) from CPAN. [See
Modern Perl for help installing CPAN
modules](http://www.modernperlbooks.com/books/modern_perl_2016/02-perl-community.html#VGhlQ1BBTg)

This tutorial assumes you have some basic Perl knowledge. [Perl.org has
free online books for learning Perl no matter your programming skill
level](http://www.perl.org/books/library.html). I recommend [Beginning
Perl](http://www.perl.org/books/beginning-perl/) if you are just
starting out in programming, and [Modern
Perl](http://www.onyxneon.com/books/modern_perl/index.html) or
[Impatient Perl](http://www.perl.org/books/impatient-perl/) if you have
experience with other programming languages.

You should be able to run commands from a command-line. This is how
we'll run the application we build.

## Chapters

1. [Set up a development environment](setup-carton.html)
2. [Start a new Mojolicious application](start-lite-app.html)
3. [Build the application schema](write-schema.html)
4. [Add and configure Yancy](add-yancy.html)
5. [Populate the recurring to-do data](populate-data.html)
6. [Display the to-do list](display-todo-list.html)
7. [Mark to-do items as completed](mark-todo-completed.html)
8. [Navigate between dates](navigate-todo-list.html) -- Up next
9. [Design a UI with Bootstrap](bootstrap.html) -- In progress
10. [Write tests with Test::Mojo](automated-tests.html) -- Not started
11. [Configure and Deploy](deploy.html) -- Not started

%= include 'component/pager.html.ep'


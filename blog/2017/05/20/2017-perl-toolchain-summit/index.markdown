---
tags: perl, cpantesters
title: 2017 Perl Toolchain Summit
links:
    canonical: http://blogs.perl.org/users/preaction/2017/05/2017-perl-toolchain-summit.html
---

This year I had one goal for [CPAN Testers](http://cpantesters.org):
Replace the current [Metabase API](http://metabase.cpantesters.org) with
a new API that did not write to Amazon SimpleDB. The current
high-availability database that raw incoming test reports are written is
Amazon SimpleDB behind an API called Metabase.
[Metabase](http://metacpan.org/pod/Metabase) is a highly-flexible data
storage API designed to work with massive, unstructured data sets and
still allow for sane organization and storage of data. Unfortunately,
Amazon SimpleDB is as it says on the tin: Simple. Worse, it's expensive:
Like most Amazon services, it charges for usage, so there's a huge
incentive for CPAN Testers to use it as little as possible (which made
some of the code quite obtuse).

So, I made a plan to excise the Metabase. Since we already cached every
raw test report locally in the CPAN Testers MySQL database, I planned to
write a new Metabase API that wrote directly to the cache, and then
adjust the backend processing to read from the cache. I spent the better
part of a month working through all the Metabase APIs, how the data was
stored in the database, and how to translate between a simple JSON
format and the serialized Metabase objects. However, some proper schema
design prevented me from finishing this project: A single `NOT NULL`
column could not be changed to allow nulls very easily, it being a 600GB
table. The one time where a well-designed schema was a bad thing!

But then [Garu](https://github.com/garu), author of
[cpanm-reporter](https://metacpan.org/pod/cpanm-reporter) and
[CPAN::Testers::Common::Client](https://metacpan.org/pod/CPAN::Testers::Common::Client)
came up with an idea to make a new test report format. These new reports
would have to be stored in a new place, and I discovered that [MySQL had
recently started building some rich JSON
tooling](https://dev.mysql.com/doc/refman/5.7/en/json.html). Making
a new JSON test report format and storing it in our new
high-availability MySQL cluster seemed like a perfect solution for
storing our raw test reports.

After a few weeks of discussion, I finally realized that it would be an
easier task to make a backwards-compatible Metabase API write to the new
test report MySQL table, even though it increased the amount of work
that needed to be done:

* Complete the new test report format schema (Garu)
* Write the new backwards-compatibility Metabase API (Me)
* Write a new test report processor that writes to the old Metabase
  cache tables (Joel Berger)
* Write a migration script from the old Metabase cache tables to the new
  test report JSON object (?)

With that plan, I headed for Lyon.

---

I lucked out on the plane ride to Dublin: The middle seat was
unoccupied, giving me and my nearest flightmate some much-desired space.
While on the plane I was able to add some [more documentation about the
CPAN Testers Rex deploy
process](https://github.com/cpan-testers/cpantesters-deploy/blob/master/Rexfile)
and [documentation about the Vagrant VM
setup](https://github.com/cpan-testers/cpantesters-deploy#cpantesters-deploy).

Once the summit started, Garu and I discussed the new test report
format. With a new format, we would be able to handle more useful
structured data like a distribution's computed prerequisites, and the
output from each step of the install process. We could even build in
a way to handle other reports for other languages (like Perl 6). We were
both on the same page in making an [OpenAPI schema](http://openapis.org)
for the API, and were able to quickly talk through some changes to the
report format to make it easier to query. It's really valuable to be
able to sit next to someone from 1/4 around the world and hack out
a solution to a problem, and thanks to all the sponsors of the Perl
Toolchain Summit for making it happen.

With the report format mostly settled, Garu set to changing [the CPAN
Testers API server](https://github.com/cpan-testers/cpantesters-api) to
accept incoming reports in the new format, and I started editing [the
CPAN Testers database
schema](https://github.com/cpan-testers/cpantesters-schema) to have
a place to store the new reports.

For the database, I needed a way to keep track of database versioning
and automate upgrading. Since CPAN Testers uses [the DBIx::Class Perl
ORM](http://metacpan.org/pod/DBIx::Class), there are a few ways to do
it. The recommended, fully-featured way is
[DBIx::Class::DeploymentHandler](http://metacpan.org/pod/DBIx::Class::DeploymentHandler),
which I intended to use via [App::DH](https://metacpan.org/pod/App::DH).
Unfortunately, a few hours later I decided that it was entirely too
feature-rich for my taste, and I ended up using the standard
[DBIx::Class::Schema::Versioned](https://metacpan.org/pod/DBIx::Class::Schema::Versioned)
(after only a few hours of headache getting it to deal with the database
that currently exists). That complete, I built [a Rexfile to deploy the
schema](https://github.com/cpan-testers/cpantesters-schema/blob/master/Rexfile)
and was able to move on to the API.

With the rest of the week I was able to get the [new API for submitting
test
reports](http://api.cpantesters.org/docs/?url=/v3#!/Report/v3_report_post)
done, which Garu will be using in new releases of the various CPAN
Testers reporters (via
[CPAN::Testers::Common::Client](https://metacpan.org/pod/CPAN::Testers::Common::Client)).
Joel Berger is writing the backend processing for the new test reports
to write their data to all the existing data tables and files (the last
piece of the puzzle). I'll let them both talk in more detail about what
they were doing.

The last thing I was able to accomplish was the Metabase shim API for
old CPAN Testers reporters to write to the new test reports tables. This
means that for all existing reporters nothing changes: The reports must
flow. I was able to run some tests with Chris Williams (BinGOS), the
current leader in incoming test reports, and the shim API seems to be
ready to go. Over the next few weeks, I'll complete the last task (a
tail log that <http://fast-matrix.cpantesters.org> can use), and then
start asking some testers to switch over (via `/etc/hosts`) before
re-pointing the metabase.cpantesters.org DNS to the shim API for
everyone.

Altogether, I accomplished quite a bit in Lyon, and the city itself was
amazing. Thanks to the organizers, Neil Bowers, Philippe Bruhat, and
Laurent Boivin. And special thanks to the sponsors that make it all
possible: [Booking.com](http://www.booking.com),
[ActiveState](http://www.activestate.com), [cPanel](https://cpanel.com),
[FastMail](https://www.fastmail.com),
[MaxMind](https://www.maxmind.com/en/home), [Perl
Careers](https://opensource.careers/perl-careers/),
[MongoDB](https://www.mongodb.com),
[SureVoIP](http://www.surevoip.co.uk), [Campus
Explorer](http://www.campusexplorer.com),
[Bytemark](https://www.bytemark.co.uk),
[CAPSiDE](http://capside.com/en/), [Charlie
Gonzalez](https://metacpan.org/author/ITCHARLIE),
[Elastic](https://www.elastic.co), [OpusVL](http://opusvl.com), [Perl
Services](http://www.perl-services.de/),
[Procura](https://www.procura.nl/), [XS4ALL](https://www.procura.nl/),
[Oetiker+Partner](http://www.oetiker.ch/).

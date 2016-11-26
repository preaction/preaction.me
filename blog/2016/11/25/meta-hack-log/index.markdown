---
tags: perl, cpantesters
title: meta::hack log
links:
    canonical: http://blogs.perl.org/users/preaction/2016/11/metahack-log.html
---

Last week, I attended meta::hack, the [MetaCPAN](http://metacpan.org) hackathon
in Chicago. I'm the maintainer for [CPAN Testers](http://cpantesters.org), the
central database for CPAN users to send in test reports on CPAN distributions
and one of MetaCPAN's data sources. I asked to join them so I could improve how
MetaCPAN consumes CPAN Testers data, and ensure the stability and reliability
of that consumption.

Here's a detailed log of what I was able to accomplish, and information on the
new development of CPAN Testers.

---

## Day 1 - Thursday

Day 1 began bright and early, Thursday morning. We all got settled in to one of
ServerCentral's conference rooms, passed out extra keyboards and monitors, and
got ourselves to work.

My goals for the hackathon were to build an API for MetaCPAN to use to obtain
CPAN Testers release summary data: The little bits of CPAN Testers data on the
left-hand side of a release page on MetaCPAN. The existing API for this had
been causing us some trouble over the last year or so, and it was time to fix
it once and for all.

To do this, I started documenting the CPAN Testers database in a
[DBIx::Class](http://metacpan.org/pod/DBIx::Class) schema. This served a few
purposes: I got to go through the database, understand all the data inside,
look to see where the data was being generated, and document everything in an
easy-to-use ORM. Now that we have this, making new APIs for the data will be
extremely easy.

## Day 2 - Friday

Starting with day 2, I realized that I had not written a single test for the
DBIx::Class schema I had written, so I had no clue whether it worked or not.
The early morning was spent fixing this oversight. Once the tests were written
and the schema debugged, I released [the first CPAN::Testers::Schema to
CPAN](https://metacpan.org/release/PREACTION/CPAN-Testers-Schema-0.001).

As is the case with free software, I immediately got constructive feedback on
the release: [Dan Book](https://github.com/Grinnz) and [Karen
Etheridge](https://github.com/karenetheridge) helped make the `dist.ini` file
(the [Dist::Zilla](http://metacpan.org/pod/Dist::Zilla) configuration file
which manages my releases to CPAN) better for future releases. Thanks to both
of them!

With the schema ready, I could finally start building the CPAN Testers release
API. This API exposes the release summary data which shows how many test result
passes and failures a single CPAN release has. So, if I want to know how many
test results were submitted with pass or fail on my newly-released
distribution, I can ask the release API. This can be helpful for CPAN author
dashboards, and is used by MetaCPAN to display the results right in with the
module documentation.

For this API, I picked a couple modern web technologies:

* [Mojolicious](http://mojolicious.org) is a modern web framework for modern
Perl. It's efficient and asynchronous from the ground-up, which is useful for
transferring large quantities of data (like CPAN Testers).  *
[OpenAPI](https://www.openapis.org) is a JSON web API specification (similar to
WSDL for XML). The API definition file describes and documents the API for easy
consumption.  *
[Mojolicious::Plugin::OpenAPI](http://metacpan.org/pod/Mojolicious::Plugin::OpenAPI)
reads the OpenAPI specification and produces all the routing necessary for your
web app. This plugin made the API a lot easier to build.

I started by writing the API specification. Unfortunately, the OpenAPI spec can
be fickle, and the error messages that come out of the JSON validator difficult
to discern. Debugging just the spec took me most of the evening. Then I started
writing some tests for the API before we all called it a night.

## Day 3 - Saturday

By Saturday I was finally able to start implementing the Release API. This
involved writing a
[DBIx::Class::ResultSet](http://metacpan.org/pod/DBIx::Class::ResultSet) class
to make querying the release summary table easier. It's almost always better to
make your model layer smarter so that the API it defines for consumers can be
stable, even if the underlying data schema changes. Since there are likely some
schema changes in the future of CPAN Testers, I've been making sure that the
CPAN Testers schema API is as forwards-compatible as I can. This resulted in
the [second release of
CPAN::Testers::Schema](https://metacpan.org/release/PREACTION/CPAN-Testers-Schema-0.002).

During my testing of the new
[CPAN::Testers::Schema::ResultSet::Release](http://metacpan.org/pod/CPAN::Testers::Schema::ResultSet::Release)
module, I finally stumbled across
[DBIx::Class::ResultClass::HashRefInflator](http://metacpan.org/pod/DBIx::Class::ResultClass::HashRefInflator).
This automatically turns your results into hashrefs instead of objects, which
makes them easier to compare with [Test::More's
is_deeply](http://metacpan.org/pod/Test::More#is_deeply). After some confusion,
I [sent in a patch to clarify some
documentation](https://github.com/dbsrgits/dbix-class/pull/111).

With the ResultSet class completed, the API itself was trivial: [less than 50
lines of code makes up the
API](https://github.com/cpan-testers/cpantesters-api/blob/fb9ecd6f7fd3ab5c07460fd08d0e444785c3ea62/lib/CPAN/Testers/API/Controller/Release.pm#L61-L107).
The combination of DBIx::Class and Mojolicious::Plugin::OpenAPI is wonderful.

By midday, I had released [the first version of
CPAN::Testers::API](https://metacpan.org/release/PREACTION/CPAN-Testers-API-0.001).
Now all that remained was figuring out how to deploy it, which was easier said
than done.

I'd been [previously working on a CPAN Testers deployment with
Rex](http://preaction.me/blog/2016/04/30/perl-qa-hackathon-cpantesters/) at the
[2016 Perl QA Hackathon in Rugby](http://act.qa-hackathon.org/qa2016/). Using
Rex to install [perlbrew](http://perlbrew.pl), a brand-new modern Perl 5.24,
and set up [a local::lib](http://metacpan.org/pod/local::lib) was easy. [The
CPAN Testers
Rexfile](https://github.com/cpan-testers/cpantesters-deploy/blob/master/Rexfile)
also sets up a `cpantesters` user which will run all our apps with reduced
privileges.

I decided that the central Rexfile in [the cpantesters-deploy
repository](https://github.com/cpan-testers/cpantesters-deploy) would set up
machines, install the right Perl, install the right OS prereqs, and prepare the
machine for working in a CPAN Testers role (with minor adjustments for the
particular role). The Rexfile in the individual application (like [the Rexfile
in
CPAN::Testers::API](https://github.com/cpan-testers/cpantesters-api/blob/master/Rexfile))
would deploy the application. This way the project managers can give access to
deploy individual apps to anyone, and changes made to an app can be easily
deployed when completed.

The key part of any good devops strategy is being able to test the deployment.
I was pleased that [Vagrant](https://www.vagrantup.com) made it amazingly easy
to spin up a small VM to test the CPAN Testers deployment. [A simple
configuration in a
Vagrantfile](https://github.com/cpan-testers/cpantesters-deploy/blob/master/Vagrantfile),
[a special "environment" in the
Rexfile](https://github.com/cpan-testers/cpantesters-deploy/blob/5cf6809b6fee0542a136dcd3f6c28ff338af6dbc/Rexfile#L47-L54),
and now I can test deployments over and over until they work the way I want.

## Day 4 - Sunday

On Sunday, I woke up to a broken CPAN Testers: The Metabase, the
highly-available destination database for incoming test reports, was filled up.
Metabase presently uses [Amazon SimpleDB](https://aws.amazon.com/simpledb/),
which has a hard limit on the size of a database. You can have up to 250
databases in an account, though, so we just need to manually switch over to a
new database. This happens about once every year, and is just one of the
annoyances of SimpleDB. After this was fixed, I was able to return to working
on the release API.

There was a performance problem with the API: Asking for all the releases took
about a minute, which is fine. Asking for a single dist's releases, or a single
author's releases took less time, which was great. But asking for all the
releases updated since a certain date/time took hours before I simply gave up.
I tried adding some new indexes, and I tried playing around with the query, but
nothing I did could [improve this query's performance to acceptable
levels](https://gist.github.com/preaction/4e94f77f16d5cd4fd9953eac5579ae96).
So, for now, querying for all releases since a certain date/time is disabled.
Likely the solution is to denormalize the data just a little to add a date/time
field to the release summary, but that will have to wait for another day.

So after removing that small part of the API, and fixing some other bugs, I
[released the second version of the
CPAN::Testers::API](https://metacpan.org/release/PREACTION/CPAN-Testers-API-0.002).
With that done, all I needed was an acceptable deployment strategy: The API
daemon needs to start, automatically restart if stopped, log to a predictable
location, and all of this needs to be deployed without root privileges.

I've used [the BSD daemontools](https://cr.yp.to/daemontools.html) before, and
this seems right up its alley: Make the original init system (in this case,
systemd) run the `svcscan` utility as the non-root user to scan a directory
that the non-root user has access to. Any services written to this directory
get automatically started. The non-root user has complete control over
everything without needing root privileges, and I get to avoid messing around
with the system's initd (whatever that happens to be).

In the years since I've done this, some new options have appeared, like
[runit](http://smarden.org/runit/),
[s6](http://skarnet.org/software/s6/index.html), and
[nosh](https://jdebp.eu/Softwares/nosh/index.html). Unfortunately, before I
could finish my research, it was time to go. The current front-runner seems
like nosh, which means the final step before unleashing this API on the world
is just writing a nosh service bundle and some remote monitoring.

---

Altogether, this was a greatly productive hackathon. It was great to see the
MetaCPAN folks, and meet a couple new ones. Thanks to my employer,
[ServerCentral](http://servercentral.com), for giving me the time, and to all
the sponsors for making this happen.

The next steps for me are documenting all the to-do items that I stumbled
across or left unfinished in the [CPAN Testers API issue
tracker](https://github.com/cpan-testers/cpantesters-api/issues) and [the CPAN
Testers Schema issue
tracker](https://github.com/cpan-testers/cpantesters-schema/issues). These
to-do items will be written in the issue tracker so that anyone who wants to
help contribute can do so. There is quite a lot of things to do for CPAN
Testers, and every little bit can help! If you'd like to contribute, you can
talk to us on [#cpantesters-discuss on
irc.perl.org](https://chat.mibbit.com/?channel=%23cpantesters-discuss&server=irc.perl.org)
or e-mail me at <doug@preaction.me>.

This hackathon wouldn't have been possible without the overwhelming support of
our sponsors. Our platinum sponsors were [Booking.com](https://www.booking.com)
and [cPanel](http://cpanel.com/). Our gold sponsors were
[Elastic](https://www.elastic.co/), [FastMail](https://www.fastmail.com/), and
[Perl Careers](http://Perl.careers/). Our silver sponsors were
[ActiveState](http://www.activestate.com/perl), [Perl
Services](http://www.perl-services.de), and
[ServerCentral](https://www.servercentral.com/). Our bronze sponsors were
[Vienna.pm](https://www.meetup.com/Vienna-Perl-Mongers/),
[Easyname](http://easyname.at/), and the [Enlightened Perl Organisation
(EPO)](https://www.enlightenedperl.org/). Please take a moment to thank them
for helping our Perl community.


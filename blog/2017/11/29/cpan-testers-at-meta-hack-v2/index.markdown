---
status: published
tags:
  - perl
  - cpantesters
links:
    canonical: http://blogs.perl.org/users/preaction/2017/11/cpan-testers-at-metahack-v2.html
title: CPAN Testers at meta::hack v2
---
Two weeks ago, I was invited to [meta::hack v2, the second annual
MetaCPAN hackathon](https://metacpan.org/about/meta_hack). As the
primary maintainer of [CPAN Testers](http://cpantesters.org), I went to
continue improving the integration of CPAN Testers data with MetaCPAN
and generally improve the performance of CPAN Testers to the benefit of
the entire [Perl](http://perl.org) ecosystem.

---

The first task on my plate was to complete the main task I started at
last year's meta::hack: Make [MetaCPAN](http://metacpan.org) consume
CPAN Testers data via [the CPAN Testers
API](http://api.cpantesters.org). Fortunately, the MetaCPAN team has [a
Vagrant VM for developing on
MetaCPAN](https://github.com/metacpan/metacpan-developer). After about
an hour getting set up, I was able to start hacking.

But getting set up hit a snag: On my machine and my machine only, the VM
could not reach the Internet, but the parent machine could. Luckily,
[Carton, a module manager for
Perl](https://github.com/perl-carton/carton), has the `carton bundle`
command which will fetch all the necessary module tarballs. From there,
I could transfer all of the modules to the VM and then use `carton
install --cached --deployment` to install from the tarballs. Problem
solved!

From there, it was a quick task to write
[MetaCPAN::Script::CPANTestersAPI](https://github.com/metacpan/metacpan-api/blob/master/lib/MetaCPAN/Script/CPANTestersAPI.pm),
make the MetaCPAN API integration tests pass, and [open
a PR](https://github.com/metacpan/metacpan-api/pull/765).

Next, I set about moving the CPAN Testers CPAN mirror to relieve some
I/O pressure from the main machine. This new machine was graciously
donated by [ByteMark](http://bytemark.co.uk), who has been hosting us
for years. I spent all of Friday writing the appropriate Rex tasks to
deploy the CPAN mirror and enable the BackPAN sync scripts, and thanks
to [Mohammad Anwar (manwar)](http://www.manwar.org) for helping to test
the BackPAN mirror to make sure it's working correctly.

Along with the CPAN/BackPAN mirror, this new machine is also running the
backend processing for test reports. This has improved the performance
of the report processing tasks, which are now able to process incoming
test reports almost instantly. Thanks to Rex, it was trivial to move the
backend processes from the main machine to this new machine. 

Just before the hackathon, [Sebastien Riedl](https://twitter.com/kraih)
(author of [Mojolicious](http://mojolicious.org)) released [a Minion UI
application](https://twitter.com/kraih/status/931580527483682818).
I spent Saturday morning making
[Minion::Backend::mysql](http://metacpan.org/pod/Minion::Backend::mysql)
work well enough to show the UI and try it out. Unfortunately, the MySQL
Minion backend needs a bit more work before it will function properly
(see [this Github issue for Minion-Backend-mysql to help fix this
problem](https://github.com/preaction/Minion-Backend-mysql/issues/15)).

Finally on Saturday I worked with [Graham Knop
(haarg)](https://github.com/haarg) in tracking down a problem that
started earlier in the day: Test reports with ASCII control characters
would completely break the database. It turns out that MySQL would
accept the JSON with escaped low-byte ASCII characters (0x00-0x1f), but
when reading it back, would not re-escape them as JSON requires.
A proper JSON decoder rightly died trying to process it, which I fixed
by re-escaping the JSON using a custom DBIx::Class deserializer
(released as [CPAN::Testers::Schema
v0.020](https://metacpan.org/release/PREACTION/CPAN-Testers-Schema-0.020)).

On the last day I was able to work with [Leo Lapworth
(ranguard)](http://leo.cuckoo.org) to set up some custom error pages for
Fastly to hopefully cut down on the number of people asking me about the
downtime that comes with an overloaded machine, and especially a JSON
error page for the API server to make it easier for users.

Meanwhile, [Nick Tonkin](http://github.com/1nickt) added some new
features to the CPAN Testers API, including being able to limit the
results from the test release summary API by distribution maturity (dev
or stable) and soon the API will be able to limit the results to only
the latest version of the distribution. So, it will be possible to say
"[give me the test summary for the latest stable release of all dists on
CPAN](https://github.com/cpan-testers/cpantesters-api/issues/9)". As
part of this, Nick implemented [a `limit` query parameter to limit
results
returned](https://github.com/cpan-testers/cpantesters-api/pull/18) and
[the `maturity` parameter to show only stable or dev releases in the
results](https://github.com/cpan-testers/cpantesters-schema/pull/15).
Thanks to Nick for all his help so far!

I spent the rest of the last day working through a problem with the new
backend server that ended up being incompatible
[Sereal](http://metacpan.org/pod/Sereal) versions. Unfortunately because
of this, I wasn't able to get to some of the stuff I wanted to. But I've
created Github issues for all the remaining tasks, and anyone is welcome
to help contribute to CPAN Testers.

Some tasks left over from this hackathon:

* [Create Perl development release dashboard (Bleadperl Breaks
  CPAN)](https://github.com/cpan-testers/cpantesters-web/issues/12)
* [Generate list of Perl versions from CPAN
  mirror](https://github.com/cpan-testers/cpantesters-backend/issues/7)
* [Create CPAN Testers development
  VM](https://github.com/cpan-testers/cpantesters-deploy/issues/21)
* [Add OAuth2 authentication for Perl
  auth0](https://github.com/cpan-testers/cpantesters-web/issues/13)
* [Migrate release data script to new backend
  module](https://github.com/cpan-testers/cpantesters-backend/issues/12)
* [Add lint process for verifying CPAN uploads
  table](https://github.com/cpan-testers/cpantesters-schema/issues/16)
* [Add lint process for verifying release summary
  table](https://github.com/cpan-testers/cpantesters-schema/issues/17)
* [Move common database configuration to configuration/deploy
  repository](https://github.com/cpan-testers/cpantesters-deploy/issues/22)

Thanks to all the sponsors of meta::hack v2:
[Booking.com](https://booking.com), [cPanel](https://cpanel.com),
[ServerCentral](https://servercentral.com), and
[Kritika](https://kritika.io). Sponsoring events like this is how [CPAN
Testers](http://cpantesters.org) a huge help to maintaining and
enhancing the CPAN Testers project.

---
tags: cpantesters, perl, hackathon
links:
    canonical: http://blogs.perl.org/users/preaction/2017/11/helping-cpan-testers-during-metahack-v2.html
title: Help CPAN Testers During meta::hack v2
---
Would you like to help [CPAN Testers](http://cpantesters.org) during
[meta::hack
v2](http://www.olafalders.com/2017/10/12/announcing-metahack-v2/)? [Join
us on IRC in #cpantesters-discuss on
irc.perl.org](https://chat.mibbit.com/?channel=%23cpantesters-discuss&server=irc.perl.org),
[join our mailing list on
lists.perl.org](https://lists.perl.org/list/cpan-testers-discuss.html),
or e-mail me directly at <doug@preaction.me>.

With [meta::hack
v2](http://www.olafalders.com/2017/10/12/announcing-metahack-v2/) only
two weeks away, I’ve written down my todo list for the hackathon. With
another brand-new machine graciously provided by
[ByteMark](https://www.bytemark.co.uk), who have been hosting CPAN
Testers for years, this year’s hackathon will involve more devops tasks
to improve reliability and stability of the various parts of the
project.

The new server will be the host for [CPAN Testers backend
processes](http://github.com/cpan-testers/cpantesters-backend), the
processes that turn the raw incoming data into the various reports used
by the websites and downstream systems. It will also be the new home for
the [CPAN](http://cpan.org) and [BackPAN](http://backpan.perl.org)
mirrors that CPAN Testers uses for data, and provides to external users
as part of [CPAN’s mirrors list](http://mirrors.cpan.org).

---

But though this will be the main goal, it is not the only goal. I hope
to finish up the retirement of the SQLite data release process in favor
of the new APIs that were developed last year. This means reducing the
work the server needs to do, removing some code that would otherwise
need maintenance, and streamlining the data flows.

If I have time, I’d like to build a status dashboard for CPAN Testers.
This would allow users to see the current state of the websites and
backend processes, and should improve transparency about the reliability
of the system. I’ve been using [Grafana](http://grafana.org) for charts,
and I hope to be able to export those charts to another set of web pages
on <http://status.cpantesters.com>.

Finally, the Perl 5 Porters have long used CPAN Testers data to measure
the impact of new features, bugfixes, and internal improvements to the
Perl 5 interpreter. Development releases of Perl 5 are used to run the
test suite of CPAN modules, and if long-stable CPAN distributions start
failing, a person will follow up with triage and a report to the Perl
5 Porters. Sometimes this results in a change to the interpreter to fix
the problem. Other times the changes are deemed too important and the
Perl 5 Porters will submit a patch to the distribution author to make
sure it is compatible with the new Perl version. This project is called
"blead Perl breaks CPAN".

James Keenan on the Perl 5 development mailing list has asked for a new
report on CPAN Testers data to make discovering when blead Perl breaks
CPAN easier. This will involve looking for distributions with passing
tests on the latest stable Perl, and failing tests on the latest
development Perl. From that data, a simple web dashboard can be created.
This also involves some database work to ensure we can easily find which
Perl version is the latest.

If you would like to help with any of these tasks, or any other task in
the CPAN Testers projects
([schema](https://github.com/cpan-testers/cpantesters-schema/issues),
[api](https://github.com/cpan-testers/cpantesters-api/issues),
[backend](https://github.com/cpan-testers/cpantesters-backend/issues),
[web](https://github.com/cpan-testers/cpantesters-web/issues),
[deploy](https://github.com/cpan-testers/cpantesters-deploy/issues)),
let me know [on
IRC](https://chat.mibbit.com/?channel=%23cpantesters-discuss&server=irc.perl.org),
[the mailing
list](https://lists.perl.org/list/cpan-testers-discuss.html), or [email
me](mailto:doug@preaction.me) for questions and guidance.

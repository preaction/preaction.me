---
links:
  canonical:
    - !!perl/hash:Statocles::Link
      href: http://blogs.perl.org/users/preaction/2017/07/cpan-testers-has-an-api.html
status: published
tags:
  - web
  - cpantesters
title: CPAN Testers Has an API
---
[[Watch this lightning talk on The Perl Conference YouTube
channel](https://www.youtube.com/watch?v=okeBgBb1Cxs&index=60&list=PLA9_Hq3zhoFxdSVDA4v9Af3iutQxLI14m)]

I've been working on the [CPAN Testers](http://www.cpantesters.org)
project since 2015. In all that time, I've been focused on maintenance
(which has involved more operations/administration tasks than any actual
code changes) and modernization. It's that modernization effort that has
led to a [new CPAN Testers API](http://api.cpantesters.org).

This new API uses [the Mojolicious web
framework](http://mojolicious.org), along with an
[OpenAPI](http://openapis.org) schema to expose all of the most useful
CPAN Testers data. OpenAPI is a specification for web APIs, and there
are tools like [Swagger](swagger) to generate a useful documentation
website from your spec, like the [CPAN Testers API documentation
website](http://api.cpantesters.org/docs/?url=/v3).

---

So, I've used this new API, pulled in a bunch of JavaScript technologies
like [Vue.js for dynamic content](http://vuejs.org) and [HighCharts for
pretty interactive charts](http://highcharts.com), and created [a simple
CPAN Testers chart dashboard](http://beta.cpantesters.org/chart.html).
This dashboard shows the summary of the reports for the last few
versions of a distribution, and if you click on a version bar, you see
a summary of that version's reports broken down by OS, and a list of the
reports. Clicking on the breakdown pie charts will filter the list
below, allowing you to see only the reports you want to see.

As as aside: I've been a web developers since the 90's, but it's only in
the last few years that building dynamic web applications has not been
a frustrating, awful, lengthy experience. I literally put this dashboard
together in 4 hours one night during [The Perl Conference
2017](http://www.perlconference.us/tpc-2017-dc/) (but, to be fair, I've
spent the last 20 years developing the experience to make this web
application in 4 hours).

So, you can see how [the new CPAN Testers
API](http://api.cpantesters.org) lets us build useful web applications
from the CPAN Testers data. I'd love to see more people writing neat
things that use the CPAN Testers data! If you find the API does not have
the data you want, you can add it by submitting a patch to the [CPAN
Testers API project on
Github](http://github.com/cpan-testers/cpantesters-api). If you'd like
to do something with the CPAN Testers data and can't figure out how,
[e-mail me](mailto:doug@preaction.me) or talk to me on IRC [irc.perl.org
#cpantesters-discuss](https://chat.mibbit.com/?channel=%23cpantesters-discuss&server=irc.perl.org)
and I can help! If you really like my very small dashboard and would
like to make it better, you can contribute to it in the [CPAN Testers
Web project on Github](http://github.com/cpan-testers/cpantesters-web).

Thanks to [Breno de Oliviera](http://github.com/garu) and [Joel
Berger](http://github.com/jberger) for their help on the API and the
JavaScript, and thanks to all the [sponsors of the Perl Toolchain
Summit](http://act.qa-hackathon.org/qa2017/sponsors.html) for bringing
us all together, which makes things like this happen!

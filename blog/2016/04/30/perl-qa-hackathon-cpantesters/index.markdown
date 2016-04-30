---
tags: perl, cpantesters
title: 'Perl QA Hackathon - CPANTesters'
---

This year, I was invited to [the Perl QA Hackathon in Rugby,
UK](http://act.qa-hackathon.org/qa2016/). It was wonderful to meet all
the Perl people I'd been interacting with all this time.

My goals going into the hackathon weren't that clear: I've recently
begun adopting [the CPANTesters project](http://www.cpantesters.org),
and I had to take the opportunity to talk with its former leader,
[Barbie](http://missbarbell.co.uk), fix some current issues, and then...

While Barbie fixed [the version summaries and Metacpan
issue](https://github.com/cpan-testers/cpantesters-project/issues/9),
I started work on [an automated deploy for
CPANTesters using Rex](https://github.com/cpan-testers/cpantesters-deploy), which
will allow for reproducible deployments and development virtual
machines, and I began keeping track of the project and future goals in
a [CPANTesters project
meta-repository](http://github.com/cpan-testers/cpantesters-project),
which should help with keeping CPANTesters going as an open community project.
I'll be making future blog posts on both of these, though [I've spoken
about Rex before](http://preaction.github.io/Introduction-to-Rex/).

Thanks to Barbie for 10 years of CPANTesters, and special thanks to
[Capside](http://capside.com) for their donation, both monetary and
avian, as they sent [Oriol Soriano](https://twitter.com/ureesoriano) to
help with some CPANTesters tasks.

And finally, thanks to all the [other sponsors of the
hackathon](http://act.qa-hackathon.org/qa2016/sponsors.html). Without
their support, we couldn't do all the work we do on the Perl ecosystem.

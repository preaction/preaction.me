---
links:
  canonical:
    - !!perl/hash:Statocles::Link
      href: http://blogs.perl.org/users/preaction/2016/11/beamemitter-v1004-released.html
status: published
tags:
  - perl
  - beam
title: Beam::Emitter v1.004 released
---

This week, I released a new version of
[Beam::Emitter](http://metacpan.org/pod/Beam::Emitter). A lot has changed since
the first releases, so here's some details on all the new features.

Beam::Emitter is a role for turning your classes into event emitters. Being an
event emitter allows other classes to subscribe to important events from your
object. Subscribers can use these events to perform additional tasks, transform
your object's data, or otherwise extend and enhance your class. Beam::Emitter
makes your class extensible by allowing you to provide specific places for
custom code to run.

Since the 1.000 release last year, Beam::Emitter has gotten quite a few new
features and bug fixes to make it easier to use and safer for your code.

---

* Beam::Emitter now tracks listeners using a Beam::Listener object. You
  can also create your own custom objects for tracking listeners, which
  allows you to hang arbitrary metadata in your listeners.
* Calling the `subscribe` method (or the `on` alias) to subscribe to an
  event returns a reference to a subroutine that, when called, will
  unsubscribe from the event. Using this subref makes it easier to avoid
  creating memory leaks through circular references when you want to
  unsubscribe from the event in the event handler callback.
* Beam::Emitter no longer pollutes your namespace with things like
  Scalar::Util::weaken and Carp::croak. This makes it less obtrusive,
  though your existing code might die if you were relying on this bad
  behavior by Beam::Emitter (#sorrynotsorry).

I want to thank [Diab Jerius](https://github.com/djerius) (with the Smithsonian
Astrophysical Observatory), [Kent Frederic](https://github.com/kentfredric),
and [Yanick Champoux](https://github.com/yanick) for all their help that has
gone in to this project.

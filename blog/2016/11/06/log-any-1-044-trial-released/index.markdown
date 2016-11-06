---
tags: perl, logging, cpan
title: Log::Any 1.044 TRIAL released
links:
    canonical: http://blogs.perl.org/users/preaction/2016/11/logany-1044-trial-released.html
---

A [new trial of Log::Any (1.044) has been
released](https://metacpan.org/release/PREACTION/Log-Any-1.044-TRIAL).
This release has a couple changes that make Log::Any a bit more
predictable:

* Passing in objects to formatted log methods now handles objects that
  overload stringify correctly. Previously, these objects would be given
  to Data::Dumper, which violates object encapsulation. Thanks [Philipp
  Gortan (@mephinet)](https://github.com/mephinet)!
* The imported Log::Any object (`use Log::Any '$log'`) can now be named
  anything (like `$LOG` or `$foo`).

Since [CPAN Testers](http://www.cpantesters.org) is still catching up
[from its little bit of downtime a few weeks
ago](http://blog.cpantesters.org/diary/203), I won't be releasing this
as stable until I get some success reports in. So, you've got some time
to test this against your own codebase if you need to.  Please [report
any issues to the Log-Any Github
repository](http://github.com/preaction/Log-Any/issues).

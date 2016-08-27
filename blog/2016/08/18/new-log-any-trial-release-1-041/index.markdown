---
tags: perl, logging, cpan
title: New Log::Any Trial Release 1.041
links:
    canonical:
        text: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2016/08/new-logany-trial-release-1041.html
---
I've just released a new [Log::Any](http://metacpan.org/pod/Log::Any)
trial release. This release improves performance immensely when there
are no log output adapters configured. This release also now returns the
formatted log string from logging methods, allowing the log message to
be used by a `die` or `warn` call.

Because of these changes, there is a very small chance of an
incompatibility: Log::Any logging methods used to return whatever the
configured adapter returned (this was undocumented and was not
a feature). Now they always return the formatted log message.

So if you depend on Log::Any, please give
[Log-Any-1.041-TRIAL](http://www.cpan.org/authors/id/P/PR/PREACTION/Log-Any-1.041-TRIAL.tar.gz)
a test run through and report any issues to [the Log-Any Github
tracker](http://github.com/preaction/Log-Any/issues).

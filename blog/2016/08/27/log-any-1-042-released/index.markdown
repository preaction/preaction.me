---
tags: perl, logging
title: Log::Any 1.042 Released
links:
    canonical:
        title: blogs.perl.org
        href: http://blogs.perl.org/users/preaction/2016/08/logany-1042-released.html
---

Since [CPANTesters for Log-Any](http://cpantesters.org/distro/L/Log-Any.html)
are all showing green for [last week's trial
release](http://blogs.perl.org/users/preaction/2016/08/new-logany-trial-release-1041.html),
I've pushed a [new standard release of Log::Any 1.042 to
CPAN](https://metacpan.org/release/PREACTION/Log-Any-1.042).

---

Log::Any is for logging what DBI is for databases and CHI is for caching: A
common interface to allow CPAN libraries to have logging that integrates with
the library user's existing logging.

This release includes a significant performance improvement for when log
outputs are not configured. This means Log::Any is even less obtrusive for use
in CPAN modules. The overhead for a log method that doesn't need to do anything
is down to one method call and one `wantarray` check.

Logging methods now also return the formatted log message (which is why we need
a `wantarray` check). This means we can use the return value in `die` and/or
`warn` calls, like so:

    use Log::Any '$log';
    
    if ( !-e 'config.yml' ) {
        die $log->error( 'config.yml does not exist' );
    }

Doing it this way instead of adding new methods to Log::Any prevents us from
needing to create methods like `error_die`, `warn_die`, `error_warn`,
`warn_warn`, `fatal_die`, `fatal_warn`, and other impractical combinations
(`debug_die`? `emergency_warn`?)

Finally, the default adapter for your logger can now be configured with
arguments. So the simplest way to log to a file (but still allow others to
direct logs elsewhere) would be:

    use Log::Any '$log', default_adapter => [ File => 'myapp.log' ];

So give it a try and add some logging to your CPAN library. If you have any
issues, [report them at the Log::Any project on
Github](http://github.com/preaction/Log-Any)

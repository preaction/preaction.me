---
tags: logging
title: Choosing a Log Level
links:
    canonical: http://blogs.perl.org/users/preaction/2017/03/choosing-a-log-level.html
---
Like all subjective decisions in technology, which log level to use is
the cause of much angry debate. Worse, different logging systems use
different levels: [Log4j has 6 severity
levels](https://en.wikipedia.org/wiki/Log4j#Log4j_log_levels), and
[Syslog has 8 severity
levels](https://en.wikipedia.org/wiki/Syslog#Severity_level). While both
lists of log levels come with guidance as to which level to use when,
there's still enough ambiguity to cause confusion.

When choosing a log level, it's important to know how visible you want
the message to be, how big of a problem it is, and what you want the
user to do about it. With that in mind, this is the decision tree
I follow when choosing a log level:

---

1. Can you continue execution after this? If no, use the `error` log
   level. Log4j uses the `FATAL` log level for this, but I find the
   degree of difference between "fatal" and "error" to be too small to
   be useful.
2. Is this a problem the user needs to know about? If yes, use the
   `warn` log level. It's important to think about what the user needs
   to know. The more that falls into this category, the less the user
   will actually see. This is called "alert blindness": The user gets
   conditioned to ignore output from the machine, which can cause real
   problems to go unnoticed.
3. Does this contain technical details or data structures? If no, you
   can use the `info` log level. This log level should be written for
   the non-technical end-user to give high-level descriptions of the
   current phase of execution (or, it should say, plainly and simply,
   what's happening right now). The `info` log level can provide some
   extra context to the errors and warnings, but it should not provide
   technical details only useful to a programmer.
4. Otherwise, use the `debug` log level. The debug log level should be
   the information used by the developer to diagnose and fix the
   problems revealed by the errors and warnings. A non-technical user
   should find little to no useful information at the debug level.

And that's it! I only use 4 log levels. Of the 2 remaining log4j levels,
`fatal` isn't distinct enough from `error` to my taste, and `trace` is
meant for pedantic messages describing entering/leaving every subroutine
(which I refuse to write myself, and haven't used any tool to
auto-generate).

With these rules for which messages are logged at what level, I can
easily decide what logs should be displayed.

* The `debug` level (and all higher levels) are always logged via Syslog
  (no matter what level is being shown on the terminal) and, from there,
  propagated to long-term log storage in files or databases.
* The terminal gets, by default, the `warn` log level, but a user can
  pass in flags to change what they see. These command-line flags are
  easy to achieve with [the Getopt::Long Perl
  module](http://metacpan.org/pod/Getopt::Long).
    * `-q` is "quiet" mode, and shows only the `error` log level
    * `-v` is "verbose" mode, and shows the `info` log level
    * `-vv` is "debug" mode, and shows the `debug` log level

These rules result in very sparse program output: If a program is
working perfectly, it will output nothing at all, which is a common
convention in Unix programs.

What to log to the terminal by default is another point of contention:
A lot of people expect a program to be verbose about what it is doing,
and that if a program doesn't say it did what you asked it to do, you
have to double-check. I disagree, but if it becomes a problem, I just
make `info` the default level (never `debug`, as `debug` is too much).

However your project decides to organize its logs,
[Log::Any](http://metacpan.org/pod/Log::Any) can accommodate. To provide
interoperability between Syslog, Log4j (Log4perl), and other logging
systems, Log::Any supports all the severity levels from each system.

Remember that logging is meant to serve a variety of users, including
the end-user, and you as the developer. It can be difficult to serve
both, so some care needs to be taken when choosing what to display, and
like all other subjective things, consistency is key.

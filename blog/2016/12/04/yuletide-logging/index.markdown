---
tags: perl, logging
title: Yuletide Logging
links:
    canonical: http://perladvent.org/2016/2016-12-04.html
---

> 'Twas a night before Christmas and on the ops floor  
> All the servers were humming behind the closed door  
> The app was deployed to the servers with care  
> In hopes that the customers soon would be there  
> When from out of the phone there arose such a clatter  
> I sprang out of my chair to see what was the matter  
> "The website is down!" said the boss with a shout  
> "We need to make money, so figure it out!"  
> I logged in to the server and looked all around  
> But the app had no logging; no reason was found  
> With no other choice, I called the developer  
> Who said "just restart it, I'm sure that'll fix 'er"  
> I ran the right service, up the app came  
> Only to come down again and again  
> If there but was a way to know what was wrong  
> I could fix it for sure, but no logging was found

Good logging is crucial for applications in production. In an emergency,
you will want it to be as easy as possible to track down problems when
they happen. With good logs you can ensure that minor bugs don't cause
major downtime and data loss problems. Good logs can help track down
security issues and can provide an auditable trail of changes to track
down who did what and when.

[Log::Any](http://metacpan.org/pod/Log::Any) is a lightweight, generic API built for interoperable
logging for [CPAN](http://cpan.org) modules. Much like
[DBI](http://dbi.perl.org) allows interoperable database interfaces,
[CHI](http://metacpan.org/pod/CHI) allows interoperable caching
interfaces, and [PSGI](http://plackperl.org) allows interoperable web
applications, Log::Any allows a CPAN module to produce logs that fit
into your environment whether you just want to see logs on your
terminal, you're using [Log4perl](http://mschilli.github.io/log4perl/)
to directly send e-mail alerts to your operations team, or you're using
a local [rsyslog](http://www.rsyslog.com) daemon to transmit logs to an
[ElasticSearch](https://www.elastic.co/products/elasticsearch) instance
via [Logstash](https://www.elastic.co/products/logstash).

---

To achieve this interoperability, Log::Any is split up into two parts:
Producers produce logs using a Log::Any object, and consumers consume those
logs using a Log::Any::Adapter object. First we'll cover how to produce logs,
then we'll cover how to consume them to display logs on your terminal.

## Setting our Application up to Log: Using a Producer

To get started using Log::Any to produce logs, we just need to use and create a
Log::Any object. The simplest way is by creating a single log object for your
program when importing Log::Any:

    use Log::Any '$LOG';

If you've got an object-oriented module, you can load your log object lazily
using the `get_logger` method and store it in your object:

    use Moo;
    use Log::Any;
    has log => ( is => 'lazy', default => sub { Log::Any->get_logger } );

Now that we have a log object, we can start producing logs. By default, they
won't go anywhere, and we'll set up a consumer later. For now, let's just write
some logs to tell our operations staff what's going on in our application.

Log::Any has methods to produce logs at various named severity levels,
including the standard [Log4j-ish
levels](https://en.wikipedia.org/wiki/Log4j#Log4j_Log_Levels) of `fatal`,
`error`, `warning`, `info`, `debug`, and `trace`, and the [Syslog
severity levels](https://en.wikipedia.org/wiki/Syslog#Severity_level)
(which include "critical", "alert", and "emergency"). To emit a log
message, simply call one of these methods with the message as an
argument:

    use DBI;
    use Log::Any '$LOG';

    $LOG->info( "Connecting to database" );
    my $dbh = DBI->connect( 'dbi:SQLite:data.db' );

Log::Any also has a set of formatter methods similar to
[sprintf](http://perldoc.perl.org/functions/sprintf.html) to make formatting
log messages easier. These methods are the same name as the severity level, but
with an "f" at the end (like `errorf()`, `warningf()`, `infof()`, etc...).
These methods take a format string as the first argument, and format the
remaining arguments using the format string (exactly like
[sprintf](http://perldoc.perl.org/functions/sprintf.html)). Any objects given
to these methods will be printed with
[Data::Dumper](http://perldoc.perl.org/Data/Dumper.html) for quick debugging.

The log message is returned by the log method and can be used further, for
example, to throw an exception with
[die](http://perldoc.perl.org/functions/die.html) after writing a log message
with `errorf()`, or to use [warn](http://perldoc.perl.org/functions/warn.html)
to ensure the log message is seen on STDERR even if you're logging to a file.

    use DBI;
    use Log::Any '$LOG';

    $LOG->info( "Connecting to database" );
    my $dbh = DBI->connect( 'dbi:SQLite:data.db' );
    if ( !$dbh ) {
        die $LOG->errorf( 'Could not connect to database: %s', $DBI::errstr );
    }
    $LOG->info( "Database connected" );

## Storing the Logs Somewhere: Wiring up a Consumer

> The major difference between a thing that might go wrong and a thing that
> cannot possibly go wrong is that when a thing that cannot possibly go wrong
> goes wrong it usually turns out to be impossible to get at or repair.
> <cite>Douglas Adams</cite>

Now that we have some log lines being written, we need to give them somewhere
to go. Log::Any has a set of "adapters" (in the
[Log::Any::Adapter](http://metacpan.org/pod/Log::Any::Adapter) namespace) that
allow logs written using Log::Any to be written to various places.

For example, if you want to throw logs to `STDERR` on your terminal,
you can set up the "Stderr" adapter:

    use Log::Any::Adapter 'Stderr';

Now when any log line is written, it will go to `STDERR`.

There are adapters to make Log::Any log to syslog, files, and even other
logging systems like [Log::Dispatch](http://metacpan.org/pod/Log::Dispatch) and
[Log::Log4perl](http://metacpan.org/pod/Log::Log4perl). These adapters make
Log::Any a perfect choice for logging in CPAN modules: If the user wants to see
logs, they get to see them in the same way as all other logs in their
application, otherwise, the logging is there when they need it.

The adapter is also where we decide what level of logs we want to see.
Some adapters handle this with their own configuration, like
Log::Dispatch and Log::Log4perl. For our simple example, we need to
handle it ourselves. Let's allow our operations staff to set the
`LOG_LEVEL` environment variable, and have it default to `warn`.

    use Log::Any::Adapter 'Stderr', log_level => $ENV{LOG_LEVEL} || "warn";

That's all there is to getting started using Log::Any. For those concerned
about bloating their dependency tree, Log::Any has no non-core dependencies.
For those who value backwards-compatibility, Log::Any is supported back to very
early versions of Perl 5.8 (and if it is broken for versions before that,
[patches are welcome](http://github.com/preaction/Log-Any)).

> Now that the logging is hung in our program with care  
> I searched for the log file I knew would be there  
> Inside I would find all the things I could know  
> About problems and issues and something to go  
> Now that I know what the problem's about  
> I can fix it for sure so the app just stays up

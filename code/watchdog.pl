
=pod

At [tonight's Chicago Perl Mongers Office
Hours](https://www.meetup.com/ChicagoPM/events/239053113/), Ray came up
with an interesting problem. While testing all of CPAN for [CPAN
Testers](http://www.cpantesters.org), how do you detect when a test is
hanging and kill it before it takes down the entire machine? How do you
simply kill a test that is taking too long? And how do you do it without
having a wholly separate watchdog program?

Ray's using
[Parallel::ForkManager](http://metacpan.org/pod/Parallel::ForkManager)
to execute testing jobs in parallel across multiple Perl installs. There
are a few ways we could implement timeouts, including
[IPC::Run](http://metacpan.org/pod/IPC::Run)'s `timeout` function, or
the [`alarm`](http://perldoc.perl.org/functions/alarm.html) Perl
built-in, but these must all be implemented in the child process. It'd
be nicer if we could use the parent process to watch its own children.

Here, then, is the result of that hacking: This code spawns 5 workers at
a time to sleep for a random number of seconds between 1 and 20. If the
child worker is alive for longer than the 10 second timeout (a 50%
chance), it is forcibly killed.

When enough workers have been spawned, we check on all of our workers to
see if they've lived long enough. Once a worker has finished, or been
killed, and has been reaped, we can then start another worker.

With this code, hopefully we can prevent some of the test suites for
CPAN distributions from forcing the tester to reboot their machine.

=cut

    use v5.24;
    use warnings;
    use Parallel::ForkManager;

    my $TIMEOUT = 10; # How long a child is running before it should be killed

    my @jobs = 1..20; # How many fake jobs to run

    my $pm = Parallel::ForkManager->new( 5 ); # 5 max workers

    # Hash of PID => time started or last known good
    my %watching;

    # While there is still work to do, or there are still active workers
    while ( @jobs || $pm->running_procs ) {

        # Check to see if any workers are finished
        $pm->reap_finished_children;

        # Check to see if any workers need to be killed because of the
        # timeout. We must do this if we've reached the limit of the number
        # of jobs we want (we wait for a slot to open up), or if we've got
        # no more work to give out.
        if ( $pm->running_procs >= $pm->max_procs || !@jobs ) {
            say sprintf "[%5s] %2s: Checking jobs (%d running, %d left)", '-----', '--', scalar $pm->running_procs, scalar @jobs;
            for my $pid ( $pm->running_procs ) {
                if ( $watching{ $pid }{ time } + $TIMEOUT < time ) {
                    # XXX: You can add a concern check here to see if it's
                    # still working on something and reset the timeout
                    # instead of killing the child. To reset the timeout,
                    # just set the current time: $watching{ $pid } = time;

                    # Kill the child
                    # We're being unforgiving here. You might want to use
                    # 'TERM' instead
                    kill 'KILL', $pid;
                    say sprintf "[%5d] %2d: Killed at %d", $pid, $watching{ $pid }{ job }, time;
                }
            }

            # Sleep for much less than the timeout. This means we could have
            # a process that runs for up to 25% over the timeout. Our actual
            # timeout is between 10 and 13 seconds.
            sleep $TIMEOUT * 0.25;
            next;
        }

        # Start a new job
        my $job = shift @jobs;
        my $pid = $pm->start;

        # Parent process: Start tracking the job worker
        if ( $pid ) {
            # Add to the watchdog timer
            $watching{ $pid }{ time } = time;
            $watching{ $pid }{ job } = $job;
            next;
        }

        # Child process: Start the job
        say sprintf "[%5d] %2d: Started Job at %d", $$, $job, time;
        srand; # Reinitialize the random number in children
        my $time = int ( rand() * ( $TIMEOUT * 2 ) );
        say sprintf "[%5d] %2d: Sleeping for %d", $$, $job, $time;
        sleep $time;
        say sprintf "[%5d] %2d: Finished!", $$, $job;

        # Child process: Finished successfully
        $pm->finish;
    }

    $pm->reap_finished_children;

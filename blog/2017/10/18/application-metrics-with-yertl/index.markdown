---
tags: yertl, devops
title: Application Metrics with Yertl
links:
    canonical: http://blogs.perl.org/users/preaction/2017/10/application-metrics-with-yertl.html
---

A time series database is a massively useful tool for system reporting
and monitoring. By storing series of simple values attached to
timestamps, an ops team can see how fast their application is
processing data, how much traffic they're serving, and how many
resources they're consuming. From this data they can determine how well
their application is working, track down issues in the system, and plan
for future resource needs.

There have been a lot of new databases and tools developed to create,
store, and consume time series data, and existing databases are being
enhanced to better support time series data.

With the new release of [ETL::Yertl](http://preaction.me/yertl), we can
easily translate SQL database queries into metrics for monitoring and
reporting. I've been using these new features to monitor the [CPAN
Testers](http://cpantesters.org) application.

---

To monitor the CPAN Testers project, I need to make sure that incoming
test reports are being processed into useful data. When a report is
written to the database, a summary must be generated for building ad-hoc
reports on the website. An easy way to know if the application is
processing data is to look at the count of the raw reports and the count
of the processed report summaries and compare the two. If those two
values keep increasing, the application is processing reports.

Since our data is stored in a MySQL database, this is a pretty easy
query:

    SELECT UNIX_TIMESTAMP(), COUNT(*) FROM test_report; -- raw reports
    SELECT UNIX_TIMESTAMP(), COUNT(*) FROM cpanstats; -- processed reports

If those queries are run every 5 minutes and the results stored in
a time series database, I will have a record of how much data is
processed over time. With this data, I can set a monitoring system to
alert me when the amount of data processed drops to 0 for too long
(which likely means that something is broken).

There are other metrics like this that provide insight into the CPAN
Testers application. Since I started using
[Minion](http://mojolicious.org/perldoc/Minion) as a job queue, I have
needed to know that Minion is running jobs and completing them
successfully. This data is also easy to get from the MySQL database:

    SELECT UNIX_TIMESTAMP(), COUNT(*) FROM minion_jobs; -- total jobs
    SELECT UNIX_TIMESTAMP(), COUNT(*) FROM minion_jobs WHERE state="inactive"; -- pending jobs
    SELECT UNIX_TIMESTAMP(), COUNT(*) FROM minion_jobs WHERE state="finished"; -- finished jobs
    SELECT UNIX_TIMESTAMP(), COUNT(*) FROM minion_jobs WHERE state="failed"; -- failed jobs

Going to various places in your application and counting things is
a very common kind of data to store in a time series. So common, that
I was surprised when I couldn't find a tool that could easily do it.
Then I remembered that I had written a good tool to read from SQL
databases: [ysql](http://preaction.me/yertl/pod/ysql/), part of
[ETL::Yertl](http://preaction.me/yertl/).

Using the `--count` option, I could easily count the number of records
in a table:

    # SELECT COUNT(*) FROM test_report
    $ ysql --dsn dbi:mysql:localhost --count test_report
    ---
    value: 3450981

    # SELECT COUNT(*) FROM cpanstats
    $ ysql --dsn dbi:mysql:localhost --count cpanstats
    ---
    value: 83671432

The `--count` option also allows the `--where` option to limit the count
to rows that match the given SQL `WHERE` clause. So I can get counts of
the total number of Minion jobs, the pending jobs, the finished jobs,
and the failed jobs:

    ysql --dsn dbi:mysql:localhost --count minion_jobs
    ysql --dsn dbi:mysql:localhost --count minion_jobs --where 'state="inactive"'
    ysql --dsn dbi:mysql:localhost --count minion_jobs --where 'state="finished"'
    ysql --dsn dbi:mysql:localhost --count minion_jobs --where 'state="failed"'

All I needed is a tool to write to time series databases. With
[ETL::Yertl](http://preaction.me/yertl/)
[v0.35](http://preaction.me/yertl/blog/2017/10/18/release-v0-035/), I've
added the `yts` command. This command can read/write time series values
in YAML documents, like this:

    ---
    metric: cpantesters.report_count
    timestamp: 2017-01-01T00:00:00
    value: 83081421
    ---
    metric: cpantesters.report_count
    timestamp: 2017-01-01T00:10:00
    value: 83081485
    ---
    metric: cpantesters.report_count
    timestamp: 2017-01-01T00:20:00
    value: 83081539

We can also easily write single metric values by giving the metric to
write on the command line. If we don't specify a timestamp, it will
default to now:

    $ yts influxdb://localhost telegraf.cpantesters.report_count <<
    ---
    value: 83081421

So to write my metrics, I just need to combine the `ysql` command and
the `yts` command using shell pipes:

    ysql --dsn dbi:mysql:localhost --count test_report \
        | yts influxdb://localhost telegraf.cpantesters.report_count
    ysql --dsn dbi:mysql:localhost --count cpanstats \
        | yts influxdb://localhost telegraf.cpantesters.stats_count
    ysql --dsn dbi:mysql:localhost --count minion_jobs \
        | yts influxdb://localhost telegraf.minion.total_jobs
    ysql --dsn dbi:mysql:localhost --count minion_jobs --where 'state="inactive"' \
        | yts influxdb://localhost telegraf.minion.pending_jobs
    ysql --dsn dbi:mysql:localhost --count minion_jobs --where 'state="finished"' \
        | yts influxdb://localhost telegraf.minion.finished_jobs
    ysql --dsn dbi:mysql:localhost --count minion_jobs --where 'state="failed"' \
        | yts influxdb://localhost telegraf.minion.failed_jobs

Now I can run these as cron jobs to poll the status of the CPAN Testers
application and send myself an alert (configured with
[Grafana](http://grafana.org) when something looks wrong!

Right now, `yts` supports both [InfluxDB](https://www.influxdata.com)
(used by CPAN Testers) and [Graphite](http://graphiteapp.org) (used by
many). If you need support for another time series database, submit
a patch for your adapter! If you're using a SQL database as time series
storage, submit a patch for that!


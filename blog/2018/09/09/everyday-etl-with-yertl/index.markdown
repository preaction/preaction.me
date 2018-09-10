---
links:
    canonical: http://blogs.perl.org/users/preaction/2018/09/everyday-etl-with-yertl.html
tags: etl, yertl
status: published
title: Everyday ETL With Yertl
---

I use [ETL::Yertl](https://metacpan.org/pod/ETL::Yertl) a lot. Despite its
present unpolished state, it contains some important, easy-to-use tools that I
need to get my work done. For example, this week I got an e-mail from Slaven (a
CPAN tester and a tireless reporter of CPAN issues found by testing) saying
that some records were missing from one the APIs on [CPAN
Testers](http://cpantesters.org): The
[fast-matrix](http://fast-matrix.cpantesters.org) had 3300 records for the
"forks" distribution version 0.36, but the
[matrix](http://matrix.cpantesters.org) had only 300 records. The utilities in
[ETL::Yertl](https://metacpan.org/pod/ETL::Yertl) made it easy to find and
manipulate the data I needed to diagnose this problem.

---

My first step in diagnosing this was to try to find the data in the database.
So, I used [`ysql`](https://metacpan.org/pod/distribution/ETL-Yertl/bin/ysql)
to query the database for a count of the records in the `cpanstats` table for
the "forks" distribution matching version "0.36".

    doug@cpantesters3:~$ export DSN="dbi:mysql:dbname=cpanstats;mysql_read_default_file=$HOME/.cpanstats.cnf"
    doug@cpantesters3:~$ ysql --dsn "$DSN" --count cpanstats --where 'dist="forks" and version="0.36"'
    ---
    value: 3293

Then I needed to compare that to the API that the Matrix is using. I fetched
the JSON array from the API using `curl`, parsed it into YAML using [`yfrom
json`](https://metacpan.org/pod/distribution/ETL-Yertl/bin/yfrom), and then
counted the number of records in the array using
[`yq`](https://metacpan.org/pod/distribution/ETL-Yertl/bin/yq)'s `length`
function:

    doug@laptop:~$ curl http://www.cpantesters.org/distro/f/forks.json | yfrom json | yq '{ value: length }'
    ---
    value: 321

So there's a discrepancy: The database has 3293 records, but the API only has
321 records. Let's also check the new API from <http://api.cpantesters.org> to
try to narrow the scope of the problem:

    doug@laptop:~$ curl http://api.cpantesters.org/v3/summary/forks/0.36 | yfrom json | yq '{ value: length }'
    ---
    value: 3293

Since the new API has the same number of records as the database, now I know
it's a problem specifically with the API that the Matrix is using. This API is
a bunch of statically-generated files from back when disk space was cheap, CPU
and memory were extremely expensive, and loading CGI applications was costly.
So some part of this data is not being written to the static files.

Slaven's e-mail says that there were no records from before 2018-02-10. Maybe
it was a specific report that had a problem and caused only the reports after
it to be generated. I found what report it was using by downloading the file,
parsing the JSON into YAML, flattening the array (`.[]`), slicing the hashes
inside to get only the `fulldate`, `id`, and `guid` fields, turning that into a
CSV with [`yto csv`](https://metacpan.org/pod/distribution/ETL-Yertl/bin/yto)
which I then sort by the first field (`fulldate`).

    doug@laptop:~$ curl http://www.cpantesters.org/distro/f/forks.json | yfrom json | yq '.[] | { fulldate: .fulldate, id: .id, guid: .guid }' | yto csv | sort -t, -k1 | head -3
    201802101425,3ae9e620-0e6e-11e8-a10e-9d908e183046,91949984
    201802101443,ce1d059c-0e70-11e8-a10e-9d908e183046,91950270
    201802121326,e7611678-6c71-1014-a17f-d9730956514b,92013272

A quick glance at that summary row doesn't reveal anything clearly wrong with
the data, nor does looking at the row before it.

In the end, the most likely scenario here is that the file got deleted at some
point and then when it was regenerated, only some of the data made it. Now I
just need to find out how to regenerate these files, and the problem is fixed!

The Yertl toolkit isn't finished, but it has some useful tools for simple,
dirty, data plumbing operations. The more I use Yertl, the more I see it could
help me, and the more I think to add to it to make it even more useful (clearly
I need a better hash slice syntax for `yq`, for example, and probably a sort
function).

Try Yertl out yourself and let me know what I can do to make it more useful to
you!

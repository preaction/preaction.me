---
tags:
  - yertl
  - perl
title: 'ygrok - Parse plain text into data structures'
---

As a data warehouse, a significant part of my job involves log analysis.
Besides the standard root cause analysis, I need to verify database
writes, diagnose user access issues, and look for under-used (and
over-used) data sets. Additionally, my boss needs quarterly and yearly
reports for client billing, and some of our clients need usage reports
to identify data they might be paying for but not using (which we can
then shut off to reduce costs). This has recently become a popular space
for new solutions.

On the other side, as a sysadmin, I need to get other reports like how
all the machine's resources (CPU, memory, disk, network) are being used,
what processes are running on the machine and how those processes used
resources over time. This is basic monitoring, and there are lots of
solutions here, too. In the true Unix philosophy, there are command-line
programs to query every one of these, which write out text that I can
then parse.

In [my previous post about
ysql](/blog/2015/01/21/managing-sql-data-with-yertl.html), I showed how
to use the `ysql` utility to read/write YAML documents to SQL databases.
Now, [Yertl](http://preaction.me/yertl) has a [`ygrok`
utility](/yertl/pod/ygrok) to parse plain text into YAML documents.

---

## Parsing HTTP Logs

We provide websites for our users to use, so we've got a lot of HTTP
logs to analyze. The ygrok utility parses lines of plain text using
patterns. Since HTTP is such a common thing, `ygrok` has a built-in
pattern to parse HTTP logs: `%{LOG.HTTP_COMBINED}`.

So let's parse our access log. Lines of text come in, and YAML documents
come out:

    $ ygrok '%{LOG.HTTP_COMBINED}' indiepalate.com.access.log
    ---
    content_length: '711'
    http_version: '1.1'
    ident: '-'
    method: GET
    path: /site.yml
    referer: '-'
    remote_addr: 73.8.132.101
    status: '200'
    timestamp: 25/Feb/2015:21:59:29 -0500
    user: '-'
    user_agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/600.3.18 (KHTML, like Gecko) Version/8.0.3 Safari/600.3.18
    ---
    content_length: '162'
    http_version: '1.1'
    ident: '-'
    method: GET
    path: /
    referer: '-'
    remote_addr: 123.125.71.49
    status: '403'
    timestamp: 25/Feb/2015:22:30:25 -0500
    user: '-'
    user_agent: Mozilla/5.0 (Windows NT 5.1; rv:6.0.2) Gecko/20100101 Firefox/6.0.2

Okay, there's a lot of data here, so how about we look at just the 404
codes? For that, we can use [the `yq` utility](/yertl/pod/yq) to select
only those lines that have a `status` of `404`:

    $ ygrok '%{LOG.HTTP_COMBINED}' indiepalate.com.access.log | \
        yq 'select( .status == 404 )'
    ---
    content_length: '162'
    http_version: '1.1'
    ident: '-'
    method: GET
    path: /favicon.ico
    referer: http://preaction.me/
    remote_addr: 73.8.132.101
    status: '404'
    timestamp: 25/Feb/2015:22:52:53 -0500
    user: '-'
    user_agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_2) AppleWebKit/600.3.18 (KHTML, like Gecko) Version/8.0.3 Safari/600.3.18

Good! But there's still a lot of output here: A bunch of fields we're
not interested in. How about we only show the paths and referrers for
those 404s? [The `ymask` utility](/yertl/pod/ymask) can prune our document to
only the essentials.

    $ ygrok '%{LOG.HTTP_COMBINED}' indiepalate.com.access.log | \
        yq 'select( .status == 404 )' | ymask 'path,referer'
    ---
    path: /favicon.ico
    referer: http://preaction.me/
    ---
    path: /favicon.ico
    referer: http://indiepalate.com/
    ---
    path: /favicon.ico
    referer: '-'
    ---
    path: /cart/4e73ae84869760656b002b83
    referer: '-'
    ---
    path: /cart/4eea6ed38697600553000544
    referer: '-'

Better! But we've got a lot of duplicate paths, it'd be nice to group
the results by the missing path. We can use the `yq` utility again to
group our results by the path.

    $ ygrok '%{LOG.HTTP_COMBINED}' indiepalate.com.access.log | \
        yq 'select( .status == 404 )' | ymask 'path,referer' | \
        yq 'group_by( .path )' \
        >404.yml

Now we can open our processed output and see all the proxy and common
attacks people are throwing at our server. The web is a dark and
dangerous place indeed...

Here's some people assuming I'm an incompetent administrator. Not that I
blame them, there are lots of those out on the web. They're looking for
the phpmyadmin setup files, which should not be open to users after the
initial setup is complete (I hope...).

    /admin/phpmyadmin/scripts/setup.php:
    - path: /admin/phpmyadmin/scripts/setup.php
      referer: '-'
    - path: /admin/phpmyadmin/scripts/setup.php
      referer: '-'
    /admin/pma/scripts/setup.php:
    - path: /admin/pma/scripts/setup.php
      referer: '-'
    - path: /admin/pma/scripts/setup.php
      referer: '-'

And here's some actual problems I found. Why are my markdown files
getting requested? They shouldn't even get deployed to the server...
Something weird's going on that demands some follow-up...

    /2015/05/10/taco-chicken-bowls/index.markdown:
    - path: /2015/05/10/taco-chicken-bowls/index.markdown
      referer: '-'
    /2015/05/17/spinach-and-mushroom-alfredo/index.markdown:
    - path: /2015/05/17/spinach-and-mushroom-alfredo/index.markdown
      referer: '-'
    - path: /2015/05/17/spinach-and-mushroom-alfredo/index.markdown
      referer: '-'
    /2015/05/24/kettle-corn/index.markdown:
    - path: /2015/05/24/kettle-corn/index.markdown
      referer: '-'
    - path: /2015/05/24/kettle-corn/index.markdown
      referer: '-'
    /2015/05/31/tequila-lime-shrimp/index.markdown:
    - path: /2015/05/31/tequila-lime-shrimp/index.markdown
      referer: '-'

## Parsing Command Output

HTTP logs aren't the only plain text I have to deal with. Since most
common Unix utilities output plain text, we can also parse that into
documents.  For example, I can parse the output of the `ps -u` command
using the `%{POSIX.PSU}` pattern.

    $ ps au | ygrok '%{POSIX.PSU}'
    ---
    command: -zsh
    cpu: '0.0'
    mem: '0.0'
    pid: '441'
    rss: '1036'
    started: Mon11AM
    status: S
    time: 0:01.09
    tty: s000
    user: doug
    vsz: '2500680'
    ---
    command: vim blog/2015/11/24/new-post/index.markdown
    cpu: '0.0'
    mem: '0.2'
    pid: '61761'
    rss: '20832'
    started: 6:05PM
    status: S+
    time: 0:24.55
    tty: s004
    user: doug
    vsz: '2514172'

For monitoring purposes, I want to keep track of processes running every
minute. So let's use [ysql](/yertl/pod/ysql) to build a
database to hold the information from `ps`:

    $ ysql --config psdb --dsn dbi:SQLite:ps.db
    $ ysql psdb 'CREATE TABLE process ( command VARCHAR, pid INTEGER,
        time VARCHAR, cpu DOUBLE, mem DOUBLE, rss INT, vsz INT,
        started VARCHAR, status VARCHAR, tty VARCHAR, user VARCHAR )'

Now we can pipe our parsed documents into our database:

    $ ps u | ygrok '%{POSIX.PSU}' | ysql psdb --insert process

And then we can run some queries on it, like give me all the processes
whose virtual size (vsz) is greater than 2.5gb:

    $ ysql psdb --select process --where 'vsz > 2500000'
    ---
    command: vim blog/2015/11/24/new-post/index.markdown
    cpu: 0
    mem: 0.3
    pid: 61761
    rss: 21344
    started: 6:05PM
    status: S+
    time: 0:40.34
    tty: s004
    user: doug
    vsz: 2514172

Or how about all the processes that were running at the time we took our
poll:

    $ ysql psdb --select process --where 'status LIKE "%R%"'
    ---
    command: ygrok %{POSIX.PSU}
    cpu: 0.1
    mem: 0
    pid: 68335
    rss: 236
    started: 7:10PM
    status: R+
    time: 0:00.00
    tty: s005
    user: doug
    vsz: 2423360

Well, that output should've been obvious. Of course `ygrok` is running while
I'm parsing the output from `ps`...

## Custom Patterns

So we can parse some preset formats, HTTP, and `ps` output. Now, what if
we want to parse arbitrary text?

Under-the-hood, `ygrok` is just a Perl regular expression. The `%{...}`
syntax calls up one of the stored patterns, but we can make our own
pattern if we want.

So let's parse a PF log, which logs packets as they go through the
packet filter firewall. The log looks like this:

    $ tcpdump -n -e -ttt -r /var/log/pflog
    Mar 19 14:53:53.740926 rule def/(short) pass in on em0: 192.187.107.2.0 > 208.86.227.106.0: SRPE 1159643658:1159643722(64) ack 0 win 0 (DF)
    May 01 03:11:45.868059 rule def/(short) pass in on em0: 70.38.64.233.0 > 208.86.227.106.0: FR [bad hdr length] (DF)
    Jun 05 12:23:13.708854 rule def/(short) pass in on em0: 154.46.33.210.0 > 208.86.227.106.0: . 3162804040:3162804092(52) win 80 (DF)
    Jul 19 16:10:50.154505 rule def/(short) pass in on em0: 198.154.62.56.0 > 208.86.227.106.0: FRE 1542358674:1542358698(24) win 80 urg 0 (DF)
    Oct 10 18:41:15.888810 rule def/(short) pass in on em0: 62.210.220.29.0 > 208.86.227.106.0: . 1466079741:1466079793(52) win 8000 (DF)

Looks like we have a few fields here:

* A timestamp (`Mar 19 14:53:53.740926`)
* The thing that created the log (`rule def/(short) pass in on em0`)
* The source address and port (`192.187.107.2.0`)
* A `>`, likely indicating who initiated the connection
* The destination address and port (`208.86.227.106.0`) followed by a colon
* The reason the packet was logged (`SRPE 1159643658:1159643722(64) ack 0 win 0 (DF)`)

Let's build ourselves an expression to parse this line.

`ygrok` uses named captures (`(?<name>...)`) to assign values to fields,
so the regular expression to match the timestamp will look like this:
`(?<timestamp>\w{3} \d{2} \d{2}:\d{2}:\d{2}\.\d{6})`.

In addition to matching entire lines, `ygrok` comes with some common
patterns we can use, like IPv4 addresses. When using one of these
patterns, we can assign a name to the field by adding a colon and the
field name, like `%{NET.IPV4:src_addr}`. If we want to match the
pattern, but don't want to store it, we can simply leave out the field
name.

Using our own patterns, and the built-in `ygrok` patterns, our full
parser looks like:

    (?<timestamp>%{DATE.MONTH} \d{2} \d{2}:\d{2}:\d{2}\.\d{6})\s+
    (?<rule>[^:]+):\s+
    %%{NET.IPV4:src_addr}\.%{INT:src_port}\s+
    (?<dir>[<>])\s+
    %%{NET.IPV4:dest_addr}\.%{INT:dest_port}:\s+
    %%{DATA:message}

We can either use this directly, or we can save this pattern for later
use by giving our custom pattern a name. Let's call it `%{LOG.PF}`:

    $ ygrok --pattern LOG.PF '(?<timestamp>%{DATE.MONTH} \d{2} \d{2}:\d{2}:\d{2}\.\d{6})\s+(?<rule>[^:]+):\s+%{NET.IPV4:src_addr}\s+(?<dir>[<>])\s+%{NET.IPV4:dest_addr}:\s+%{DATA:message}'

Now we can use it to parse our log:

    $ tcpdump -n -e -ttt -r /var/log/pflog | ygrok '%{LOG.PF}'
    ---
    dest_addr: 208.86.227.106
    dest_port: '0'
    dir: '>'
    message: SRPE 1159643658:1159643722(64) ack 0 win 0 (DF)
    rule: rule def/(short) pass in on em0
    src_addr: 192.187.107.2
    src_port: '0'
    timestamp: Mar 19 14:53:53.740926
    ---
    dest_addr: 208.86.227.106
    dest_port: '0'
    dir: '>'
    message: FR [bad hdr length] (DF)
    rule: rule def/(short) pass in on em0
    src_addr: 70.38.64.233
    src_port: '0'
    timestamp: May 01 03:11:45.868059

As a side note, you can see all the patterns using `ygrok
--pattern`, and you can see categories using `ygrok --pattern LOG` and
individual patterns using `ygrok --pattern LOG.PF`.

So `ygrok` allows parsing of plain text into documents. Then, using the
rest of the Yertl tools, we can manipulate, store, retrieve, aggregate,
and otherwise work with the structured data contained in our logs.

For more information about Yertl, visit [the Yertl
website](http://preaction.me/yertl).

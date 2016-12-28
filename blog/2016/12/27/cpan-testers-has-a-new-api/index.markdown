---
tags: perl, cpantesters
title: CPAN Testers Has a New API
links:
    canonical: http://blogs.perl.org/users/preaction/2016/12/cpan-testers-has-a-new-api.html
---

As part of [the MetaCPAN hackathon,
meta::hack](https://metacpan.org/about/meta_hack), I was invited to work
on the CPAN Testers integration. [CPAN Testers](http://cpantesters.org)
is a community of [CPAN](http://cpan.org) users who send in test reports
for CPAN modules as they are uploaded. [MetaCPAN](http://metacpan.org)
adds a summary of those test reports to every CPAN distribution to help
you determine which module you'd most like to use. For quite a few
months, this integration was broken, and the nature of the current
integration (a SQLite database) means it is not as generally useful as
it could be.

So, I decided that the best way to improve the CPAN Testers / MetaCPAN
integration was to build a [new CPAN Testers
API](http://api.cpantesters.org). This API uses [the CPAN Testers
schema](http://metacpan.org/pod/CPAN::Testers::Schema) to expose CPAN
Testers data using a JSON API. This API is built using [the Mojolicious
web framework](http://mojolicious.org), and an [OpenAPI
specification](http://openapis.org) (using
[Mojolicious::Plugin::OpenAPI](http://metacpan.org/pod/Mojolicious::Plugin::OpenAPI).

---

Documenting the API using the [OpenAPI](http://openapis.org) language
automatically generates the application routes, and makes input and
output validation very simple (all handled by
[Mojolicious::Plugin::OpenAPI](http://metacpan.org/pod/Mojolicious::Plugin::OpenAPI)).
Having the API specification be a simple JSON document also makes it
possible to [automatically generate
documentation](http://api.cpantesters.org/docs) and display it using
[Swagger-UI](http://swagger.io/swagger-ui). The Swagger-UI tool even
allows users to try out the API right in the browser, displays the input
parameters and their documentation, and gives you real output based on
the request you input.

Right now, the CPAN Testers API has access to only some of the data CPAN
Testers has:

* The [/release](http://api.cpantesters.org/docs/?url=/v1#!/Release)
  data collects [test report summaries for all of
  CPAN](http://api.cpantesters.org/docs/?url=/v1#!/Release/release_all),
  or you can limit [releases by
  dist](http://api.cpantesters.org/docs/?url=/v1#!/Release/release_dist)
  or [releases by
  author](http://api.cpantesters.org/docs/?url=/v1#!/Release/release_author)
  (good for making CPAN dashboards).
* The [/upload](http://api.cpantesters.org/docs/?url=/v1#!/Upload) data
  shows [all uploads to
  CPAN](http://api.cpantesters.org/docs/?url=/v1#!/Upload/upload_all),
  which you can limit to [uploads by
  dist](http://api.cpantesters.org/docs/?url=/v1#!/Upload/upload_dist)
  or [uploads by
  author](http://api.cpantesters.org/docs/?url=/v1#!/Upload/upload_author).

These APIs can be easily used by any HTTP client, and since they return
JSON, can be easily manipulated with simple tools like
[`jq`](https://stedolan.github.io/jq/) or
[ETL::Yertl](http://preaction.me/yertl/):

    # Get all test data for every release of the CPAN-Testers-API distribution
    curl 'http://api.cpantesters.org/v1/release/dist/CPAN-Testers-API'

    # Get all Statocles release test data updated since the beginning of 2016
    curl 'http://api.cpantesters.org/v1/release/dist/Statocles?since=2016-01-01T00:00:00'

    # Select all of my releases where there was a failure report
    curl http://api.cpantesters.org/v1/release/author/PREACTION | jq '.[] | select( .fail > 1 )'

    # Build my own database for personal use!
    sqlite3 data.db 'CREATE TABLE release ( dist VARCHAR, version VARCHAR, pass INTEGER, fail INTEGER, na INTEGER, unknown INTEGER )'
    curl http://api.cpantesters.org/v1/release/author/PREACTION | yfrom json | yq '.[]' | ysql --dsn dbi:SQLite:data.db --insert release
    # ... and then find failed dists
    ysql --dsn dbi:SQLite:data.db --select release --where 'fail > 100'

In addition to these standard JSON API calls, the new CPAN Testers API
also provides a WebSocket API for getting push notifications of
important CPAN Testers events. With just a WebSocket and a JSON parser,
you can subscribe to a WebSocket feed of new uploads to CPAN. In the
future, all internal CPAN Testers communication will be done through the
API using the [Mercury message broker](http://preaction.me/mercury) on
the backend, allowing you to use simple WebSockets to build your own
data alerts and updates.

Any WebSocket client can connect to get updates, like so:

    # feed.pl from https://github.com/cpan-testers/cpantesters-api/blob/master/eg/feed.pl
    $ perl feed.pl http://api.cpantesters.org/v1/upload
    Got upload: Mercury (0.011) by PREACTION

Once the message is send on the websocket, the archive is available on
CPAN Testers CPAN mirror (http://cpan.cpantesters.org), so you could
immediately start testing it and sending in reports (hint hint)!

This is just the start of what this API could be made to do. If you'd
like to use some CPAN Testers data, but it is not yet available from the
API, check [our contributing
guide](https://github.com/cpan-testers/cpantesters-api/blob/master/CONTRIBUTING.md)
for how to add new features, and if you have questions [here's how to
get in
contact](https://github.com/cpan-testers/cpantesters-api/blob/master/CONTRIBUTING.md#communication).

If you'd like to help, but don't know how, here's some possible features
that could be implemented to make the API easier to use:

* You can make the post-filters I use `jq` and ETL::Yertl for into API
  query parameters so that I can directly request only the releases with
  more than 10 failure reports
* You could make a special filter to only include the latest version of
  the dist
* You could add more endpoints to filter the data:
    * `/release/dist/{dist}/{version}` and
      `/upload/dist/{dist}/{version}` to only get a single version
    * `/release/dist/{dist}/latest` and `/upload/dist/{dist}/latest` to
      get the latest version

As always [thanks to all the sponsors of CPAN
Testers](http://iheart.cpantesters.org), and specifically to the
[sponsors of meta::hack for providing the means to get this API
started](https://metacpan.org/about/meta_hack).

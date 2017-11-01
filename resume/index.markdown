---
title: Resume
links:
    stylesheet:
        - href: /theme/css/resume.css
---

<div markdown="1" class="pull-right">
Chicago, IL  
(312) 241-8518  
<madcityzen@gmail.com>  
</div>

# Doug Bell

## Summary

* Software developer. Expert in Perl and JavaScript
* Mentor, team leader, and project manager
* System administrator and operations in Unix and Linux

## Work History

### ServerCentral, Ltd.

Senior Developer  
May 2016 - November 2017

#### Responsibilities and accomplishments

* Built automated platform for identifying, querying, and provisioning
  newly-racked servers
* Wrote library for wrapping IPMI utilities to expose IPMI data and BMC
  commands as a REST API
* Wrote [OpenAPI](https://www.openapis.org) specs and documentation to
  help downstream clients consume REST APIs
* Built web UI using [Vue.js](http://vuejs.org) for viewing server
  inventory, provisioning, installing operating systems (via
  [Cobbler](http://cobbler.github.io)), restarting servers, and
  configuring hardware RAID
* Built [Grafana](https://grafana.com) dashboards for viewing network
  traffic by point-of-presense and backbone provider using
  [carbonsearch](https://github.com/kanatohodets/carbonsearch)

### Independent Contractor

December 2015 - May 2016

#### Responsibilities and accomplishments

* Built web application to manage DHCP server configuration for a large
  consumer ISP
* Built custom SQL reports for finding misconfigured modems and other
  devices

### Bank of America

Senior Developer / Architect  
Quantitative Analysis and Research (QAR) group, Core Data team  
October 2011 - November 2015  

#### Responsibilities and accomplishments

* Collect and store market data for historical time series analysis
* Collect market data using Perl, C++ (via Perl XS), Java (via Perl
  Inline::Java), SQL, SOAP, HTTP, FTP, and e-mail
* Modernized and simplified legacy Perl platform and improved testing
  and documentation
* Worked with other QAR teams to build common solutions to data loading
  and storage problems
* Worked to ensure complete monitoring and documentation for L1 and L2
  support teams
* Developed extensive logging and reporting platform using ELK
  ([ElasticSearch](http://elastic.co),
  [Logstash](https://www.elastic.co/products/logstash),
  [Kibana](https://www.elastic.co/products/kibana))
* Developed custom job metadata reporting using
  [Postgres](http://postgresql.org), [Mojolicious](http://mojolicio.us),
  and custom messaging via [ZeroMQ](http://zeromq.org)
* Built robust and scalable ETL system using Perl and
  [ActiveMQ](http://activemq.apache.org)
* Built simple web applications for viewing and exploring data using
  Mojolicious, [AngularJS](https://angularjs.org), and
  [Bootstrap](http://getbootstrap.com)
* Developed drivers for internal General Universal Time Series (GUTS)
  API using ZeroMQ and
  [Protobuf](https://developers.google.com/protocol-buffers/)
* Automated releases, deployment and environment setup using Git and
  [Rex](http://rexify.org)
* Built fully-automated dev deployment using Perl and Jenkins

### Double Cluepon Software Corp.

CTO / Technical Director / Senior Developer  
October 2009 - June 2014  

#### Responsibilities and accomplishments

* Built a Pipe Dreams workalike, WireWorks, using AS3 and Flash IDE.
* Built SwfConduit, an AS3 socket server using Python,
  [Twisted](http://twistedmatrix.com), and
  [PyAMF](https://github.com/hydralabs/pyamf)
* Designed and built game object database using MongoDB (replacing MySQL after
  complications with [SQLAlchemy](http://www.sqlalchemy.org))
* Developed StoryTeller, an isometric, sprite-based game framework built
  on [Flex](http://flex.apache.org) running under AIR using SwfConduit as a backend
* Began work on Emerald Kingdom, an MMO RPG with a focus on episodic, rotating
  content with a linear storyline
* Designed an object-oriented, modular system to allow for multiple
  kinds of world-building: 2d platformer, 2d top-down, isometric,
  diametric, or 3d rendered
* Built a fully-automated release process with a self-updating client
  using Perl, Jenkins, and Make
* Built a community website based on Python, Twisted,
  [Jinja](http://jinja.pocoo.org), Angular, and Bootstrap
* Wrote enough Python to make almost every wrong Python library decision
  possible
* Administered MySQL, MongoDB, and 5 FreeBSD servers for all
  small-business needs including e-mail, DNS, and security

### Plain Black Corp.

Senior Developer / Project Manager / Systems Administrator  
November 2005 - August 2011  

#### Responsibilities and accomplishments

* Developed client website solutions with [WebGUI](http://webgui.org)
* Designed and built new Calendar app, new Photo Gallery app, Google Map
  app, and online chat app for WebGUI
* Manager (for 2 years) of major client project worth more than 50% of
  company revenue
* Developed [TheGameCrafter](http://thegamecrafter.com) Game Management
  interface using [YUI 2](http://yui.github.io/yui2)
* Lead developer of the next major version of WebGUI (8.0)
* Updated WebGUI 8 with modern Perl practices, Moose (modern
  object-oriented system), and Plack (web service abstraction layer)
* Built a JavaScript service-based Admin interface to WebGUI 8, allowing
  for custom scripting for WebGUI sites
* Performed performance profiling, replication, and administration of
  MySQL databases
* Performed manual database merges when replication failed
* Primary sysadmin for 30 Linux (CentOS) WebGUI hosting servers,
  including a load-balanced cluster for a client with 1.5m hits per
  month

## Other Accomplishments

* Community leader/organizer
    * Leader of Chicago Perl Mongers since May 2013
    * Founder of #css on Freenode since Mar 2003 (IRC nick: preaction)
* Presentations at [http://preaction.me/talks](/talks)
* Contributor to
    * Perl 5
    * Git
* Primary Maintainer of [CPAN Testers](http://github.com/cpan-testers)
    * Wrote new API (<http://api.cpantesters.org>)
    * Started metrics and monitoring using
      [Grafana](http://grafana.org) and [InfluxDB](http://influxdata.com)
    * Built distributed job runner to improve data processing time from
      hours to seconds
    * Reduced costs by moving from Amazon SimpleDB to existing MySQL
      database (with JSON column support)
    * Reduced complexity by removing extraneous database abstractions
    * Built new graphical dashboard to visualize test reports using
      Vue.js and HighCharts
        * Example: <http://beta.cpantesters.org/chart.html?dist=Statocles&version=0.083>
* Personal projects
    * [Github profile: preaction](http://github.com/preaction)
    * [Statocles - A static site CMS](http://preaction.github.io/Statocles)
    * [Yertl - ETL With a Shell](http://preaction.github.io/ETL-Yertl)
    * [Import::Base - Remove boilerplate from your code](http://metacpan.org/pod/Import::Base)
    * [GameDay - Desktop app to manage D&D game reporting](https://github.com/preaction/GameDay)
    * [Mercury - A web socket message broker](http://preaction.me/mercury)
    * [MetaCPAN author page](https://metacpan.org/author/PREACTION)
* Blogs
    * Perl blogging at <http://blogs.perl.org/users/preaction>
    * Cooking blog at <http://indiepalate.com>
    * Other blogging at <http://preaction.me>
* Other Websites
    * [chicago.pm.org](http://chicago.pm.org)
    * [Millennial title generator](http://preaction.me/title) - [Code on Github](https://github.com/preaction/MillennialTitle)

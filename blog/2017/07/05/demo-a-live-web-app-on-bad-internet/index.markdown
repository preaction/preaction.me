---
tags: ~
title: Demo a Live Web App on Bad Internet
links:
    canonical: https://opensource.com/article/17/7/squid-proxy
---

[Originally posted on Opensource.com](https://opensource.com/article/17/7/squid-proxy)

Live demos are the bane of professional speakers everywhere. Even the
most well-prepared live demo can go wrong for unforeseeable reasons.
This is a bad thing to happen while you're up on-stage in front of 300
people. Live demos of remote web apps are so fraught with peril that
most people find other ways of presenting them. Screenshots can never
fail, and local sandboxes won't fail on overloaded conference Internet
connections. But what if we can't set up a local sandbox in time for our
talk? What if our database is huge and complex? What if our app has
animation and interactions that we can't show with screenshots?

What if we could record our use of a web application and then replay the
stored responses at the right time? Lucky for us, it's easy to proxy
HTTP, the protocol that web browsers and web servers use to communicate
with each other. This means we can put an intermediary between our
browser and the server to do whatever we want. Often caching does
content filtering (corporate filters, parental filters). But caching
data on a server closer to the user can speed up a website.

We're going to use a web proxy in a similar way: We'll cache our content
and serve that cached data to our web browser. However, we're going to
run our proxy on the same machine as our web browser. And, we're going
to set it up to cache only the things that we want. This way we can run
a live demo on an unstable connection.

## Install and Configure Squid HTTP Proxy

First, we need to install and configure our proxy. I'm on a Mac, so
I was able to install [the Squid HTTP Proxy](http://www.squid-cache.org)
via [Homebrew, a free package manager for MacOS](https://brew.sh).

For our live demo, we want to cache the application we are trying to
demo and any other content the application needs. Anything else is
unnecessary. To do this, Squid has [Access Control Lists
(ACLs)](http://www.squid-cache.org/Doc/config/acl/). We
configure an ACL with a list of domains that we should cache, and deny
everything else. For maximum coverage, we should add both the host name
and the IP addresses to the ACL.  Since HTTP proxies are also used for
DNS, most of the time the proxy is looking up the DNS records.  But
sometimes a browser already knows the IP and will just tell the proxy to
get on with it.

So, here's our list of domains and IPs:

    acl cacheDomain dstdomain beta.cpantesters.org
    acl cacheDomain dstdomain api.cpantesters.org
    acl cacheDomain dstdomain www.cpantesters.org
    acl cacheDomain dstdomain 212.110.173.51
    acl cacheDomain dstdomain cdnjs.cloudflare.com

The first three domains are the applications that I'm running. The
fourth is the IP address for that application server: All the domains
are on the same machine. The last is [CDNJS, the JavaScript
CDN](http://cdnjs.com) that I get my JavaScript from. In order for my
application to work, I will need to cache all the JavaScript and CSS
that I depend on from CDNJS.

Once we've listed what we want to cache, we can forbid any other domains
from being cached:

    cache deny !cacheDomain

Next, we should tell Squid where to put our cache and how much disk
space to use. Homebrew's Squid configuration has a `cache_dir` line, commented
out. We need to enable it and increase the disk space available to
ensure that our data stays cached. When the disk space is used up, Squid
starts deleting old cached data, which we can't have during our demo.

    # Uncomment and adjust the following to add a disk cache directory.
    cache_dir ufs /usr/local/var/cache/squid 1024 16 256

The first number at the end of the line is the cache size in MB, which
I adjusted to 1024 (1 GB).

Finally, we should make sure that we can use Squid's management API, and
that it's only open to the local machine. This should be the default, so
look for these `http_access` lines, and add them if they don't exist.

    # Only allow cachemgr access from localhost
    http_access allow localhost manager
    http_access deny manager

After allowing cache manager access from `localhost`, we should disable
the cache manager password:

    cachemgr_passwd none all

Now we're done with the configuration file. Our [full configuration file is located
here](https://gist.github.com/preaction/d90ad4b9ddbe1f390252319cbec980f9).

Now that we've configured our proxy, we can start it up. Homebrew says
to do `brew services start squid`, but your platform may need something
different. This gets the proxy started and waiting for requests. Next
we need to configure our browser to use the proxy.

## Configure your web browser

Configuring your web browser for an HTTP proxy depends on what browser
you use and what OS you use. If you're using Chrome or Safari on MacOS,
you can go to System Preferences to configure a proxy. However, if
you're using Firefox, you can configure the browser to use a proxy, and
leave the rest of the system alone. Other operating systems have other
ways to configure proxies, and you should check your OS's documentation.

There are some good browser plugins for managing HTTP proxies, but
unfortunately not for Safari or IE. If you're using Chrome, try [Proxy
SwitchyOmega](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif).
If you're using Firefox, use [FoxyProxy
Standard](https://addons.mozilla.org/en-US/firefox/addon/foxyproxy-standard/).
These plugins make it easier to manage HTTP proxies.

## Run through the demo to cache your content

Once you configure your proxy, you can run through your demo to test it.
Do this on a good Internet connection. As you run through your demo,
your browser asks its proxy to fetch all the demo's data. As your proxy
does this, it caches it on disk. Since your computer is online, Squid
will follow the caching rules that the web server asks it to. This means
caching for a specific length of time, and possibly revalidating the
data to see if it changed.

As we run through our demo, we should make sure that our cache is being
used. The easiest way to do that is to read Squid's log. For my
configuration, it was located at `/usr/local/var/logs/access.log`.
Inside are lines that look like this:

    1498020228.970    203 ::1 TCP_MISS/200 3653 GET http://beta.cpantesters.org/chart.html? - HIER_DIRECT/212.110.173.51 text/html
    1498020229.523    314 ::1 TCP_REFRESH_MODIFIED/200 8130 GET http://api.cpantesters.org/v3/release/dist/Statocles - HIER_DIRECT/212.110.173.51 application/json
    1498020236.187   6945 ::1 TCP_MISS/200 148284 GET http://api.cpantesters.org/v3/summary/Statocles/0.077 - HIER_DIRECT/212.110.173.51 application/json
    1498020240.783    186 ::1 TCP_MISS/200 6597 GET http://people.w3.org/~dom/archives/2006/09/offline-web-cache-with-squid/ - HIER_DIRECT/128.30.54.11 text/html

The important parts of this line are the URL and the status.
`TCP_MISS/200` means "this request was not in our cache, and the remote
server returned a `200 OK` HTTP response". `TCP_REFRESH_MODIFIED/200`
means "this request was in our cache, but we refreshed it from the
remote server which returned a `200 OK` HTTP response". This is our
cache building and refreshing itself because we're on a stable
connection. Once we have some data in our cache, we'll start seeing
things like this:

    1498063273.261      0 ::1 TCP_INM_HIT/304 299 GET http://beta.cpantesters.org/chart.html - HIER_NONE/- text/html
    1498063281.831      0 ::1 TCP_MEM_HIT/200 8187 GET http://api.cpantesters.org/v3/release/dist/Statocles - HIER_NONE/- application/json
    1498063298.103      0 ::1 TCP_MEM_HIT/200 8187 GET http://api.cpantesters.org/v3/release/dist/Statocles - HIER_NONE/- application/json
    1498063300.473      8 ::1 TCP_MEM_HIT/200 154917 GET http://api.cpantesters.org/v3/summary/Statocles/0.083 - HIER_NONE/- application/json

`TCP_INM_HIT/304` means "The cache responded to this request with a `304
Not Modified` response". The `TCP_MEM_HIT/200` means "The cache
responded to this request with a `200 OK` HTTP response". These are what
we want: The cache is serving responses, not the remote server.

## Run Your Demo

Now that our cache is operating well on a stable connection, we can give
our demo on an unstable one. First, we want to make sure that our cache
does not try to access the remote server (Squid's "offline" mode). To do
this, Squid has a management client called `squidclient` which we can use
to toggle offline mode.

    $ squidclient mgr:offline_toggle
    HTTP/1.1 200 OK
    Server: squid/3.5.26
    Mime-Version: 1.0
    Date: Tue, 04 Jul 2017 21:16:36 GMT
    Content-Type: text/plain;charset=utf-8
    Expires: Tue, 04 Jul 2017 21:16:36 GMT
    Last-Modified: Tue, 04 Jul 2017 21:16:36 GMT
    X-Cache: MISS from gwen.local
    Via: 1.1 gwen.local (squid/3.5.26)
    Connection: close

    offline_mode is now ON

Squid's offline mode minimizes attempts to get remote content. Since we
cached all our content running through our demo, this means Squid will
be serving our demo!

So now we can run our demo worry-free! All the remote content is served
by the local machine, so it doesn't matter how good the conference wi-fi
is. As long as stick to things we've already cached, our web application
runs perfectly.


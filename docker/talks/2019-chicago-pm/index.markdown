---
title: Development and Deployment with Docker
layout: reveal.html
data:
    topic_url: preaction.me/docker
---

<div class="slides">
%= include 'deck/title.html.ep', title => $self->title

<section>

<section><h1>What Is Docker?</h1></section>
<section>
<h1>Not A VM</h1>
</section>
<section>
<h1>Container</h1>
<p class="fragment">Isolate a single process</p>
</section>
<section>
<h1>Not Hardware Simulation</h1>
</section>
<section>
<h1>Not Running an OS</h1>
</section>

<section>
<h1>Load a Linux Distribution</h1>
<p class="fragment">But not a new kernel</p>
</section>

<section>
<h1>Copy Everything</h1>
<ul>
    <li class="fragment">Executables</li>
    <li class="fragment">Libraries</li>
    <li class="fragment">Files</li>
</ul>
</section>

<section>
<h1>Setup is Hard</h1>
</section>

<section>
<h1>Container:</h1>
<h2>A complete environment to run a program</h2>
</section>

<section>
<h1>What is Docker?</h1>
</section>

<section>
<h1>Container Management</h1>
</section>
<section>
<h1>Container Configuration</h1>
</section>
<section>
<h1>Layered File Systems</h1>
</section>
<section>
<h1>Multi-Container Applications</h1>
</section>

<section>
<h1>Dev Envs</h1>
<h1 class="fragment">Prod Envs</h1>
<h1 class="fragment">Scaling</h1>
</section>

</section><section>

<section><h1>Our First Container</h1></section>

<section>
<img src="docker-pull-perl.png">
</section>

<section>
<img src="docker-pull-perl-download.png">
</section>

<section>
<h1>Layered Filesystem</h1>
<pre class="fragment">/</pre>
<pre class="fragment">/usr/local/bin/perl
/usr/local/lib/site_perl</pre>
<pre class="fragment">/usr/local/bin/mojo
/usr/local/lib/site_perl/Mojolicious</pre>
</section>

<section>
<img src="docker-pull-perl-extract-01.png">
</section>

<section>
<img src="docker-pull-perl-extract-02.png">
</section>

<section>
<img src="docker-pull-perl-complete.png">
</section>

<section>
<img src="docker-images.png">
</section>

<section>
<img src="docker-images-output.png">
</section>

<section>
<img src="docker-pull-python.png">
</section>

<section>
<img src="docker-pull-python-output.png">
</section>

</section><section>

<section>
<h1>Run a Command</h1>
</section>

<section>
<img src="docker-run-perl.png">
</section>

<section>
<img src="docker-run-perl-perl.png">
</section>

<section>
<img src="docker-run-perl-output.png">
</section>

<section>
<img src="docker-run-perl-repl.png">
</section>

<section>
<img src="docker-run-perl-repl-hello.png">
</section>

<section>
<img src="docker-run-perl-osname.png">
</section>

<section>
<img src="docker-run-perl-osname-output.png">
</section>

<section>
<img src="docker-run-perl-local.png">
</section>

<section>
<img src="docker-run-perl-local-output.png">
</section>

<section>
<img src="docker-run-debian.png">
</section>

<section>
<img src="docker-run-debian-shell.png">
</section>

<section>
<img src="docker-run-debian-grep.png">
</section>

<section>
<img src="docker-run-debian-release.png">
</section>

</section><section>

<section><h1>Build A Container</h1></section>

<section>
<img src="docker-build-create-script.png">
</section>

<section>
<img src="docker-build-write-script.png">
</section>

<section>
<img src="docker-build-create-dockerfile.png">
</section>

<section>
<img src="docker-build-from.png">
</section>

<section>
<img src="docker-build-copy.png">
</section>

<section>
<img src="docker-build-cmd.png">
</section>

<section>
<img src="docker-build-run.png">
</section>

<section>
<img src="docker-build-run-output.png">
</section>

<section>
<img src="docker-build-run-container.png">
</section>

<section>
<img src="docker-build-run-container-output.png">
</section>

<section>
<img src="docker-build-run.png">
</section>

<section>
<img src="docker-build-run-tag.png">
</section>

<section>
<img src="docker-build-run-tag-output.png">
</section>

<section>
<img src="docker-build-run-container-tag.png">
</section>

<section>
<img src="docker-build-run-container-tag-output.png">
</section>

</section><section>

<section><h1>Add Prereqs</h1></section>

<section>
<img src="docker-mojo.png">
</section>

<section>
<img src="docker-mojo-create-dockerfile.png">
</section>

<section>
<img src="docker-mojo-build-from.png">
</section>

<section>
<img src="docker-mojo-build-run.png">
</section>

<section>
<img src="docker-mojo-build-image.png">
</section>

<section>
<img src="docker-mojo-build-image-tag.png">
</section>

<section>
<img src="docker-mojo-build-image-cpanm.png">
</section>

<section>
<img src="docker-mojo-build-image-done.png">
</section>

<section>
<img src="docker-mojo-run.png">
</section>

<section>
<img src="docker-mojo-run-get.png">
</section>

<section>
<img src="docker-mojo-run-get-output.png">
</section>

</section><section>

<section><h1>Expose Ports</h1></section>

<section>
<img src="docker-expose-fail-run.png">
</section>

<section>
<img src="docker-expose-fail-error.png">
</section>

<section>
<img src="docker-expose-dockerfile.png">
</section>

<section>
<img src="docker-expose-dockerfile-port.png">
</section>

<section>
<img src="docker-expose-run.png">
</section>

<section>
<img src="docker-expose-run-local.png">
</section>

<section>
<img src="docker-expose-run-remote.png">
</section>

<section>
<img src="docker-expose-run-image.png">
</section>

<section>
<img src="docker-expose-run-command.png">
</section>

<section>
<img src="docker-expose-run-output.png">
</section>

<section>
<img src="docker-expose-run-success.png">
</section>

<section><h1>Docker Handles Networking</h1></section>

<section>
<img src="docker-ps.png">
</section>

<section>
<img src="docker-ps-running.png">
</section>

<section>
<img src="docker-ps-stop.png">
</section>

<section>
<img src="docker-ps-stop-output.png">
</section>

<section>
<img src="docker-ps.png">
</section>

<section>
<img src="docker-ps-empty.png">
</section>

</section><section>

<section><h1>Mount a Volume</h1></section>

<section>
<img src="docker-volume-myapp.png">
</section>

<section>
<img src="docker-expose-dockerfile-port.png">
</section>

<section>
<img src="docker-volume-dockerfile.png">
</section>

<section>
<img src="docker-volume-build.png">
</section>

<section>
<img src="docker-volume-build-output.png">
</section>

<section>
<img src="docker-volume-run-port.png">
</section>

<section>
<img src="docker-volume-run-volume.png">
</section>

<section>
<img src="docker-volume-run-image.png">
</section>

<section>
<img src="docker-volume-run-cmd.png">
</section>

<section>
<img src="docker-volume-run-output.png">
</section>

<section>
<img src="docker-volume-run-log.png">
</section>

<section>
<img src="docker-volume-run-success.png">
</section>

<section>
<img src="docker-volume-myapp.png">
</section>

<section>
<img src="docker-volume-run-edit.png">
</section>

<section>
<img src="docker-volume-run-edit-success.png">
</section>

<section><h1>Volumes Share</h1></section>
<section><h1>Volumes Persist</h1></section>

</section><section>

<section><h1>Compose an App</h1></section>

<section>
<img src="docker-pg-pull.png">
</section>

<section>
<img src="docker-pg-mojo.png">
</section>

<section>
<img src="docker-pg-sql.png">
</section>

<section>
<img src="docker-pg-index.png">
</section>

<section>
<img src="docker-pg-dockerfile.png">
</section>

<section>
<img src="docker-pg-dockerfile-apt.png">
</section>

<section>
<img src="docker-pg-dockerfile-cpanm.png">
</section>

<section>
<img src="docker-pg-compose.png">
</section>

<section>
<img src="docker-pg-compose-start.png">
</section>

<section>
<img src="docker-pg-compose-postgres.png">
</section>

<section>
<img src="docker-pg-compose-image.png">
</section>

<section>
<img src="docker-pg-compose-password.png">
</section>

<section>
<img src="docker-pg-compose-web.png">
</section>

<section>
<img src="docker-pg-compose-build.png">
</section>

<section>
<img src="docker-pg-compose-ports.png">
</section>

<section>
<img src="docker-pg-up.png">
</section>

<section>
<img src="docker-pg-up-starting.png">
</section>

<section>
<img src="docker-pg-up-output.png">
</section>

<section>
<img src="docker-pg-success.png">
</section>

<section>
<img src="docker-pg-build.png">
</section>

<section>
<img src="docker-pg-build-output.png">
</section>

</section><section>

<section>
<h1>Why Docker?</h1>
</section>
<section>
<h1>Software Demos</h1>
</section>
<section>
<h1>Automated Testing</h1>
</section>
<section>
<h1>Horizontal Scaling</h1>
</section>
<section>
<h1>Things VMs Do</h1>
<p>But faster!</p>
</section>

</section>

<!-- Wrap-up -->
<section><h1>Sources:</h1>
<ul>
<li>https://docs.docker.com</li>
<li>https://en.wikipedia.org/wiki/Linux_namespaces</li>
<li>https://en.wikipedia.org/wiki/UnionFS</li>
</ul>
</section>

<section><h1>Questions?</h1></section>
</div>


---
title: Working Remotely With SSH
layout: reveal.html
data:
    topic_url: preaction.me/ssh
---

<div class="slides">
%= include 'deck/title.html.ep', title => $self->title

<section>

<section>
<h1>What is SSH?</h1>
<aside class="notes">This talk is about SSH.</aside>
</section>

<section>
<h1>Secure Shell</h1>
<aside class="notes">SSH stands for "Secure Shell".</aside>
</section>

<section>
<h1>Remote Server</h1>
<aside class="notes">It's a way of connecting to a remote server through
a terminal (think command-line).</aside>
</section>

<section>
<h1>More Secure than <code>rsh</code></h1>
<aside class="notes">SSH is used over RSH ("Remote Shell") because of
its security. SSH encrypts all of its traffic, RSH does not (RSH being
from an earlier time before the commercial Internet and its inherent
dangers). SSH was built directly as an RSH replacement, so there are
some similarities (though most likely nobody here has used RSH).</aside>
</section>

<section>
<h1>More Secure than <code>telnet</code></h1>
<aside class="notes">Telnet is another thing you may have heard of to
connect to servers and run commands. Telnet is more general-purpose,
though: It can connect to anything and send any data. SSH, because of
its security negotiation, connects only to SSH servers. So, SSH has
replaced Telnet for remote shells, but Telnet is still a useful command
for other things.</aside>
</section>

<section>
<h1>More Than a Shell</h1>
<aside class="notes">In addition to a shell, an SSH server also provides
file transfer (like FTP, but secure and built for a modern Internet),
and network proxies (connect to other machines through your SSH server,
like a VPN)</aside>
</section>


</section>

<!-- Basic SSH command -->
<section>
<section>
<h1>Run <code>ssh</code></h1>
<aside class="notes">First, we want to connect to the server
using the SSH client.</aside>
</section>
<section>
<h1>Install OpenSSH</h1>
<aside class="notes">
If we don't have the <code>ssh</code> command, we need to
install OpenSSH, or on some systems, "OpenSSH client". Windows
users can either get OpenSSH for PowerShell, or the Windows
Subsystem for Linux.  Windows users might be familiar with
PuTTY, but it's different enough that we won't be covering it.
</aside>
</section>
<section>
<h3><kbd>ssh stage.cpantesters.org</kbd></h3>
<aside class="notes">
Once we've installed OpenSSH, we can run <code>ssh
stage.cpantesters.org</code>
</aside>
</section>
<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh stage.cpantesters.org</kbd>








</pre>
</section>
<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh stage.cpantesters.org</kbd>
The authenticity of host 'stage.cpantesters.org (2607:f740:f::914)' can't
be established.
ECDSA key fingerprint is SHA256:AcGEg+DDHplQT8Cc02CYy8Y4p/C4I5ARoEhrA5ZvrOQ.
Are you sure you want to continue connecting (yes/no)? <kbd class="fragment">yes</kbd>




</pre>
<aside class="notes">
Uhoh. What's this? "The authenticity of host
'stage.cpantesters.org (some IPv6 address)' can't be
established." Okay, so SSH is saying it doesn't know if
stage.cpantesters.org is who it says it is.
"ECDSA key fingerprint is (gobbledegook)". SSH is saying this is
the fingerprint of the server's public key. We'll get into keys
later, but this is a way to validate that the server is who we
expect it to be (and someone isn't hijacking our DNS lookup or
our connection).
"Are you sure you want to continue connecting?" y-e-s spells
yes.
</aside>
</section>
<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh stage.cpantesters.org</kbd>
The authenticity of host 'stage.cpantesters.org (2607:f740:f::914)' can't
be established.
ECDSA key fingerprint is SHA256:AcGEg+DDHplQT8Cc02CYy8Y4p/C4I5ARoEhrA5ZvrOQ.
Are you sure you want to continue connecting (yes/no)? <kbd>yes</kbd>
Warning: Permanently added 'stage.cpantesters.org,2607:f740:f::914' (ECDSA)
to the list of known hosts.


</pre>
<aside class="notes">"Warning: Permanently added
'stage.cpantesters.org' (ECDSA) to the list of known hosts".
Okay, so SSH is telling us that it's not going to ask us again,
but SSH will also refuse to let us connect to any other machine.
If we try to connect to <code>stage.cpantesters.org</code> and
it doesn't have the right identity key, we'll get this message
instead:
</aside>
</section>
<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh stage.cpantesters.org</kbd>
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:AcGEg+DDHplQT8Cc02CYy8Y4p/C4I5ARoEhrA5ZvrOQ.
Please contact your system administrator.
Add correct host key in /Users/doug/.ssh/known_hosts to get rid of this
message.
Offending ECDSA key in /Users/doug/.ssh/known_hosts:40
ECDSA host key for stage.cpantesters.org has changed and you have requested
strict checking.
Host key verification failed.</pre>
<aside class="notes">
This doesn't look happy, but it shows what happens if perhaps
stage.cpantesters.org moves to a new server with a new identity
(which is the most likely scenario), or if someone is trying to
hijack your connection (not likely, but not impossible).
This is part of the "Secure" in Secure Shell.
To get rid of this message, once we've verified that nobody is
trying to mislead us, we need to edit our "known hosts" file,
which for me is "/Users/doug/.ssh/known_hosts", and remove the
old entry for "stage.cpantesters.org". Then we'll be asked again
if we want to connect, and we can say "yes" again.
</aside>
</section>
<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh stage.cpantesters.org</kbd>
The authenticity of host 'stage.cpantesters.org (2607:f740:f::914)' can't
be established.
ECDSA key fingerprint is SHA256:AcGEg+DDHplQT8Cc02CYy8Y4p/C4I5ARoEhrA5ZvrOQ.
Are you sure you want to continue connecting (yes/no)? <kbd>yes</kbd>
Warning: Permanently added 'stage.cpantesters.org,2607:f740:f::914' (ECDSA)
to the list of known hosts.
doug@stage.cpantesters.org's password:

</pre>
<aside class="notes">Now it's asking for the password of the user 'doug'
on the server 'stage.cpantesters.org'. If we type in our password...</aside>
</section>
<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh stage.cpantesters.org</kbd>
The authenticity of host 'stage.cpantesters.org (2607:f740:f::914)' can't
be established.
ECDSA key fingerprint is SHA256:AcGEg+DDHplQT8Cc02CYy8Y4p/C4I5ARoEhrA5ZvrOQ.
Are you sure you want to continue connecting (yes/no)? <kbd>yes</kbd>
Warning: Permanently added 'stage.cpantesters.org,2607:f740:f::914' (ECDSA)
to the list of known hosts.
doug@stage.cpantesters.org's password:
Permission denied, please try again.
doug@stage.cpantesters.org's password:</pre>
<aside class="notes">I get permission denied? Oh! Right! My user
account isn't called "doug", it's called "dbell".</aside>
</section>
<section>
<h3><code>ssh stage.cpantesters.org</code></h3>
<h3><code>-l dbell</code></h3>
<aside class="notes">We can specify the login account to use on the
remote host with the <code>-l</code> flag
</aside>
</section>
<section>
<h3><code>ssh dbell@stage.cpantesters.org</code></h3>
<aside class="notes">Or by using account "at"
stage.cpantesters.org</aside>
</section>
<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh dbell@stage.cpantesters.org</kbd>
<span class="fragment">dbell@stage.cpantesters.org's password: </span>
<span class="fragment">Linux stage.cpantesters.org 4.9.0-3-amd64 #1 SMP
Debian 4.9.30-2+deb9u2 (2017-06-26) x86_64

The programs included with the Debian GNU/Linux system are free
software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/\*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.</span>
<span class="fragment">dbell@stage:~$ </span></pre>
<aside class="notes">Now if we use the right account, we're prompted for
the right password, and we're shown the login message (also known as the
"Message of the Day" or "MOTD"), and then our shell prompt so we can
start running commands.</aside>
</section>
</section>

<!-- SSH Config -->
<section>
<section>
<h3><code>ssh dbell@stage.cpantesters.org</code></h3>
<aside class="notes">
So, let's look back at the command that we used. This is a lot to type,
and when we've got hundreds of servers and dozens of logins, remembering
which login goes to which server can be hard.
</aside>
</section>

<section>
<h1>SSH Config</h1>
<h2 class="fragment"><code>~/.ssh/config</code></h2>
<h2 class="fragment"><code>~/ssh_config</code></h2>
<aside class="notes">
To remember these things, we can write an SSH config file. On Linux and
MacOS, this will be a file called "config" in the ".ssh" directory in
our user directory (you may have to create this directory). For Windows,
this will be a file called "ssh_config" in our user directory.
</aside>
</section>

<section>
<pre class="terminal"><span class="fragment">Host stage.cpantesters.org</span>
    <span class="fragment">User dbell</span>
</pre>
<aside class="notes">
In this file, the most common kind of configuration will be "Host"
configuration. We're configuring the host "stage.cpantesters.org", and
when connecting to "stage.cpantesters.org", we want the user "dbell".
</aside>
</section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh stage.cpantesters.org</kbd>
<span class="fragment">dbell@stage.cpantesters.org's password: </span>
</pre>
<aside class="notes">Now if we save this and try connecting, we can see
that we're asked for a password for the user "dbell".</aside>
</section>

<section>
<pre class="terminal">Host stage.cpantesters.org
    User dbell
<span class="fragment">Host ct-stage</span>
    <span class="fragment">Hostname stage.cpantesters.org</span>
</pre>
<aside class="notes">That's certainly the most common thing I do in the
SSH config file, but we can also set up aliases for our hosts. Normally,
I just let tab-completion in my shell finish my typing for me, but if
that's not good enough, I can add another Host section to my config to
define a host that doesn't really exist. Like, "Host ct-stage". Then, we
configure the host's "Hostname" as "stage.cpantesters.org".</aside>
</section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh ct-stage</kbd>
<span class="fragment">dbell@stage.cpantesters.org's password: </span>
</pre>
<aside class="notes">Now if we save this and try connecting to
"ct-stage", we can see that we're connecting as "dbell" to
"stage.cpantesters.org".</aside>
</section>

<section>
<pre class="terminal">Host stage.cpantesters.org
    User dbell
Host ct-stage
    Hostname stage.cpantesters.org
</pre>
<aside class="notes">There is a lot more that can go in here, and we'll
go into some of it as we go along...</aside>
</section>

</section>

<!-- Keys and SSH agent -->
<section>

<section>
<h1>Passwords</h1>
<aside class="notes">... but now let's talk about not
typing in our password over and over again.</aside>
</section>

<section>
<h1>Identification</h1>
<aside class="notes">
Passwords identify us. They "authenticate" us. By knowing the password,
I prove I am who I claim to be: "dbell". If someone learned my password,
they could claim to be me. That's not ideal, which is why much
discussion and research goes in to what makes a good password. We're not
going to talk about that, because most popular knowledge is outdated and
I could spend hours discussing why.
</aside>
</section>

<section>
<h1>Authentication</h1>
<h2 class="fragment">Password</h2>
<h2 class="fragment">USB Device</h2>
<h2 class="fragment">SSH Keys</h2>
<aside class="notes">
SSH has multiple ways of authentication. Passwords are one way. There
are devices you can buy that plug in to your computer to authenticate
you. But the most common recommended way is SSH keys.
</aside>
</section>

<section>
<h1>Asymmetric Cryptography</h1>
<aside class="notes">
So, I'm going to try to explain how SSH keys work, but don't worry if it
doesn't make sense: They still work even if I don't understand why.
</aside>
</section>

<section>
<h1>Key Pair</h1>
<h2>Public Key</h2>
<h2>Private Key</h2>
<aside class="notes">SSH keys come in pairs: One public, one private.
The public key is given out to other people. The private key is kept
private.</aside>
</section>

<section>
<h1>Encryption</h1>
<h2>Message for Alice</h2>
<h2>+ Public Key</h2>
<h2>= Encrypted message</h2>
<aside class="notes">The public key is used to encrypt a message that
can only be decrypted by someone with the private key.</aside>
</section>

<section>
<h1>Decryption</h1>
<h2>Encrypted Message</h2>
<h2>+ Private Key</h2>
<h2>= Message</h2>
<aside class="notes">The private key decrypts messages encrypted with
the public key.</aside>
</section>

<section>
<h1>Trust</h1>
<aside class="notes">With this, we can create a trusted communication
channel: Only the person with the private key can decrypt the message we
sent.</aside>
</section>

<section>
<h1>Secure Communication</h1>
<aside class="notes">Now that we have trust, we can negotiate a secure
communication channel. The asymmetric encryption is expensive, so these
encrypted messages are used to share enough information to set up a less
expensive symmetric encryption channel.</aside>
</section>

<section>
<h1>Key Algorithms</h1>
<h2>RSA</h2>
<h2>DSA</h2>
<h2>ECDSA</h2>
<aside class="notes">Keys are just numbers, very special numbers, and these numbers are
generated by algorithms. For example, RSA uses products of primes,
relying on the fact that it's really hard to factor really large
numbers (but it's getting easier all the time, so we invent other
algorithms).
</aside>
</section>
</section>

<!-- Using keys -->
<section>

<section>
<h1>Generate a Key</h1>
<h2><code>ssh-keygen</code></h2>
<aside class="notes">
To generate a key, we can run the <code>ssh-keygen</code> command.</aside>
</section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh-keygen -t ed25519</kbd>
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/doug/.ssh/id_ed25519):


















</pre>
<aside class="notes">For security, we'll generate an EdDSA key using Ed25519.
When we run the comment, we're asked for a file to save the key. Unless
you're generating a new key for a special case, we can just accept the
default which stores our key in our .ssh directory (the same directory
as our config file).</aside>
</section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh-keygen -t ed25519</kbd>
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/doug/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):

















</pre>
<aside class="notes">
Here we type in a passphrase to protect our key. Passphrases can be
long, the longer the better. If you don't use a passphrase, the key will
still work, but then anyone who has the key can impersonate you without
having to know the passphrase.
</aside>
</section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh-keygen -t ed25519</kbd>
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/doug/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
















</pre>
<aside class="notes">
And then our typing skills are put to the test: We have to type our
passphrase again. This is important: If we forget our passphrase, we
will completely lose access to the key.
</aside></section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh-keygen -t ed25519</kbd>
Generating public/private ed25519 key pair.
Enter file in which to save the key (/Users/doug/.ssh/id_ed25519):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/doug/.ssh/id_ed25519.
Your public key has been saved in /Users/doug/.ssh/id_ed25519.pub.
The key fingerprint is:
SHA256:EfNX6BfSBrTgWdTzMC0BB7kLcgtjEGE0hcd0FVLOax0 doug@gwen.local
The key's randomart image is:
+--[ED25519 256]--+
|     .*B= +=@X+o |
|     .o.o* B++X .|
|       o. +.=+EB |
|        =.o.oo...|
|       .S= ooo.  |
|          ...    |
|                 |
|                 |
|                 |
+----[SHA256]-----+
</pre>
<aside class="notes">
Once we've input our passphrase, we're shown the result: The
identification (private key) is saved at .ssh/id_ed25519. The public
key, which we give to others who want to validate our identity, is saved
at .ssh/id_ed25519.pub. The key's fingerprint and randomart image are
also shown. These can be used by humans to validate a key. This is more
important when validating host keys, but to be quite honest I don't use
them.
</aside></section>

<section>
<h1>What do keys look like?</h1>
<aside class="notes">
Let's take a look at these files. First, the private key
</aside></section>

<section>
<pre>-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAACmFlczI1Ni1jdHIAAAAGYmNyeXB0AAAAGAAAABC4/uBUAp
In/ciLjy94niDEAAAAEAAAAAEAAAAzAAAAC7NzaC1lZDI1NTE5AAAAIJmSkjt+1JRMMFBh
OsF9o65xL0xbrrYZZbySe597QYYDAAAAoLuPMZOmS9ByUsbiQbGyGQWXOUydCyqKHfWdgt
Drhs56y+KRRCDhcc1vlUt9XAPWH98i4iq6+iy7XmnYPZa5j9ydsQ/3k0yrvi2tn+MUOqzP
6mIiM3ZKRAHV7045ePEJgszPAogWxlHPdXn3cDHW8dvb53pEjtm/7SjxbLcarMSBmQqY5c
AKTolqf9+ZnpNDpO78snhV8vJNR4HFae03eTc=
-----END OPENSSH PRIVATE KEY-----</pre>
<aside class="notes">
This is our private key. It's base-64 encoded binary. This is the most
imporant thing I will tell you in this presentation: The private key
must never ever leave your computer. For example, you must never post
your private key on a slide in a presentation to demonstrate what
a private key looks like. This private key was made for this
presentation, so if you try to use it, you will not end up as me.
</aside></section>

<section>
<pre>ssh-ed25519
AAAAC3NzaC1lZDI1NTE5AAAAIJmSkjt+1JRMMFBhOsF5o60xL0xbrrYZZbySe597QYYD
doug@gwen.local</pre>
<aside class="notes">
This is our public key. This is okay to post everywhere, as this is how
others will validate that you are who you say you are. It has three
parts: ssh-ed25519 is the key type, this base-64 encoded string is the
public key, and the last part is a comment identifying the key. Notice
that by default it has my username and my computer's host name. We can
use this to keep track of our keys on multiple computers, since each of
our computers should have a different key pair.
</aside></section>

<section>
<h1>Copy Public Key</h1>
<h2><code>ssh-copy-id</code></h2>
<aside class="notes">
Now we have our key pair. In order to use it to log in, we need to copy
the public key to the remote server. Nowadays, this is done with the
<code>ssh-copy-id</code> command.
</aside></section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh-copy-id stage.cpantesters.org</kbd>
<span class="fragment">/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/doug/.ssh/id_ed25519.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
dbell@stage.cpantesters.org's password:</span>






</pre>
<aside class="notes">
The <code>ssh-copy-id</code> command takes the name of the server we
want to copy our IDs to. So, for us, <code>stage.cpantesters.org</code>.
Then it asks for our password to the remote server.
</aside></section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh-copy-id stage.cpantesters.org</kbd>
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/Users/doug/.ssh/id_ed25519.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
dbell@stage.cpantesters.org's password:


Number of key(s) added:        1

Now try logging into the machine, with:   "ssh 'stage.cpantesters.org'"
and check to make sure that only the key(s) you wanted were added.
</pre>
<aside class="notes">
Once we enter our password, that's it! It added our key, and told us we
can try logging in, so let's do it!
</aside></section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh stage.cpantesters.org</kbd>
<span class="fragment">Enter passphrase for key '/Users/doug/.ssh/id_ed25519':</span>
<span class="fragment">Linux stage.cpantesters.org 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u2 (2017-06-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/\*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.</span>
</pre>
<aside class="notes">
Wait. I thought we were getting rid of passwords... Well, if we type the
passphrase for our key, we are now logged in. But that's just trading
one password on the server with a different password on the client.
Sure, it's more secure, but we're trying to not remember passwords these
days.
</aside></section>

</section>

<!-- SSH Agent -->
<section>

<section>
<h1>SSH Agent</h1>
<h2><code>ssh-agent</code></h2>
<aside class="notes">
OpenSSH comes with a program to safely hold on to our keys: ssh-agent.
The agent is a program that runs in the background. We then add our keys
to it, typing our key passphrases. Then, whenever a new ssh connection
needs a key, it asks the agent instead.
</aside></section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>eval $(ssh-agent)</kbd>
Agent pid 9653
</pre>
<aside class="notes">
We run the SSH agent using <code>eval $(ssh-agent)</code>. That's kind
of weird, so what's that doing?
</aside></section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh-agent</kbd>
<span class="fragment">SSH_AUTH_SOCK=/var/folders/m8/pzbmtwsn4qjg898w08gkxlcm0000gn/T//ssh-4B1BPw5Itnoy/agent.9652;
export SSH_AUTH_SOCK;
SSH_AGENT_PID=9653; export SSH_AGENT_PID;
echo Agent pid 9653;</span>
</pre>
<aside class="notes">
This is the shell code that is being run. The SSH agent creates two
environment variables, SSH_AUTH_SOCK and SSH_AGENT_PID. This is what SSH
will use to communicate with the agent when needed.
</aside></section>

<section>
<h1>Add Identities (Keys)</h1>
<h2><code>ssh-add</code></h2>
<aside class="notes">
With the agent running, we need to add our identities. We do that using
<code>ssh-add</code>.
</aside></section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh-add</kbd>
<span class="fragment">Enter passphrase for /Users/doug/.ssh/id_ed25519:</span>
<span class="fragment">Identity added: /Users/doug/.ssh/id_ed25519 (doug@gwen.local)</span>
</pre>
<aside class="notes">
We're prompted for our passphrase, and then it tells us that it's added
our identity. Now let's try logging in again:
</aside></section>

<section>
<pre class="terminal"><span class="prompt">doug@local:~$ </span><kbd>ssh stage.cpantesters.org</kbd>
<span class="fragment">Linux stage.cpantesters.org 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u2 (2017-06-26) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/\*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.</span>
</pre>
<aside class="notes">
Now we aren't prompted for our key's passphrase when we log in. We won't have
to type in our passphrase again until the SSH agent dies.
</aside></section>

<section>
<h1>Start SSH Agent at Boot</h1>
<aside class="notes">
To make sure that we only have to type our passphrase once when our
computer reboots, we can configure our system to start the SSH agent at
boot. This is dependent on your OS, but most Unix-like desktops have an
SSH agent already running.
</aside></section>

<section>
<h1>Automatically Add Keys</h1>
<h2><code>AddKeysToAgent yes</code></h2>
<aside class="notes">
If we don't want to explicitly call <code>ssh-add</code>, we can add
<code>AddKeysToAgent yes</code> in our ssh config file. Then, provided
there is a running agent, our keys will automatically be added as they
are used.  I prefer doing this, as it reduces the things I have to
remember to do.
</aside></section>

<section>
<h1>Use MacOS Keychain</h1>
<h2><code>UseKeychain yes</code></h2>
<h2><code>ssh-add -K</code></h2>
<aside class="notes">
Finally, if you're on Mac OS X, you can add <code>UseKeychain yes</code>
to your SSH config to look up your passphrase securely from your OS
keychain.  If you do this, you just need to add your passphrase to your
OS keychain (<code>ssh-add -K</code>) and you'll never have to type it
again!
</aside></section>

</section>

<!-- SSH Agent forwarding -->
<section>

<section>
<h1>Work on code</h1>
<aside class="notes">Now that we've got our connection configured well,
let's try to work on some code! First, let's download the code from
Github.</aside>
</section>

<section>
<pre class="terminal">doug@stage:~$ git clone git@github.com:cpan-testers/cpantesters-web.git
<span class="fragment">Cloning into 'cpantesters-web'...
The authenticity of host 'github.com (192.30.253.112)' can't be established.
RSA key fingerprint is SHA256:nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'github.com,192.30.253.112' (RSA) to the list of known hosts.
Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.</span>
</pre>
<aside class="notes">Uh-oh. Github doesn't know who we are. Probably
because our key is on our local machine, not the SSH server. We could
generate a new key for this SSH server, but too many keys increases the
possibility of losing one, and there's another way.</aside>
</section>

<section>
<h1>Agent Forwarding</h1>
<aside class="notes">To let us connect to other SSH servers from this
SSH server, we can forward a connection to our local SSH agent. Then,
further connections we make can use our agent to do it!</aside>
</section>

<section>
<pre class="terminal">Host stage.cpantesters.org
    User dbell
    <span class="fragment">ForwardAgent yes</span>
Host ct-stage
    Hostname stage.cpantesters.org
</pre>
<aside class="notes">We need to configure agent forwarding to allow the
SSH connection to Github to use the SSH agent on our local laptop here.</aside>
</section>

<section>
<pre class="terminal">doug@stage:~$ git clone git@github.com:cpan-testers/cpantesters-web.git
<span class="fragment">Cloning into 'cpantesters-web'...
remote: Counting objects: 436, done.
Receiving objects: 100% (436/436), 128.08 KiB | 0 bytes/s, done.
remote: Total 436 (delta 0), reused 0 (delta 0), pack-reused 436
Resolving deltas: 100% (169/169), done.</span>
</pre>
<aside class="notes">And now when we try to clone the Git repo, it
works!</aside>
</section>

<section>
<h1>Security</h1>
<aside class="notes">There are some minor security issues with
forwarding agents, most of which involve the administrators of the
machine you're forwarding the agent to: They can use the forwarded agent
to impersonate you while you're connected to their server. This is why
agent forwarding is not enabled by default.</aside>
</section>

</section>
<!-- SCP -->
<section>

<section>
<h1>Transfer Files</h1>
<aside class="notes">In the course of our development, we're likely
going to need to transfer files. Luckily for us, SSH has a way to do
this.</aside>
</section>

<section>
<h1>SCP - Secure Copy</h1>
<h2>scp</h2>
<aside class="notes">
SCP is the tool SSH provides for this. SCP allows us to move files
between machines. For an example, let's download the README file from
our Git repository.
</aside></section>

<section>
<pre class="terminal">doug@local:~$ scp stage.cpantesters.org:www/README.mkdn ./
<span class="fragment">README.mkdn        100% 1743    49.1KB/s   00:00</span></pre>
<aside class="notes">
To download a file, we specify the host we want to download from,
followed by a colon, followed by the path we want to download. This is
relative to our "home" directory, so we don't need to specify a complete
path. Then we specify where we want to copy it to locally. SCP copies
it, and provides us a running status while it does.
</aside></section>

<section>
<pre class="terminal">doug@local:~$ scp ./README.mkdn stage.cpantesters.org:www/
<span class="fragment">README.mkdn        100% 1712    13.5KB/s   00:00</span></pre>
<aside class="notes">
To upload a file, we reverse the arguments. Unfortunately, I haven't
ever gotten SCP to work copying from one remote machine to another
remote machine, though the docs seem to imply that it would work.
</aside></section>

<section>
<h1>Recursively</h1>
<h2><code>scp -r</code></h2>
<aside class="notes">
Like the regular copy command, you can copy things recursively. Unlike
the regular "cp" command, this command uses lower-case r instead of
upper-case R. Enjoy the confusion as you use both all the time.
</aside></section>

<section>
<h1>Rsync</h1>
<h2>For extreme use</h2>
<aside class="notes">
If you find yourself using SCP often, or find yourself scripting with
SCP, you might want to take a look at Rsync, which has a lot more
options including scanning the source/destination to ensure it doesn't
transfer files that are the same in both. I could write an entire talk
on Rsync, it has that many useful features.
</aside></section>

</section>
<!-- SSH Tunnels -->
<section>

<section>
<h1>Networking</h1>
<aside class="notes">
In addition to transferring files, we might also end up needing to
transfer network connections.
</aside></section>

<section>
<h1>Firewall</h1>
<h1>Internal Network</h1>
<aside class="notes">
If our remote server is behind a firewall, which is probably should be,
we might try to run our code but be unable to connect to it over the
Internet.
</aside></section>

<section>
<h1>SSH Tunnel</h1>
<aside class="notes">
To traverse the firewall or gain access to the internal network, we can
open up an SSH tunnel, and use our SSH connection to connect to our
code.
</aside></section>

<section>
<h1><code>ssh stage.cpantesters.org</code></h1>
<h1><code>-L 3000:127.0.0.1:3000</code></h1>
<aside class="notes">
To open up a tunnel, we use the -L flag to ssh when we connect to open
a local port that will connect to someplace as though I was making the
connection from the remote host. So, in this case if we connect locally to port 3000, SSH will forward our connection
through our SSH connection and from there connect to "127.0.0.1" port
3000. So, this acts like we're on the remote machine and connecting to a
local service, but instead I'm here on my laptop.
</aside></section>

<section>
<h1>Localhost</h1>
<h1>Internal Hosts</h1>
<h1>External Hosts</h1>
<aside class="notes">
We don't just have to connect to localhost, we can do this with any
address.  We can connect to any internal server, the DNS lookup will be
performed by the remote host. This is good for if the server is part of
a VPN.  We could also even try connecting to Amazon or Google. But
remember that this is just forwarding the connection, it isn't fixing
the HTTP (so, it probably won't work the way you might want).
</aside></section>

<section>
<h1>SOCKS Proxy</h1>
<h2><code>ssh stage.cpantesters.org -D 3000</code></h2>
<aside class="notes">
To actually navigate any website through the SSH tunnel, you can set up
a SOCKS proxy using the -D flag and then configure your browser to use
your SSH connection as a proxy, but that's more advanced than we have
time for here.
</aside></section>

<section>
<h1><code>ssh stage.cpantesters.org</code></h1>
<h1><code>-R 3000:127.0.0.1:3000</code></h1>
<aside class="notes">
We can also do this in reverse to invite the remote server to use our
local machine to make connections to 127.0.0.1 port 3000.  I've never
done this, but it might be used to show off code running on your laptop
to someone on the server (perhaps they've used -L to set up their own
tunnel to see your code).
</aside></section>

</section>


<section>

<section>
<h1>Extra Stuff</h1>
</section>

<section>
<h1>SSH can run Commands</h1>
</section>

<section>
<h1>Pipe those commands</h1>
<h2><code>ssh stage.cpantesters.org find www</code></h2>
<h2><code>| grep .ep</code></h2>
</section>

<section>
<h1>SSH escape sequences</h1>
<h2><code>&lt;Enter&gt; ~ ?</code></h2>
</section>

</section>

<!-- Wrap-up -->
<section>
Sources:
    ssh(1)
    ssh-keygen(1)
    ssh-agent(1)
    https://blog.g3rt.nl/upgrade-your-ssh-keys.html
</section>

<section>
<h1>Questions?</h1>
</section>
</div>


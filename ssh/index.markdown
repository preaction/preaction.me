---
title: SSH - Secure Shell
---

The `ssh` command allows for connecting to remote machines to run
programs and transfer files.

## Talks

### [Working Remotely With SSH (Chicago.PM 2018)](talks/chicago-pm-2018)

This talk introduces SSH to anyone who isn't familiar and demonstrates
the basic use-cases of logging in, generating and using SSH keys,
transferring files over SSH, and running the SSH agent.

There is also some discussion of the SSH config file, how SSH agent
forwarding works (and why to use it), and how to set up SSH tunnels (and
why).

<!-- ## Articles -->

## External Resources

* [OpenSSH documentation](https://www.openssh.com/manual.html)

## Related Topics

### [tmux - Terminal Multiplexer](https://github.com/tmux/tmux/wiki)

Using [Tmux](https://github.com/tmux/tmux/wiki) on a system you've
logged in to with SSH allows you to run programs without worrying about
your programs being stopped if you get disconnected. The programs you
run inside a Tmux session will remain running, and you can re-connect to
the server and re-attach to your Tmux session.

Often my first step after logging in to a machine is running a Tmux
session just in case.

### [screen - Terminal Window Manager](https://www.gnu.org/software/screen/)

Much like Tmux, [screen](https://www.gnu.org/software/screen/) lets you
run programs, disconnect from the server, and then reconnect later to
continue your work.

### [rsync - Advanced file transfer](https://rsync.samba.org)

The [rsync](https://rsync.samba.org) command uses SSH (and other
protocols) to synchronize files between servers. This is a more powerful
tool than `scp` for tasks like mirroring data and backups.


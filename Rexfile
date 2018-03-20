
use Rex -feature => [ 1.4 ];
use Rex::Commands::Sync;

group web => 'preaction.me';
group mail => 'mail.preaction.me';
group irc => 'irc.preaction.me';
group git => 'git.preaction.me';

set osversion => '5.5';
set mirror => sprintf 'http://ftp.openbsd.org/pub/OpenBSD/%s', get( 'osversion' );

task setup => sub {
    # add wheel to sudoers
    # %wheel  ALL=(ALL) NOPASSWD: SETENV: ALL
    # Task: Add admin
    # add doug to wheel and wsrc

    # Development environment:
    # cd /usr/ports/editors/vim && env FLAVOR="no_x11 perl python ruby" make install
    # zsh
    # tmux
    # python
    # ruby
    # node
    # git

};

task update_ports => sub {
    if ( run 'ls -d /usr/ports' && $? ) {
        # download and verify ports
        run 'cd /tmp; ftp ' . get( 'mirror' ) . '/ports.tar.gz';
        run 'cd /tmp; ftp ' . get( 'mirror' ) . 'SHA256.sig';
        run 'cd /tmp; signify -C -p /etc/signify/openbsd-55-base.pub -x SHA256.sig ports.tar.gz';
        if ( $? ) {
            die "Checksum failed!";
        }

        run 'cd /usr; sudo tar xzf /tmp/ports.tar.gz';
        run 'chgrp -R wsrc /usr/ports';
        run 'find /usr/ports -type d -exec chmod g+w {} \\;';
    }

    file "/etc/mk.conf", content => template("etc/mk.conf");
};

# ROOTBSD forgets the xshare55.tgz set?
# Task: Install set
# http://mirror.team-cymru.org/pub/OpenBSD/5.5/amd64/ (set name)

# Install znc
# add to crontab: @reboot /usr/local/bin/znc >/dev/null 2>&1
# steal znc config!
# -- uses webadmin though

# Setup gitolite user
task gitolite =>
    group => [qw( git )],
    sub {

    };


task deploy =>
    group => [qw( web )],
    sub {
        Rex::Logger::info( 'Deploying nginx config' );
        sudo sub {
            file '/etc/nginx/sites/preaction.me.conf',
                source => 'etc/nginx.conf';
            run 'nginx -s reload';
        };

        Rex::Logger::info( 'Deploying applications' );
        sync_up 'app', '~/app';

        Rex::Logger::info( 'Deploying service config' );
        file '~/service/todo-app/log',
            ensure => 'directory';
        file '~/service/todo-app/run',
            source => 'etc/service/todo-app/run';
        file '~/service/todo-app/log/run',
            source => 'etc/service/todo-app/log/run';

        Rex::Logger::info( 'Restarting' );
        run 'sv restart ~/service/todo-app';

        Rex::Logger::info( 'Deploying ZNC conf' );
        file '~/.znc/configs',
            ensure => 'directory';
        file '~/.znc/configs/znc.conf',
            source => 'etc/znc.conf';
    };




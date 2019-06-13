
use Rex -feature => [ 1.4 ];
use Rex::Commands::Sync;

group web => 'preaction.me';
group mail => 'mail.preaction.me';
group irc => 'irc.preaction.me';
group git => 'git.preaction.me';

my @packages = qw( zsh tmux git );
task prepare => sub {
    for my $pkg ( @packages ) {
        pkg $pkg, ensure => 'installed';
    }
};

task znc =>
    group => [qw( irc )],
    sub {
        # Install znc
        sudo sub {
            pkg 'znc', ensure => 'installed';
            # Allow systemd to run after logout
            pkg 'dbus', ensure => 'installed';
            pkg 'libpam-systemd', ensure => 'installed';
            # After installing those, must restart!!
            run 'sudo loginctl enable-linger doug';
        };
        # REMEMBER TO ADD THE znc.pem TO YOUR MACHINE'S TRUSTED SSL
        # CERTIFICATES!

        file '/home/doug/.znc/configs/znc.conf',
            source => 'etc/znc.conf';
        file '/home/doug/.config/systemd/user/znc.service',
            source => 'etc/znc.service';
        run 'systemctl --user enable znc.service';
        run 'systemctl --user start znc.service';
    };

# Setup gitolite user
task gitolite =>
    group => [qw( git )],
    sub {
        sudo sub {
            pkg 'gitolite3', ensure => 'installed';
        };



    };


task web =>
    group => [qw( web )],
    sub {
        sudo sub {
            pkg 'nginx', ensure => 'installed';
            pkg 'postgresql-9.6', ensure => 'installed';
            pkg 'carton', ensure => 'installed';
        };

        Rex::Logger::info( 'Deploying nginx config' );
        sudo sub {
            file '/etc/nginx/sites-available/preaction.me.conf',
                source => 'etc/nginx.conf';
            run 'ln -s /etc/nginx/sites-available/preaction.me.conf /etc/nginx/sites-enabled/';
            run 'nginx -s reload';
        };

        Rex::Logger::info( 'Deploying applications' );
        file 'app', ensure => 'directory';
        sync_up 'app', '~/app';

        Rex::Logger::info( 'Deploying service config' );
        file '/home/doug/.config/systemd/user/todo-app.service',
            source => 'etc/todo-app.service';
        file '/home/doug/.config/systemd/user/live-app.service',
            source => 'live-app/live-app.service';

        Rex::Logger::info( 'Starting' );
        run 'systemctl --user enable todo-app.service';
        run 'systemctl --user start todo-app.service';
        run 'systemctl --user enable live-app.service';
        run 'systemctl --user start live-app.service';
    };


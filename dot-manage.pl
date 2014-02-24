#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use File::chdir;

my %commands = (
    init => \&init,
    help => \&help,
    pull => \&pull,
);

my $action = (!$ARGV[0]) ? 'help' : $ARGV[0];

if (exists $commands{$action}) {
    $commands{$action}->();
} else {
    $commands{help}->();
}

sub help {
    print "Usage: dot-manage.pl action [options]\n";
    print "Actions:\n";
    print "\thelp: Prints this message\n";
    print "\tinit: Setup a dot file repo or pull from an existing one\n";
    print "\tpull: Pull latest changes from git\n";
}

sub init {
    my $home = $ENV{"HOME"};
    my $dotDir = $home . "/.dotmanage";

    unless(-d $dotDir or mkdir $dotDir) {
        print "Unable to create directory: " . $dotDir . "\n";
    }

    print "If you haven't already create your git repo on your git server or github\n";
    print "Enter the git repo url: ";
    my $repoUrl = <STDIN>;
    chomp($repoUrl);

    if (-d $dotDir . "/repo") {
        print "Dot Manage has already been initialized!!!\n";
    } else {
        my $cmd = "git clone " . $repoUrl . " " . $dotDir . "/repo";
        system($cmd);
    }
}

sub pull {
    my $repoDir = $ENV{"HOME"} . "/.dotmanage/repo";
    $CWD = $repoDir; {
        print "Getting latest changes from git!\n";
        system("git pull");
    }
};

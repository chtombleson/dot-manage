#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use File::chdir;
use Sys::Hostname;
use File::Slurp;

my %commands = (
    init => \&init,
    help => \&help,
    pull => \&pull,
    status => \&status,
    add => \&add,
    remove => \&remove,
    commit => \&commit,
    push => \&push,
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
    print "\tstatus: Check for any changes\n";
    print "\tadd: Add a file or directory\n";
    print "\tremove: Remove a file or directory\n";
    print "\tcommit: Commit changes\n";
    print "\tpush: Push to git\n";
}

sub init {
    my $home = $ENV{"HOME"};
    my $dotDir = $home . "/.dotmanage";

    unless (-d $dotDir or mkdir $dotDir) {
        print "Unable to create directory: " . $dotDir . "\n";
    }

    if (-d $dotDir . "/repo") {
        print "Dot Manage has already been initialized!!!\n";
    } else {
        print "If you haven't already create your git repo on your git server or github\n";
        print "Enter the git repo url: ";
        my $repoUrl = <STDIN>;
        chomp($repoUrl);

        my $cmd = "git clone " . $repoUrl . " " . $dotDir . "/repo";
        system($cmd);

        symlinkFiles();
    }
}

sub pull {
    my $repoDir = $ENV{"HOME"} . "/.dotmanage/repo";
    $CWD = $repoDir; {
        print "Getting latest changes from git!\n";
        system("git pull");
    }

    symlinkFiles();
}

sub status {
    my $repoDir = $ENV{"HOME"} . "/.dotmanage/repo";

    $CWD = $repoDir; {
        print "Git status: " . $repoDir . "\n";
        system("git status");
    }
}

sub add {
    print "Enter full path to file you want to add: ";
    my $filePath = <STDIN>;
    chomp($filePath);

    unless(-e $filePath) {
        print "File: " . $filePath . " does not exist\n";
        exit;
    }

    my $repoDir = $ENV{"HOME"} . "/.dotmanage/repo";
    my $hostname = hostname;

    unless (-d $repoDir . "/" . $hostname) {
        mkdir $repoDir . "/" . $hostname;
    }

    system("cp -r " . $filePath . " " . $repoDir . "/" . $hostname);

    $CWD = $repoDir; {
        system("git add ./");
    }

    print "Added " . $filePath . "\n";
}

sub remove {
    print "Enter file name or directory name you want to remove: ";
    my $remove = <STDIN>;
    chomp($remove);

    my $repoDir = $ENV{"HOME"} . "/.dotmanage/repo";
    my $hostname = hostname;

    $CWD = $repoDir . "/" . $hostname; {
        system("git rm -rf " . $remove);
    }
    print "Removed: " . $repoDir . "/" . $hostname . "/" . $remove . "\n";
}

sub commit {
    print "Enter your commit message: ";
    my $msg = <STDIN>;
    chomp($msg);

    my $repoDir = $ENV{"HOME"} . "/.dotmanage/repo";

    $CWD = $repoDir; {
        system("git commit -a -m '" . $msg . "'");
    }
    print "Commited Changes!\n";
}

sub push {
    print "Pushing changes to git!\n";
    my $repoDir = $ENV{"HOME"} . "/.dotmanage/repo";

    $CWD = $repoDir; {
        system("git push");
    }
}

sub symlinkFiles {
    my $repoDir = $ENV{"HOME"} . "/.dotmanage/repo";
    my $hostname = hostname;

    unless (-d $repoDir . "/" . $hostname or -d $repoDir . "/_default") {
        print "There is no directory for: " . $hostname . " or a _default directory!!!\n";
        exit;
    }

    if (-d $repoDir . "/" . $hostname) {
        my $path = $repoDir . "/" . $hostname;
        my @files = read_dir($path);

        foreach my $file (@files) {
            unless(-e $ENV{"HOME"} . "/" . $file) {
                system("ln -s " . $path . "/" . $file . " " . $ENV{"HOME"} . "/" . $file);
            }
        }
    } elsif (-d $repoDir . "/_default") {
        my $path = $repoDir . "/_default";
        my @files = read_dir($path);

        foreach my $file (@files) {
            unless(-e $ENV{"HOME"} . "/" . $file) {
                system("ln -s " . $path . "/" . $file . " " . $ENV{"HOME"} . "/" . $file);
            }
        }
    }
}

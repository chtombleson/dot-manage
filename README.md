# Dot Manage

Git based management for dot files.

## Structure for repo

\_default: directory that holds dot files for machines that don't need special dot files.

\[hostname\]: directories that are named after a host hold dot files only for that host.

## Installation

Clone this repo:

    $ git clone https://github.com/chtombleson/dot-manage.git

Install Dependencies using [CPANM] (https://raw.github.com/miyagawa/cpanminus/master/cpanm):

    $ cd dot-manage
    $ sudo cpanm ./ --installdeps

Add dot-manage to path:

    $ sudo cp dot-manage.pl /usr/local/bin/dot-manage

Create an empty git repo.

Initialize dot-manage (enter the empty git repo details, repo is stored here: ~/.dotmanage/repo):

    $ dot-manage init

## Usage
    Usage: dot-manage.pl action [options]
    Actions:
        help: Prints this message
        init: Setup a dot file repo or pull from an existing one
        pull: Pull latest changes from git
        status: Check for any changes
        add: Add a file or directory
        remove: Remove a file or directory
        commit: Commit changes
        push: Push to git

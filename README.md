# Dot Manage

Git based management for dot files.

## Structure for repo

\_default: directory that holds dot files for machines that don't need special dot files.
\[hostname\]: directories that are named after a host hold dot files only for that host.

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

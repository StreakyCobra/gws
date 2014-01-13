gws
===

`gws` is a KISS, bash, colorful, vundle-inspired helper to manage workspaces
composed of git repositories.

QuickStart
----------

  * Create a file named `.projects.gws` in the desired folder.
  * Fill it with the projects informations (see below).
  * Get all repositories with `gws update`.
  * Hack a little bit.
  * Show the status of the workspace with `gws` (`gws status` also works).

How it works
------------

This tool offers some functionalities, among which:

  * It uses a list of projects, named `.projects.gws`, containing many projects
    described by their names, their repository urls, and optionaly an upstream
    url (mapped as a git remote named `upstream`), like:

        work/theSoftware | git@github.com:You/theSoftware.git
        perso/gws        | git@github.com:You/gws.git         | git@github.com:StreakyCobra/gws.git

  * It can use an ignore list, named `.ignore.gws`, containing regular
    expressions which discard some specific projects, for instance to disable on
    your home computer the work-related projects.

        ^work/

  * It can clone non-existing repositories from the projects list (but not
    supress them in case of removal, you have to do it yourself for safety
    reason. Notice that there is the `check` functionnality to identify
    unlisted repositories).

        gws update

  * It can monitor all listed repositories in one command (uncommitted changes,
    untracked changes, branches not synced with origin, ...).

        gws status

    or simply

        gws

  * It can check the workspace for all repositories (known, unknown, ignored,
    missing). Note: This command can be quite slow in large repositories (e.g.
    home folder, because it need to search entire space for unknown repository.

        gws check


Syntaxes
--------

### .projects.gws

One project per line. Must be of the form:

    name | url

or

    name | url | upstream

knowing that:

  * There can be blank lines, but no comments or anything else.

  * The name can be anything not containing `|`. Use `/` to group projects in
    a folder hierarchy.

  * The urls are passed to git as-is, so can be anything accepted by git, but
    must not contain `|`.

### .ignore.gws

One regular expression per line. The regular expression will be matched to
projects name. Some examples:

  * Ignore the folder `work` and all its subfolders:

        ^work/

  * Ignore all repositories ending with `-work`:

        -work$

  * Ignore all repo containing an `a` inside:

        a

Some misc informations
----------------------

  * Except for cloning repositories, this script has not for goal to interact
    with your repositories. So no `pull all`, `push all`, `delete all unused`,
    functionnality will be implemented. This will imply too much checking to
    ensure no loose of informations. Instead, just look the satus of
    the repositories and do needed actions manually on regulare basis.

  * You can use the commands from any subfolder of the workspace (as git does
    for instance).

  * The file `.projects.gws` can easily be verisonned to sync the list of
    projects on which you are working between different computers.

  * The file `.ignore.gws` permit to keep the same list on all computer, but to
    localy disable some projects (for instance work-related projects at home
    because they are unneeded or even not accessible).

  * `gws check` can be quite slow (for instance if the workspace is the home
    folder) because it searches all existing git projects recursively.

Future
------

This project aims to stay simple. I will try to keep the project as alive as
possible for a bash script, by correcting bugs and maybe some improvements.
Also, maybe one day, if I have time, I will rewrite all this script in python or
other more maintainable language.

Context
-------

If you are, like me, a Linux programmer/hacker/coder who use heavily git, you
certainly have a directory in your home folder named `dev`, `workspace`, `code`
or something else that contains all the projects you are working on. For
instance my currently is:

    dev
    ├── archlinux
    │   ├── aur
    │   └── habs
    ├── perso
    │   ├── gws
    │   ├── imaxplore
    │   └── teafree
    ├── config

where `aur`, `habs`, `gws`, `imaxplore`, `teafree`, `config` are git
repositories.

Since I use at least two different computers, one laptop and one at work, I like
to have the same folder structure on both. Of course remembering which project
was added recently and in which folder is tedious.

So I started to thing about using git submodules to register all projects on
which I am working and syncing them with git between the two computers. But
clearly git submodules are not usable because they are working on specific
commit and are not following branches.

No worry. The problem is pretty trivial, so I decided to start write a little
bash script that read a simple list of repositories, and clone them if they
don't exist. And then, commit by commit, the script as grown to finally become
a helper to sync, monitor and check workspaces.

I thought it can be useful to other people, so I made a little cleanup, write
a small documentation, and there it is. I hope you will enjoy it!


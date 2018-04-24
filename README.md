gws
===

`gws` is a KISS, bash, colorful helper to manage workspaces composed of Git
repositories.

SHOW ME PICTURES!
-----------------

Here are some screen captures of `gws`:

![gws](http://streakycobra.github.io/gws/images/001.png)

![gws](http://streakycobra.github.io/gws/images/002.png)

![gws](http://streakycobra.github.io/gws/images/003.png)

![gws](http://streakycobra.github.io/gws/images/004.png)

![gws](http://streakycobra.github.io/gws/images/005.png)

Installation
------------

**Requirements:** `git`, `bash > 4.0`

* **Arch Linux**: Install the [gws](https://aur.archlinux.org/packages/gws/)
  package from AUR

* **openSUSE**: Install the [gws](https://software.opensuse.org/package/gws/)
  package from the devel:tools repository

* **Mac**:

  * On Mac OS X, it may be necessary to upgrade bash to have a version `> 4.0`.
    It could be done with: `brew install bash`.

  * There is currently a [bug](https://github.com/StreakyCobra/gws/issues/17) in
    version `0.1.8`. The script uses some options that are specific to GNU
    `sed` and `cut`, which are not available to OS X versions. A workaround is
    to install `coreutils` and `gnu-sed` with `brew` (`brew install gnu-sed
    coreutils`) and then define the following alias in your `~/.bashrc`:

    ```bash
    alias gws="PATH=/usr/local/opt/coreutils/libexec/gnubin:usr/local/opt/gnu-sed/libexec/gnubin:$PATH gws"
    ```

* **Other Linux**: You simply need to have the `src/gws` bash script
  somewhere in your `$PATH`:

  * If someone made a package for your distribution you are lucky.

  * You can put it directly in `/bin` as root user, but it is complicated to
    keep it up-to-date.

  * It is also possible to put it in your home folder, for example in
    `~/.local/bin`. You have to be sure that this folder is in your `$PATH`. For
    `bash` you can include any directory on your `$PATH` by including `export
    PATH="$PATH:/path/to/scripts/dir"` in your `~/.bashrc`.


On a side note, I could also suggest you to have a look at
[peru](https://github.com/buildinspace/peru) which lets you keep files from
different sources up to date with one command.

Quick Start
----------

* Create a file named `.projects.gws` in a desired workspace folder (e.g.
  `~/dev`) and fill it with project definitions (see [Syntaxes](#projectsgws)
  below):

        # Work related
        work/tools/q | https://github.com/harelba/q.git

        # Other
        contrib/gws  | https://github.com/StreakyCobra/gws.git
        contrib/peru | https://github.com/buildinspace/peru

**or**

* Let `gws` detect existing repositories and create the `.projects.gws` for
  you:

        $ cd path/to/your/workspace
        $ gws init

**and then**

* Clone all missing repositories with `gws update`, or some specific ones with
  `gws clone`.

* Do some hacking.

* Show the status of the workspace with `gws`. It reveals which repositories
  are clean, which ones have uncommited changes, and even which ones are not
  up-to-date with `origin`.

### But better

Let's say you made a `~/dev/` workspace folder and you created your
`.projects.gws` list in it. Then your workspace became really easy to replicate!
Just make this `~/dev` folder a Git repository, add two files and commit them:
`.projects.gws` and the following `.gitignore`:

    # Ignore everything, so all repositories in our case
    *

    # But not these files
    !.projects.gws
    !.gitignore

Now, when you need to get your workspace on another computer, just clone
the `dev` repository, for instance again to the `~/dev` folder. Go into it and
do a `gws update`. Everything is cloned and ready to be hacked!

You want to add a new project into your workspace? Add it to the
`.projects.gws` list, do a `gws update` to get it. Then commit and push the
`.projects.gws` file, so when you arrive at work for instance, you just need to
`git pull` on the `~/dev` folder and then `gws update` to get the same
workspace structure that you had at home.

Why?
----

If you are, like me, a Linux programmer/hacker/coder who uses Git a lot, you
certainly have a directory in your home folder named `dev`, `workspace`, `code`
or something else that contains all the projects you are working on. For
instance my current organisation is:

    dev
    ├── archlinux
    │   ├── aur
    │   └── habs
    ├── perso
    │   ├── gws
    │   ├── imaxplore
    │   └── teafree
    └── config

where `aur`, `habs`, `gws`, `imaxplore`, `teafree`, `config` are Git
repositories.

Since I use at least three different computers - one laptop, one at home and
one at work - I like to have the same folder structure on all of them. Of
course remembering which project was added recently on other computers and in
which folder is tedious.

So I started to think about using Git submodules to register all projects on
which I am working and syncing them with Git between the two computers. But
clearly Git submodules are not usable because they are work with specific
commits and not by following branches.

No worry. The problem is pretty trivial, so I decided to start write a little
bash (YOLO) script that reads a simple list of repositories, and clones them if
they don't exist. And then, commit by commit, the script as grown to finally
become a helper to sync, monitor and check workspaces.

I thought it can be useful to other people, so I made a little cleanup, wrote
some small documentation, and there it is. I hope you will enjoy it!

Features
--------

This tool offers some features, including:

* It uses a list of projects, named `.projects.gws`, containing many projects
  described by their names, their repository URLs, and optionaly an upstream
  URL (mapped as a Git remote named `upstream`), like:

        work/theSoftware | git@github.com:You/theSoftware.git
        perso/gws        | git@github.com:You/gws.git         | git@github.com:StreakyCobra/gws.git

* It can use an ignore list, named `.ignore.gws`, containing regular
  expressions which discard some specific projects, for instance to disable on
  your home computer the work-related projects.

        ^work/

* It can detect already existing repositories and create the projects list
  from that.

        $ gws init

* It can clone missing repositories from the projects list (but not
  delete ones removed from the list, you have to do that manually for safety.
  Note that there is the `check` command to identify unlisted repositories).

        $ gws update

  `update` accepts the `--only-changes` option. If present, repos that have at
  least one remote and are unaffected by the update will not be printed.

* It can also clone a specified selection of missing repositories from the
  projects list, if you don't need all of them right now.

        $ gws clone work/theSoftware

* It can monitor all listed repositories in one command, showing uncommitted
  changes, untracked changes and branches not synced with origin.

        $ gws status

  or simply

        $ gws

  `gws status` and `gws` accept the `--only-changes` option. If present, missing
  repos as well as repos that have at least one remote and only clean branches
  will not be shown.

* It can fetch the modifications from `origin` for all repositories. It is
  useful to make sure you have the latest modifications, for instance before
  getting on a train with no internet connection:

        $ gws fetch

  `fetch` accepts the `--only-changes` option, which has the same effect as for
  `status`.

* It can also (for the same reasons) pull the modifications from origin for
  all repositories (but fast-forward only). Same as `gws fetch`, but also does
  fast-forward merges.

        $ gws ff    # Mnemonic: ff=fast-forward

  `ff` accepts the `--only-changes` option, which has the same effect as for
  `status`.

* It can check the workspace for all repositories (known, unknown, ignored,
  missing). Note: This command can be quite slow in large repositories (e.g.
  home folder), because it needs to search the entire space for unknown
  repositories. Mainly used from time to time to check workspace consistency:

        $ gws check


Syntaxes
--------

### .projects.gws

One project per line. Must be of the form

    <any/folder/path> | <remote_url1> <remote_name1> [ | <remote_url2> <remote_name2> [ |  ... ]]

where

* the `<remote_name1>` can be skipped and `origin` will be used instead.

* the `<remote_name2>` can be skipped and `upstream` will be used instead.

* there must be at least one `<remote_name>` mapping to `origin`.

* there can also be blank lines, comments or inline comments. Comments start
  with `#` and continue to the end of the line.

* the *folder path* can be any valid linux folder path not containing `|`, `#`
  or spaces.

* the *remote names* can be any string not containing `|`, `#` or spaces.

* the *remote URLs* are passed to Git as-is, so they can be anything accepted
  by Git but must not contain `|`, `#` or spaces. For instance if you have SSH
  aliases in your config they are accepted.

### .ignore.gws

One regular expression per line. The regular expression will be matched against
each project's *folder path*. Some examples:

* Ignore the folder `work` and all its subfolders:

        ^work/

* Ignore all repositories ending with `-work`:

        -work$

* Ignore all repos containing an `a` inside:

        a

This function is really useful for locally ignoring some projects that are not
needed or not accessible.


### Theme file

You can customise the color scheme by placing a shell script at one of the
following locations:

 1. `./.git/theme.gws`
 2. `${HOME}/.theme.gws`
 3. `${HOME}/.config/gws/theme`

The first existing file in the above order, if any, will be `source`d into the
main `gws` script if standard output is a terminal. In the theme script you can
redefine the color codes set as `C_*` near the beginning of the main script.

> -Why can't I put this in the projects directory with `.projects.gws` and
  `.ignore.gws`?

Because then if you sync your `.projects.gws` via Git you could inadvertently
pull a commit that writes a theme file containing arbitrary shell code, which
`gws` would then blindly run. You're still owned in other ways if an attacker
has arbitrary write access in your home directory, but this way the write can't
be done remotely over Git.


Other thoughts
--------------

* Except for cloning repositories, this script does not have as a goal to
  interact with your repositories. So no `pull all`, `push all`, `delete all
  unused`, features will be implemented (except fast-forward). This will imply
  too much checking to prevent data loss. Instead, just look at the status of
  the repositories and perform any needed actions manually on regular basis.

* You can use the commands from any subfolder of the workspace (as `git` does
  for instance).

* The file `.projects.gws` can easily be verisoned to sync the list of
  projects between different computers.

* The file `.ignore.gws` allows for keeping the same `.projects.gws` list on
  all computers, but to locally disable some projects (for instance
  work-related projects at home because they are unneeded or even not
  accessible from there).

* `gws check` can be quite slow (for instance if the workspace is the home
  folder) because it searches all existing Git projects recursively.

Future
------

This project aims to stay simple. I will try to keep the project as alive as
possible for a bash script, by correcting bugs and maybe some improvements.
Also, maybe one day, if I have time, I will rewrite all of this script in
Python or other more maintainable language.

*Edit:* It seems there will be a continuation of this idea, and it will be
written in OCaml! I'll let you know if the project matures! In any case this
project will stay here for users who want something simple and portable.

Maintainers
-----------

The project is currently maintained by Emil Lundberg (emlun), after being
started by Fabien Dubosson (StreakyCobra).

Contributors
------------

Many thanks to these people for contributions:

- Frédéric Mahé
- Blount
- Alex Sanchez
- Antoine Belvire
- Pascal Obry
- Thomas Pérennou
- Emil Lundberg
- François Fleur
- Thomas Lemaire

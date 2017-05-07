gws
===

`gws` is a KISS, bash, colorful helper to manage workspaces composed of git
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
    version `0.1.8`. The script use some options that are specific to GNU's
    `sed` and `cut`, which are not available to OS X versions. A workaround is
    to install `coreutils` and `gnu-sed` with `brew` (`brew install gnu-sed
    coreutils`) and then define the following alias inside your `~/.bashrc`
    file:

    ```bash
    alias gws="PATH=/usr/local/opt/coreutils/libexec/gnubin:usr/local/opt/gnu-sed/libexec/gnubin:$PATH gws"
    ```

* **Other Linux**: You simply need to have the `src/gws` bash script
  somewhere inside your `$PATH`:

  * If someone made a package for your distribution you are lucky.

  * You can put it directly in `/bin` as root user, but it is complicated to
    keep it up-to-date.

  * It is also possible to put it in your home folder, for example in
    `~/.local/bin`. You have to be sure that this folder is in your `$PATH`. For
    `bash` you can include any directory on your `$PATH` by including `export
    PATH="$PATH:/path/to/scripts/dir"` in your `~/.bashrc` file.


On a side note, I could also suggest you to have a look at
[peru](https://github.com/buildinspace/peru) which permits to keep files from
different sources up to date with one command.

QuickStart
----------

* Create a file named `.projects.gws` in a desired workspace folder (e.g.
  `~/dev`) and fill it with the projects informations (see
  [Syntaxes below](#projectsgws)):

        # Work related
        work/tools/q | https://github.com/harelba/q.git

        # Other
        contrib/gws  | https://github.com/StreakyCobra/gws.git
        contrib/peru | https://github.com/buildinspace/peru

**or**

* Let it detect existing repositories and create the `.projects.gws` for you
  with:

        $ cd path/to/your/workspace
        $ gws init

**and then**

* Clone all missing repositories with `gws update`, or some specific ones with
  `gws clone`.

* Do some hacking.

* Show the status of the workspace with `gws`. It reveals which repositories are
  clean, which ones have uncommited changes, or even to know which ones are not
  up-to-date with `origin`.

### But better

Let's say you made a `~/dev/` workspace folder and you created your
`.project.gws` list in it. Then your workspace became really easy to replicate!
Just make this `~/dev` folder a git repository, add two files and commit them:
`.projects.gws` and the following `.gitignore`:

    # Ignore everything, so all repositories in our case
    *

    # But no these files
    !.projects.gws
    !.gitignore

Now, when you need to get your workspace on another computer, just clone
the `dev` repository, for instance again to the `~/dev` folder. Go into it and
do a `gws update`. Everything is cloned and ready to be hacked!

You want to add a new project into your workspace? Add it to the `.projects.gws`
list, do a `gws update` to get it. Then commit and push the `.projects.gws`
file, so when you arrive at work for instance, you just need to do `git pull` on
the `~/dev` folder and then `gws update` to find the same workspace structure
that you where having at home.

Why?
----

If you are, like me, a Linux programmer/hacker/coder who uses heavily git, you
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
    ├── config

where `aur`, `habs`, `gws`, `imaxplore`, `teafree`, `config` are git
repositories.

Since I use at least three different computers, one laptop, one at home and one
at work, I like to have the same folder structure on all of them. Of course
remembering which project was added recently on others computer and in which
folder is tedious.

So I started to thing about using git submodules to register all projects on
which I am working and syncing them with git between the two computers. But
clearly git submodules are not usable because they are working on specific
commit and are not following branches.

No worry. The problem is pretty trivial, so I decided to start write a little
bash (YOLO) script that read a simple list of repositories, and clone them if
they don't exist. And then, commit by commit, the script as grown to finally
become a helper to sync, monitor and check workspaces.

I thought it can be useful to other people, so I made a little cleanup, write a
small documentation, and there it is. I hope you will enjoy it!

Functionalities
---------------

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

* It can detect already existing repositories and create the projects list
  from that.

        $ gws init

* It can clone non-existing repositories from the projects list (but not
  supress them in case of removal, you have to do it yourself for safety
  reason. Notice that there is the `check` functionnality to identify
  those unlisted repositories).

        $ gws update

* It can also clone a specified selection of non-existing repositories from the
  projects list, if you don't need all of them right now.

        $ gws clone work/theSoftware

* It can monitor all listed repositories in one command (uncommitted changes,
  untracked changes, branches not synced with origin, ...).

        $ gws status

  or simply

        $ gws

* It can fetch the modifications from `origin` for all repositories, it is
  usefull te be sure to have the latest modifications, for instance before
  going to take the train with no internet connection:

        $ gws fetch

* It can also (for the same reasons) pull the modifications from origin for
  all repositories (but fast-forward only). Syntactic sugar to avoid a `gws
  fetch` and then many merges:

        $ gws ff    # Mnemonic: ff=fast-forward

* It can check the workspace for all repositories (known, unknown, ignored,
  missing). Note: This command can be quite slow in large repositories (e.g.
  home folder, because it need to search entire space for unknown repository.
  Mainly used from time to time to check consistence of the workspace:

        $ gws check


Syntaxes
--------

### .projects.gws

One project per line. Must be of the form:

    <any/folder/path> | <remote_url1> <remote_name1> [ | <remote_url2> <remote_name2> [ |  ... ]]

knowing that:

* The `<remote_name1>` can be skipped and `origin` will be used instead

* The `<remote_name2>` can be skipped and `upstream` will be used instead

* There must be at least one `<remote_name>` mapping to `origin`

* There can also be blank lines, comments or inline comments. Comments start
  with `#` until the end of the line.

* The *folder paths* can be any valid linux folder path not containing `|`, `#`
  or spaces.

* The *remote names* can be any string not containing `|`, `#` or spaces.

* The *remote urls* are passed to git as-is, so can be anything accepted by git,
  but must not contain `|`, `#` or spaces. For instance if you have SSH aliases
  in your config they are accepted.

### .ignore.gws

One regular expression per line. The regular expression will be matched to
projects name. Some examples:

* Ignore the folder `work` and all its subfolders:

        ^work/

* Ignore all repositories ending with `-work`:

        -work$

* Ignore all repo containing an `a` inside:

        a

This function is really usefull for ignoring locally some projects that are not
needed nor accessible.

Other thoughts
--------------

* Except for cloning repositories, this script has not for goal to interact
  with your repositories. So no `pull all`, `push all`, `delete all unused`,
  functionnality will be implemented (except fast-forward). This will imply too
  much checking to ensure no loose of informations. Instead, just look the satus
  of the repositories and do needed actions manually on regular basis.

* You can use the commands from any subfolder of the workspace (as `git` does
  for instance).

* The file `.projects.gws` can easily be verisonned to sync the list of
  projects on which you are working between different computers.

* The file `.ignore.gws` permit to keep the same `.projects.gws` list on all
  computer, but to localy disable some projects (for instance work-related
  projects at home because they are unneeded or even not accessible from
  there).

* `gws check` can be quite slow (for instance if the workspace is the home
  folder) because it searches all existing git projects recursively.

Future
------

This project aims to stay simple. I will try to keep the project as alive as
possible for a bash script, by correcting bugs and maybe some improvements.
Also, maybe one day, if I have time, I will rewrite all this script in python or
other more maintainable language.

*Edit:* It seems there will be a continuation of this idea, and it will be
written in OCaml! I'll let you know if the project maturate! In any case this
project will stay here for users who want something simple and portable.

Maintainers
-----------

The project is currently maintained by Emil Lundberg (emlun), after having been
started by Fabien Dubosson (StreakyCobra).

Contributors
------------

Many thanks to these people for contributions:

- Frédéric Mahé
- Blount
- Alex Sanchez
- Antoine Belvire

# making

`making` is just like `make` except it rebuilds your app on any changes.

Any time your modify your sources, it rebuilds your app, and reruns it.

It's perfect for the people who wants to avoid typing:

```console
<Ctrl-c>
make
./app
```

over and over.

![image](https://github.com/user-attachments/assets/7ffc696c-2e6e-4ee4-a5ee-b8d30dcad4aa)

Behind the scenes, it uses `inotifywait` and filters events using `git` and `make`.
So no need to define a fancy new configuration when everything is already defined by `git` and `make`.

## Usage

Use it just like `make`.
See `making -h` for its specific options:

    NAME
    making - making (re)builds your application on source changes and reruns it.

    SYNOPSYS
        making [--cmd <command|file>] [--no-cmd] [--no-git] [--exclude <regex>] [-h|--help] [-- <make-args>]

    DESCRIPTION
        making calls make, and does so again so whenever a source file changes.
        making executes the rightmost executable TARGET, and restarts it when make succeeds.
        making can foward arguments to make, use 2 dashes to separate making and make arguments to avoid ambiguity.

        making considers source files changes if:
          - it isn't ignored by git (or git isn't use)
          - at least one target isn't up to date according to make

    OPTIONS
        --cmd <command>
        --cmd <file>
            Executes the provided command or file instead of guessing what to execute.
        --no-cmd
            Builds and doesn't run anything.
        --no-git
            Does not use git, only queries make to detect changes.
        --exclude <regex>
            Forwards the <regex> to inotifywait option --exclude (overrides the default behavior of ignoring './.git/*').
        -h | --help
            Prints this help message and exits.

## Install

For Debian based distribution, a package is available at https://aptly.fita.dev.
Follow the instructions to add your repository at https://aptly.fita.dev, then:
```console
sudo apt install making
```

Otherwise, this is a single bash script, just download it inside your `PATH`, for example:
```console
cd /usr/local/bin;
sudo wget https://github.com/AdrienHorgnies/making/blob/main/making;
```

#compdef gws
# Zsh completion for gws

function _gws () {
    local context curcontext=$curcontext state line subcommand
    declare -A opt_args
    local ret=1
    _arguments -C \
        '(-h --help)'{-h,--help}'[Display this help message]' \
        '(-v --version)'{-v,--version}'[Display this application version]' \
        '1: :__gws_commands' \
        '*:: :->args' \
        && ret=0

    case $state in
        (args)
            subcommand=$words[1]
            if [[ $words[1] == global ]] && (( CURRENT >= 3 )); then
                subcommand=$words[2]
            fi
            case $subcommand in
                (check)
                    ;;
                (clone)
                    _dirs
                    ;;
                (fetch)
                    _arguments \
                        '--only-changes[Only repositories with changes will be shown]'
                        compadd -a dopts fargs
                    ;;
                (ff)
                    _arguments \
                        '--only-changes[Only repositories with changes will be shown]'
                        compadd -a dopts fargs
                    ;;
                (init)
                    ;;
                (status)
                    _arguments \
                        '--only-changes[Only repositories with changes will be shown]'
                        compadd -a dopts fargs
                    _dirs
                    ;;
                (update)
                    ;;
            esac
            ;;
    esac

    return ret
}

__gws_commands () {
    local -a _c
    _c=(
        'check:Print difference between projects list and workspace (known/unknown/missing)'
        'clone:Selectively clone specific repositories from projects list'
        'fetch:Print status for all repositories in the workspace, but fetch the origin first'
        'ff:Print status for all repositories in the workspace, but fast forward to origin first'
        'init:Detect repositories and create the projects list'
        'status:Print status for all repositories in the workspace'
        'update:Clone any repositories in the projects list that are missing in the workspace'
    )

    _describe -t commands Commands _c
}

_gws "$@"
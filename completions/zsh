#compdef gws
# Zsh completion for gws

_path_or_command(){
    _alternative 'cmds:commands:(init clone update status fetch ff check)' 'files:filenames:_path_files -/'
}

_arguments "1::path or command:_path_or_command" "2::filenames:_path_files -/"

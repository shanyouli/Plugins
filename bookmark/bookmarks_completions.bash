_completemarks() {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(find "$MARKPATH" -type l -printf "%f\n")
    COMPREPLY=($(compgen -W "${wordlist[@]}" -- "$curw"))
    return 0
}

complete -F _completemarks jump unmark marks
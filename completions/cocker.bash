_cocker_completions() {
    local cur prev cmd subcmd opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd="${COMP_WORDS[1]}"

    if ! command -v docker &> /dev/null; then
        return 0
    fi

    case "$prev" in
        -f|--file|-v|--volume|--env-file|--config)
            COMPREPLY=( $(compgen -f -- "${cur}") )
            return 0
            ;;
    esac

    if [[ $COMP_CWORD -eq 1 ]]; then
        opts=$(docker --help 2>/dev/null | awk '/^  [a-z]/ {print $1}')
    elif [[ $COMP_CWORD -eq 2 ]]; then
        opts=$(docker "$cmd" --help 2>/dev/null | awk '/^  [a-z]/ {print $1}')
    else
        subcmd="${COMP_WORDS[2]}"
        opts=$(docker "$cmd" "$subcmd" --help 2>/dev/null | grep -oE '--[a-zA-Z0-9-]+' | sort -u)
    fi

    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
    return 0
}

complete -F _cocker_completions cocker
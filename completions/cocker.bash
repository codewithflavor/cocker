_cocker_completions() {
    local cur prev cmd subcmd opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    cmd="${COMP_WORDS[1]}" # The main command (e.g., 'container', 'image', etc.)

    if [[ $COMP_CWORD -eq 1 ]]; then
        # Fetch top-level Docker commands
        opts=$(docker --help | awk '/^  [a-z]/ {print $1}')
    elif [[ $COMP_CWORD -eq 2 ]]; then
        # Fetch subcommands for the main command
        opts=$(docker "$cmd" --help 2>/dev/null | awk '/^  [a-z]/ {print $1}')
    else
        # Fetch options for the subcommand
        subcmd="${COMP_WORDS[2]}"
        opts=$(docker "$cmd" "$subcmd" --help 2>/dev/null | grep -oE '--[a-zA-Z0-9-]+' | sort -u)
    fi

    # Provide completions based on the current word
    COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
    return 0
}

complete -F _cocker_completions cocker
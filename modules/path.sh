path_join() {
    local result
    # loop throw all args
    for part in "$@"; do
        result=$(realpath --canonicalize-missing "$result/$part")
    done

    echo "$result"
    return 1
}

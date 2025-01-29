validator_is_folderName_valid() {
    local folderName=$1
    if [[ $folderName =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo TRUE
        return 0
    fi
    echo FALSE
    return 1
}

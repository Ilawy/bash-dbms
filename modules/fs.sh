# filesystem-related helper functions
source "$MODULES_DIR/common.sh"

fs_dirExists() {
    if [[ -e $1 && -d $1 ]]; then
        echo TRUE
        return 0
    fi
    echo FALSE
    return 1
}

fs_fileExists() {
    if [[ -e $1 && -f $1 ]]; then
        echo TRUE
        return 0
    fi
    echo FALSE
    return 1
}

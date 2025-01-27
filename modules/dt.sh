source "${MODULES_DIR:-.}/common.sh"
DT_STRING="string"
DT_NUMBER="number"
DT_BOOL="boolean"

dt_validate() {
    [[ $# -ne 1 || -z $1 ]] && echo "1 argument is required" 1>&2 && return 1
    case "$1" in
    "$DT_STRING" | "$DT_NUMBER" | "$DT_BOOL")
        echo TRUE
        ;;
    *)
        echo FALSE
        ;;
    esac
}

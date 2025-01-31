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

dt_check_value() {
    [[ $# -ne 2 || -z $1 ]] && echo "2 arguments is required" 1>&2 && return 1
    data_type=$1
    data_value=$2
    local is_valid_type=$(dt_validate $data_type)
    # invalid type
    if [[ is_valid_type == FALSE ]]; then
        logwrite "bad data type ($data_type)"
        return 1
    fi
    case "$data_type" in
    "$DT_STRING")
        return 0
        ;;
    "$DT_BOOL")
        if [[ $data_value =~ ^(true|false)$ ]]; then
            return 0
        else
            return 1
        fi
        ;;
    "$DT_NUMBER")
        if [[ $data_value =~ ^[0-9]+$ ]]; then
            return 0
        else
            return 1
        fi
        ;;
    esac

}

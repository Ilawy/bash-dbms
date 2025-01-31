logwrite() {
    if [[ ! -z $BASH_DEBUG && ! -z $1 ]]; then
        # get current time
        local now=$(date +%H:%M:%S)
        # get log file name (ex. YYYY-MM-DD.log)
        local logfile=$(path_join $(dirname $CONFIG_FILE_DIR) "$(date +%F).log")
        echo "[$now] $@" >>$logfile
    fi

}

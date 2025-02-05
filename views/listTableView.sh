views_show_listTableView() {
    if [[ -z $CURRENT_DB ]]; then
        logwrite "cannot list table without active db"
        views_show_alertView "Unexpected Error" "Please reselect the database"
    fi
    if [[ -z $CURRENT_TABLE ]]; then
        logwrite "cannot list table without active table"
        views_show_alertView "Unexpected Error" "Please reselect the table"
    fi
    local table_file="$(path_join $DATABASE_LOCATION_DIR $CURRENT_DB)/$CURRENT_TABLE"
    # check for table file existance
    if [[ ! -e $table_file ]]; then
        logwrite "cannot find the table file (someone messed with data)"
        views_show_alertView "Unexpected Error" "Cannot access table file, please contact support"
        return 1
    fi

    local data=$(cat $table_file)

    col_names=$(jq '.schema | map(.column_name)' <<<"$data")
    col_names_length=$(jq '. | length' <<<"$col_names")

    rows=$(jq '.data' <<<"$data")
    rows_length=$(jq '. | length' <<<"$rows")

    arg_cols=()
    arg_cells=()

    for ((i = 0; i < $col_names_length; i++)); do
        arg_cols+=("--column" "$(jq -r ".[$i]" <<<"$col_names")")
    done

    for ((i = 0; i < $rows_length; i++)); do
        for ((j = 0; j < $col_names_length; j++)); do
            col_name=$(jq -r ".[$j]" <<<"$col_names")
            echo ".data[$i].${col_name}"
            arg_cells+=("$(jq -r ".[$i].${col_name}" <<<"$rows")")
        done
    done
    local result=$(zenity --list --title="Choose script" "${arg_cols[@]}" "${arg_cells[@]}")
    clear
    echo "$result"
    return 1
}

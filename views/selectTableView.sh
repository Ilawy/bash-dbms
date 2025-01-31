views_show_selectTableView() {
    if [[ -z $CURRENT_DB ]]; then
        logwrite "cannot select table without active db"
        views_show_alertView "Unexpected Error" "Please reselect the database"
        return 1
    fi
    # get tables from the current database
    local tables=($(ls $DATABASE_LOCATION_DIR/$CURRENT_DB))
    if [ ${#tables[@]} -eq 0 ]; then
        logwrite "trying to list empty database ($CURRENT_DB)"
        views_show_alertView "Error" "\n\nThere is no tables in [$CURRENT_DB], please create one"
        return 1
    fi

    # create list of tables with ids
    local tables_array=()
    local i=1
    for table in ${tables[@]}; do
        tables_array+=("$i" "$table")
        ((i++))
    done

    local table_id
    table_id=$(dialog --stdout --clear --ok-label "Select" --menu "Choose a table" 12 45 25 "${tables_array[@]}")

    dialog_result=$?

    # check if dialog canseld
    if [ $dialog_result -eq 1 ]; then
        return $dialog_result
    fi

    # get database from array
    local table=${tables[((table_id - 1))]}
    CURRENT_TABLE=$table
    # show table menu
    views_show_tableOptionsView $table
}

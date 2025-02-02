views_show_dropTableView() {
    if [[ -z $CURRENT_DB ]]; then
        logwrite "tried to drop table without active db"
        views_show_alertView "Unexpected Error" "Please reselect the database"
        return 1
    fi
    # get tables from the current database
    local tables=($(ls $DATABASE_LOCATION_DIR/$CURRENT_DB))
    if [ ${#tables[@]} -eq 0 ]; then
        logwrite "tried to list empty database ($CURRENT_DB)"
        views_show_alertView "Error" "\n\nThere's no tables to be deleted in this database"
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
    table_id=$(dialog --stdout --clear --ok-label "Delete" --menu "Choose a table to delete" 12 45 25 "${tables_array[@]}")

    dialog_result=$?

    # check if dialog canceled
    if [ $dialog_result -eq 1 ]; then
        return $dialog_result
    fi

    # get database from array
    local table=${tables[((table_id - 1))]}
    CURRENT_TABLE=$table
    local table_full_path=$DATABASE_LOCATION_DIR/$CURRENT_DB/$table
    if [[ ! -e $table_full_path ]]; then
        logwrite "cannot find table at $table_full_path by $(whoami)"
        views_show_alertView "Error" "Cannot access the table [$table]\nPlease contact the developer"
        return 1
    fi

    local confirm_to_delete
    confirm_to_delete=$(dialog --inputbox "To delete table [$table] please enter the name of the table\n(this step cannot be undone)" 10 40 --stdout)
    if [[ $? -eq 1 ]]; then
        return 1
    fi
    if [[ $confirm_to_delete == $table ]]; then
        rm $table_full_path
    fi

    # if [[ -e $DATABASE_LOCATION_DIR/$CURRENT_DB/$table]]
}

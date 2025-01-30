views_show_selectDBView() {
    # get all databases from database location
    local dbs=($(ls $DATABASE_LOCATION_DIR))

    # check if there is no databases
    if [ ${#dbs[@]} -eq 0 ]; then
        echo "Array is empty"
        views_show_alertView "Error" "\n\nThere is no databases please create one then select it."
        return 1
    fi

    # create an array and push all databases inside
    local dbs_array=()
    local i=1
    for db in ${dbs[@]}; do
        dbs_array+=("$i" "$db")
        ((i++))
    done

    # select database
    local db_id
    db_id=$(dialog --stdout --ok-label "Select" --menu "Choose a database" 12 45 25 "${dbs_array[@]}")

    dialog_result=$?

    # check if dialog canseld
    if [ $dialog_result -eq 1 ]; then
        return $dialog_result
    fi

    # get database from array
    local db=${dbs[((db_id - 1))]}
    CURRENT_DB=$db

    views_show_databaseOptionsView $db
}

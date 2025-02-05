views_show_deleteDBView() {
    # get all databases from database location
    local dbs=($(ls $DATABASE_LOCATION_DIR))

    # check if there is no databases
    if [ ${#dbs[@]} -eq 0 ]; then
        logwrite "tried to delete database without any databases"
        views_show_alertView "Error" "\n\nThere is no databases to delete."
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
    db_id=$(dialog --stdout --clear --ok-label "Select" --menu "Choose a database to delete" 12 45 25 "${dbs_array[@]}")

    dialog_result=$?

    # check if dialog canseld
    if [ $dialog_result -eq 1 ]; then
        return $dialog_result
    fi

    # get database from array
    local db=${dbs[((db_id - 1))]}

    local confirm_to_delete
    confirm_to_delete=$(dialog --inputbox "To delete database [$db] please enter the name of the database\nall tabes and data inside this database will be deleted\n(this step cannot be undone)" 10 40 --stdout)
    if [[ $? -eq 1 ]]; then
        return 1
    fi

    if [[ $confirm_to_delete == $db ]]; then
        # check if database exist
        if [[ $(fs_dirExists "$DATABASE_LOCATION_DIR/$db") == TRUE ]]; then
            rm -rf $DATABASE_LOCATION_DIR/$db
        fi
    fi

}

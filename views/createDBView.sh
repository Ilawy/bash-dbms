views_show_createDBView() {
    while true; do
        local DB_Name
        DB_Name=$(dialog --clear --title "Create Database" --inputbox "\nPlease Enter Database Name:" 10 40 2>&1 >/dev/tty)
        if [ $? -eq 0 ]; then
            # check if DB_Name valid as folder name
            if [[ $(validator_is_folderName_valid "$DB_Name") == TRUE ]]; then
                # check if DB_Name already exist
                if [[ $(fs_dirExists "$DATABASE_LOCATION_DIR/$DB_Name") == TRUE ]]; then
                    logwrite "tried to create database with duplicated name $DB_Name"
                    views_show_alertView "Error" "\n\nDatabase name [$DB_Name] already exist please enter another name."
                    continue
                fi

                # create the database folder
                mkdir -p "$DATABASE_LOCATION_DIR/$DB_Name"
                logwite "new database created with name $DB_Name"
                views_show_alertView "Success" "\n\nDatabase With Name [$DB_Name] created successfully!"
                return 0
            else
                logwite "tried to create database with invalid name $DB_Name"
                views_show_alertView "Error" "\n\nDatabase name [$DB_Name] is not valid please enter Name contains only [a-z A-Z 0-9 and _]."
            fi

        # stop loop then backto main menu
        else
            return 1
        fi
    done

    return 0
}

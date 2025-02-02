schemaObject='[]'
getTableSchema() {
    # create loop and ask the user for table schema
    local primaryKey_At
    local isPrimaryKeySelected="false"
    while true; do
        local column_name
        local column_type

        # ask for column name
        while true; do
            column_name=$(dialog --clear --title "Create Table [Column Name]" --inputbox "\nPlease Enter Column Name:" 10 40 2>&1 >/dev/tty)
            if [ $? -eq 0 ]; then
                # check if column_name valid as name
                if [[ $(validator_is_folderName_valid "$column_name") == FALSE ]]; then
                    logwrite "tried to create table with invalid column name $column_name"
                    views_show_alertView "Error" "\n\nColumn name [$column_name] is not valid please enter Name contains only [a-z A-Z 0-9 and _]."

                elif echo "$schemaObject" | jq -e "any(.[]; .column_name == \"$column_name\")" >/dev/null; then
                    logwrite "tried to create table with duplicated column name $column_name"
                    views_show_alertView "Error" "\n\nColumn name [$column_name] is already exist please enter another name"
                else
                    break
                fi
            # stop function if user cancel the dialog
            else
                return 1
            fi
        done

        # ask for column type
        while true; do
            column_type=$DT_STRING
            local dialogResult=1
            dialogResult=$(dialog --clear --title "Create Table [Column Type]" \
                --menu "Column Type For [$column_name]:" 12 40 4 \
                1 $DT_STRING \
                2 $DT_NUMBER \
                3 $DT_BOOL \
                2>&1 >/dev/tty)
            # if user cancel the dialog then stop the loop
            if [ $? -ne 0 ]; then
                return 1
            else
                case $dialogResult in
                2)
                    column_type=$DT_NUMBER
                    ;;
                3)
                    column_type=$DT_BOOL
                    ;;
                *)
                    column_type=$DT_STRING
                    ;;
                esac
                break
            fi

        done

        # ask for primary key
        dialog --clear --title "Create Table [Primary Key]" \
            --yesno "\nDo You Want To Set [$column_name] As Primary Key?\n\nif you select yes [$column_name] will be set as primary." 12 40 \
            2>&1 >/dev/tty

        # if user cancel the dialog then stop the loop
        if [ $? -eq 0 ]; then
            isPrimaryKeySelected="true"
            primaryKey_At=$column_name
        fi

        local new_object="{ \"column_name\": \"$column_name\", \"column_type\": \"$column_type\", \"primary_key\": false }"

        schemaObject=$(echo "$schemaObject" | jq ". += [$new_object]")

        # ask if user want to add another column
        dialog --clear --title "Create Table" --yesno "Do you want to add another column?" 7 40
        if [ $? -ne 0 ]; then
            break
        fi
    done

    if [ -n "$primaryKey_At" ]; then
        schemaObject=$(echo "$schemaObject" | jq "map(if .column_name == \"$primaryKey_At\" then .primary_key = true else . end)")
    else
        schemaObject=$(echo "$schemaObject" | jq ".[0].primary_key = true")
    fi

    # check if user select any column to be primary
    if [[ $isPrimaryKeySelected == "false" ]]; then
        local first_column_name=$(echo "$schemaObject" | jq -r '.[0].column_name')
        logwrite "tried to create table with no primary key"
        # TODO: add a list of columns to choose primary key from (UX)
        views_show_alertView "Error" "\n\nYou have not set any column as primary key we will set the first column [${first_column_name}] as primary key."
    fi

    return 0
}

views_show_createTableView() {
    $schemaObject='[]'
    local tableObject='{ "schema": [], "data": [] }'

    while true; do
        # ask user for table name
        local table_name
        table_name=$(dialog --clear --title "Create Table" --inputbox "\nPlease Enter Table Name:" 10 40 2>&1 >/dev/tty)
        if [ $? -eq 0 ]; then
            # check if table_name valid as file name
            if [[ $(validator_is_folderName_valid "$table_name") == TRUE ]]; then
                # check if table_name already exist
                if [[ $(fs_fileExists $(path_join "$DATABASE_LOCATION_DIR/$CURRENT_DB" "$table_name")) == TRUE ]]; then
                    logwrite "tried to create table with existing name $table_name"
                    views_show_alertView "Error" "\n\nTable name [$table_name] already exist in database [$CURRENT_DB] please enter another name."
                    continue
                fi

                getTableSchema
                # check if user cansel the dialog
                if [ $? -ne 0 ]; then
                    return 1
                fi

                tableObject=$(echo "$tableObject" | jq -c --argjson val "$schemaObject" '.schema = $val')

                # create the table File
                touch $(path_join "$DATABASE_LOCATION_DIR/$CURRENT_DB" "$table_name")
                echo "$tableObject" >$(path_join "$DATABASE_LOCATION_DIR/$CURRENT_DB" "$table_name")
                logwrite "new table created with name $table_name"
                views_show_alertView "Success" "\n\nTable With Name [$table_name] created successfully!"
                return 0
            else
                logwrite "tried to create table with invalid name $table_name"
                views_show_alertView "Error" "\n\nTable name [$table_name] is not valid please enter Name contains only [a-z A-Z 0-9 and _]."
            fi

        # stop loop then backto main menu
        else
            return 1
        fi
    done

    return 0
}

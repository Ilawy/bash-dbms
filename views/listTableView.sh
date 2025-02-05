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
    local primary_key=$(echo "$data" | jq '.schema[] | select(.primary_key == true)' | jq -r '.column_name')
    local table_length=$(echo "$data" | jq '.data | length')
    if [[ $table_length -eq 0 ]]; then
        logwrite "cannot display an empty table"
        views_show_alertView "Error" "Please add some data to the table [$CURRENT_TABLE] to display them"
        return 1
    fi
    clear

    local selected_line=$({
        # Print header row
        echo -n "index,"
        echo "$data" | jq -r '.schema[].column_name' | paste -s -d ','
        # Print data rows with index
        echo "$data" | jq -r '
            def get_row_values($schema; $row):
              $schema | map($row[.column_name] | tostring);
            .schema as $schema
            | .data
            | to_entries
            | map([.key | tostring] + (get_row_values($schema; .value)))
            | .[]
            | @csv'
    } | gum table --show-help)

    if [[ -z "$selected_line" ]]; then
        # no choice, just go back
        return 1
    fi

    # Extract the row index (first field from CSV)
    local selected_index=$(echo "$selected_line" | cut -d',' -f1)

    clear

    local choice=$(gum choose --header="Select an option" update delete)
    case "$choice" in
    "update")
        views_show_updateRowView $selected_index $table_file $primary_key
        ;;
    "delete")
        views_show_deleteRowView $selected_index $table_file
        ;;
    *)
        views_show_listTableView
        ;;
    esac
    return 1
}

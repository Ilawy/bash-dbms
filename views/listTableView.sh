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
    local table_length=$(echo "$data" | jq '.data | length')
    if [[ $table_length -eq 0 ]]; then
        logwrite "cannot display an empty table"
        views_show_alertView "Error" "Please add some data to the table [$CURRENT_TABLE] to display them"
        return 1
    fi
    local primary_key_index=$(echo "$data" | jq '[.schema[] | .primary_key == true] | index(true)')
    clear
    local row_pk=$({
        # print columns for gum
        echo "$data" | jq --raw-output '.schema[] | .column_name' | paste -s -d ,
        # print rows for gum
        # https://qmacro.org/blog/posts/2022/05/19/json-object-values-into-csv-with-jq/
        echo "$data" | jq -r '.data[] | [ keys_unsorted[] as $k | .[$k] ] | @csv'
    } | gum table -r $primary_key_index --show-help)
    if [[ -z $row_pk ]]; then
        # no choice, just go back
        return 1
    fi
    clear

    local choice=$(gum choose --header="Select an option" update delete)
    case "$choice" in
    "update")
        read -p "Not implemented yet (enter to back)" voided
        views_show_listTableView
        ;;
    "delete")
        read -p "Not implemented yet (enter to back)" voided
        views_show_listTableView
        ;;
    *)
        views_show_listTableView
        ;;
    esac
    # clear
    return 1
}

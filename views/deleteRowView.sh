views_show_deleteRowView() {
    local selected_index=$1
    local table_file=$2

    # get data from table
    local data=$(cat $table_file)

    local modified_data=$(echo "$data" | jq -c --argjson selected_index "$selected_index" '
      .data |= (del(.[$selected_index]))
    ')

    # show confirmation message before deelte
    dialog --title "Confirmation" --yesno "Are you sure you want to delete this row?" 10 40
    if [ $? -eq 1 ]; then
        return 1
    fi

    # write data to table file
    echo "$modified_data" >$(path_join "$table_file")
}

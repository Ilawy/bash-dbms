views_show_updateRowView() {
    local index=$1
    local table_file=$2
    local primary_key=$3

    local data=$(cat $table_file)
    local old_row=$(echo "$data" | jq -r ".data[$index]")

    local keys_length=$(echo "$data" | jq ".schema | length")
    local raw_keys=()
    local keys=()
    for ((i = 0; i < $keys_length; i++)); do
        local f_name=$(echo "$data" | jq -r ".schema[$i].column_name")
        if [[ $f_name == $primary_key ]]; then
            continue
        fi
        # local default_values=($(echo "$data" | jq -r ".schema[$i].default_value"))
        keys+=("$f_name: " $((i + 1)) 1 "" $((i + 1)) 12 24 0)
        raw_keys+=("$f_name")
    done

    form_response=$(
        dialog --stdout --ok-label "Update" \
            --backtitle "Nice" \
            --title "Table [$CURRENT_TABLE] update" \
            --form "Updating something" 20 50 0 "${keys[@]}"
        # 2>&1 1>&3
    )

    if [[ $? -ne 0 ]]; then
        return 1
    fi
    exec 3>&-

    local i=0
    while IFS= read -r value; do
        local f_type=$(echo "$data" | jq -r ".schema[] | select(.column_name == \"${raw_keys[$i]}\") | .column_type ")
        xx=$(dt_check_value $f_type $value)
        if [[ $? -ne 0 ]]; then
            views_show_alertView "Invalid value" "Please check the values you entered"
            return 1
        fi
        old_row=$(echo "$old_row" | jq ".${raw_keys[$i]}=\"$value\"")
        ((i++))
    done <<<"$form_response"

    echo $(cat $table_file | jq ".data[$index] = $old_row") >$(path_join $table_file)
}

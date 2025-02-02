views_show_insertTableView() {
    # MARK: type safety
    # check for current db existance
    if [[ -z $CURRENT_DB ]]; then
        logwrite "cannot find current db (should not happen)"
        views_show_alertView "Unexpected Error" "Please reselect the database"
        return 1
    fi

    # check for current table existance
    if [[ -z $CURRENT_TABLE ]]; then
        logwrite "cannot find current table (should not happen)"
        views_show_alertView "Unexpected Error" "Please reselect the table"
        return 1
    fi
    local table_file="$(path_join $DATABASE_LOCATION_DIR $CURRENT_DB)/$CURRENT_TABLE"
    # check for table file existance
    if [[ ! -e $table_file ]]; then
        logwrite "cannot find the table file (someone messed with data)"
        views_show_alertView "Unexpected Error" "Cannot access table file, please contact support"
        return 1
    fi
    # get current raw json data of the file
    local data=$(cat $table_file)
    local fields_count=$(echo $data | jq ".schema | length")
    # EDGE CASE: a table created by hand with no fields
    if [[ $fields_count -eq 0 ]]; then
        logwrite "accessed a table with no fields [$CURRENT_DB/$CURRENT_TABLE]"
        views_show_alertView "Unexpected Error" "Cannot access table, please recreate this table"
        # TODO: remove the table file here
    fi
    # MARK: building the form
    # putting form fields in array of arguments
    local fields_array=()
    local pk_key=""
    # TODO: set default values to be setted in case of invalid values (UX)
    default_values=("$1")
    for ((i = 0; i < $fields_count; i++)); do
        # get props of schema fields from the array
        field=$(echo $data | jq ".schema[$i]")
        f_name=$(echo $field | jq -r ".column_name")
        is_pk=$(echo $field | jq -r ".primary_key")
        # TODO: discuss whether this should be removed or not
        if [[ $is_pk == "true" ]]; then
            pk_key="$f_name"
            f_name+=" (pk)"
        fi

        fields_array+=("$f_name: " $((i + 1)) 1 ${default_values[$i]:-""} $((i + 1)) 12 24 0)
    done
    form_response=$(
        # TODO: add backtitle to all dialogs
        dialog --stdout --ok-label "Insert" \
            --backtitle "Nice" \
            --title "Table [$CURRENT_TABLE] insert" \
            --form "Creating something" 20 50 0 "${fields_array[@]}"
        # 2>&1 1>&3
    )
    # cancel
    if [[ $? -eq 1 ]]; then
        return 0
    fi

    exec 3>&-

    # MARK: validate & set
    result_object="{}"
    local i=0
    while IFS= read -r f_value; do
        field=$(echo $data | jq ".schema[$i]")
        f_name=$(echo $field | jq -r ".column_name")
        f_type=$(echo $field | jq -r ".column_type")
        is_pk=$(echo $field | jq -r ".primary_key")

        dt_check_value "$f_type" "$f_value"
        local ret=$?
        default_values+=("${f_value}")
        if [[ $ret -eq 0 ]]; then
            local quoted_name="\"$f_name\""
            local quoted_value="\"$f_value\""
            result_object=$(echo $result_object | jq ". += {$quoted_name: $quoted_value}")
        else
            logwrite "tried to insert table with wrong input for field [$f_name] of type $f_type"
            views_show_alertView "Type error" "Field [$f_name] of type $f_type recevied wrong input"
            views_show_insertTableView
            return
        fi
        ((i++))
    done <<<"$form_response"
    # MARK: pk check
    data_len=$(echo $data | jq ".data | length")
    for ((i = 0; i < $data_len; i++)); do
        local iter_pk_val=$(echo $data | jq ".data[$i].$pk_key")
        local new_pk_val=$(echo $result_object | jq ".$pk_key")
        if [[ $iter_pk_val == $new_pk_val ]]; then
            logwrite "tried to insert table with duplicate primary key [$pk_key]"
            views_show_alertView "Duplication error" "Field [$pk_key] has a duplicate value"
            views_show_insertTableView
            return 0
        fi
    done
    # MARK: push new row
    final_data=$(jq ".data += [${result_object}]" <<<$data)
    echo $final_data >$table_file
    logwrite "added new row to table [$CURRENT_TABLE]"
    views_show_alertView "Done" "Data added successfully"
}

# data=$(cat ~/Library/__data__/students/kg2)

# fields_count=$(echo $data | jq ".schema | length")

# fields_array=()
# default_values=()
# pk_id=""
# for ((i = 0; i < $fields_count; i++)); do
#     field=$(echo $data | jq ".schema[$i]")
#     f_name=$(echo $field | jq -r ".column_name")
#     is_pk=$(echo $field | jq -r ".primary_key")
#     if [[ $is_pk == "true" ]]; then
#         pk_id=$i
#         f_name+="*"
#     fi

#     fields_array+=("$f_name: " $((i + 1)) 1 ${default_values[$i]:-""} $((i + 1)) 12 24 0)
# done

# X echo ${fields_array[@]}
# X read -p p p

# VALUES=$(
#     dialog --stdout --ok-label "Insert" \
#         --backtitle "LoopA 2" \
#         --title "Table [name] insert" \
#         --form "Create a new user" \
#         20 50 0 "${fields_array[@]}"
#     # 2>&1 1>&3
# )

# exec 3>&-

# for line in "${VALUES}"; do
#     echo "with" "$line"
# done

# while IFS= read -r line; do
#     echo "... $line ..."
# done <<<"$VALUES"

# index_of_row=$(jq '[ .data[] | .id == "1" ] | index(true)' <<<"$1")
# result='{"name" : "ahmed"}'
# echo $(jq ".data[$index_of_row] = ${result}" <<<"$1")

# ------------------ list ------------------

# col_names=$(jq '.schema | map(.column_name)' <<<"$1")
# col_names_length=$(jq '. | length' <<<"$col_names")

# rows=$(jq '.data' <<<"$1")
# rows_length=$(jq '. | length' <<<"$rows")

# arg_cols=()
# arg_cells=()

# for ((i = 0; i < $col_names_length; i++)); do
#     arg_cols+=("--column" "$(jq -r ".[$i]" <<<"$col_names")")
# done

# for ((i = 0; i < $rows_length; i++)); do
#     for ((j = 0; j < $col_names_length; j++)); do
#         col_name=$(jq -r ".[$j]" <<<"$col_names")
#         echo ".data[$i].${col_name}"
#         arg_cells+=("$(jq -r ".[$i].${col_name}" <<<"$rows")")
#     done
# done

# zenity --list --title="Choose script" "${arg_cols[@]}" "${arg_cells[@]}"

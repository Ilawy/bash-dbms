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

old='{
    "names": [],
    "kids": [],
    "a": 3 
}'

echo $(jq '.names  += [{
    "value": "aka"
}]' <<<$old)

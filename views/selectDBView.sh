views_show_selectDBView() {
    local dbs=($(ls $DATABASE_LOCATION_DIR))
    local dbs_array=()
    local i=1
    for db in ${dbs[@]}; do
        dbs_array+=("$i" "$db")
        ((i++))
    done
    local db_id=$(dialog --stdout --ok-label "Select" --menu "Choose a database" 12 45 25 "${dbs_array[@]}")
    local db=${dbs[((db_id - 1))]}
    CURRENT_DB=$db
    views_show_databaseOptionsView $db
}

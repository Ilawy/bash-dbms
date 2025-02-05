views_show_tableOptionsView() {
    local table_name=$1
    local default_choice=1

    while true; do
        local choice=$(
            dialog --stdout --clear --nocancel --ok-label "Select" --default-item $default_choice --menu "Current table: ${CURRENT_DB}/${table_name}" 12 45 25 \
                1 "Insert data" \
                2 "Show data" \
                3 "Delete data" \
                4 "Back"
        )
        case $choice in
        1)
            default_choice=1
            views_show_insertTableView
            ;;
        2)
            default_choice=2
            views_show_listTableView

            ;;
        3)
            default_choice=3
            read -p "Not implemented yet (enter to back)" voided
            ;;
        4)
            default_choice=4
            CURRENT_TABLE=""
            break
            ;;
        esac
    done
}

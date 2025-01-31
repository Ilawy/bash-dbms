views_show_databaseOptionsView() {
    local db_name=$1
    local default_choice=1
    while true; do
        local choice=$(
            dialog --stdout --clear --nocancel --ok-label "Select" --default-item $default_choice --menu "Current Database: ${db_name}" 12 45 25 \
                1 "Create Table" \
                2 "Select Table" \
                3 "Drop Table" \
                4 "Back"
        )
        case $choice in
        1)
            default_choice=1
            views_show_createTableView
            ;;
        2)
            default_choice=2
            read -p "Not implemented yet (enter to back)" voided
            ;;
        3)
            default_choice=3
            read -p "Not implemented yet (enter to back)" voided
            ;;
        4)
            default_choice=4
            CURRENT_DB=""
            break
            ;;
        esac
    done
}

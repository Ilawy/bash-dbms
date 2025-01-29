views_show_alertView() {
    local title=$1
    local message=$2

    dialog --title "$title" --msgbox "$message" 10 40
}

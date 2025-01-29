views_show_mainView() {
    DEFAULT_CHOICE=$1
    CHOICE=$(
        dialog --clear --title "Database Menu" \
            --nocancel --ok-label "Select" \
            --default-item $DEFAULT_CHOICE \
            --menu "\nChoose an option:" 15 50 2 \
            1 "Create Database" \
            2 "Select Database" \
            3 "Settings" \
            4 "Exit" \
            2>&1 >/dev/tty
    )

    local DialogResult=$?

    echo $CHOICE
    return $DialogResult
}

initializeCommands() {
    # check if user has this commands or no

    # check for dialog command
    if ! command -v dialog &>/dev/null; then
        logwrite "command [dialog] not found"
        echo "command [dialog] not found please install [dialog] to continue"
        echo "type"
        echo "sudo apt install dialog"
        exit 1
    fi

    # check for jq command
    if ! command -v jq &>/dev/null; then
        logwrite "command [jq] not found"
        views_show_alertView "Error" "\n\ncommand [jq] not found please install [jq] to continue\ntype\nsudo apt install jq."
        exit 1
    fi

    # check for gum command
    if ! command -v gum &>/dev/null; then
        logwrite "command [gum] not found"
        views_show_alertView "Error" "\n\ncommand [gum] not found please install [gum] to continue\ntype\ go to this url https://github.com/charmbracelet/gum/releases"
        exit 1
    fi
}

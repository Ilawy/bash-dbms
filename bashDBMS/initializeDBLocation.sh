showSelectFolderDialog() {
    # if user accept to configuer the script then go to the next step
    # show dialog to select the location of the database
    local locationDir=""

    while true; do

        # Show dialog and wait for response
        locationDir=$(dialog --title "Please select the location of the database" --fselect "$HOME" 15 55 2>&1 >/dev/tty)

        # Check if the user selected a location or canceled the dialog
        if [ $? -eq 0 ]; then
            # make soure the selectedDir is not a file
            if [[ $(fs_fileExists $locationDir) == TRUE ]]; then
                dialog --clear --title "Message" --msgbox '\nYou have selected a file not a folder please select a folder.' 10 50

            elif [[ $(fs_dirExists $locationDir) == FALSE ]]; then
                mkdir -p $locationDir
                dialog --clear --title "Message" --msgbox "
                You have successfully selected
                [$locationDir] 
                as your default database location" 10 50
                break
            # if user select a dir exist then stop the loop
            else
                break
            fi
        # if cancel then stop the loop
        else
            break
        fi

    done

    # if user cancel the dialog then show message and exit form script
    if [[ $locationDir == "" ]]; then
        dialog --clear --title "bashDBMS" --msgbox '\nYou have cancelled the operation. bashDBMS will now exit.' 10 50
        clear
        exit 1
    fi

    # update the database location in the config file
    ini_set_value $CONFIG_FILE_DIR "database" "location" $locationDir
    # set the database location to the global variable for fast access
    DATABASE_LOCATION_DIR=$locationDir
}

checkForDBLocation() {
    # check if user already config the database location or not
    local locationDir=$(ini_get_value $CONFIG_FILE_DIR "database" "location")

    if [[ $locationDir == "" ]]; then
        # ask the user for configuration process
        dialog --clear --title "bashDBMS" --yesno 'Hello,

Before we proceed, please allow us a moment to configure the default settings for bashDBMS. This configuration process is required only the first time you use bashDBMS.

This step is necessary to begin using bashDBMS.

Would you like to start the configuration now?' 15 55
        # get the response of dialog
        local dialogResult=$?

        # if user reject to configuer the script then exit
        if [[ $dialogResult == 1 ]]; then
            clear
            exit 1
        fi

        showSelectFolderDialog

    else
        # set the database location to the global variable for fast access
        DATABASE_LOCATION_DIR="$locationDir"
    fi
    return 0
}

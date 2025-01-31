MODULES_DIR=$(pwd)/modules
BASHDBMS_DIR=$(pwd)/bashDBMS
VIEWS_DIR=$(pwd)/views

source "./modules/imports.sh"
source "./bashDBMS/initialize.sh"
source "./views/imports.sh"

# initial default script configurations
initializeScript

# show main menu view
DEFAULT_CHOICE=1
while true; do
    logwrite "program started"
    # TODO: confirm to create nested dirs
    if [[ $(fs_dirExists $DATABASE_LOCATION_DIR) == FALSE ]]; then
        mkdir $DATABASE_LOCATION_DIR

    fi
    CHOICE=$(views_show_mainView $DEFAULT_CHOICE)
    # exit from loop if use select exit
    if [ $? -ne 0 ]; then
        break
    fi
    # get options
    case $CHOICE in
    1)
        DEFAULT_CHOICE=1
        views_show_createDBView
        ;;
    2)
        DEFAULT_CHOICE=2
        views_show_selectDBView
        ;;
    3)
        DEFAULT_CHOICE=3
        ;;
    4)
        break
        ;;
    *)
        DEFAULT_CHOICE=1
        ;;
    esac

done

clear

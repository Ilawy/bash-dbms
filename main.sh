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
    CHOICE=$(views_show_mainView $DEFAULT_CHOICE)
    # exit from script if use select exit
    if [ $? -ne 0 ]; then
        exit 0
    fi
    # get options
    case $CHOICE in
    1)
        DEFAULT_CHOICE=1
        views_show_createDBView
        ;;
    2)
        DEFAULT_CHOICE=2
        ;;
    3)
        DEFAULT_CHOICE=3
        ;;
    4)
        exit 0
        ;;
    *)
        DEFAULT_CHOICE=1
        ;;
    esac

done

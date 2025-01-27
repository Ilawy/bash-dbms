# for test
MODULES_DIR=$(pwd)/../modules
source "../modules/common.sh"
source "../modules/fs.sh"
source "../modules/ini.sh"

# path to main folder that contains all config for the main script
SCRIPT_MAIN_FOLDER_NAME=".bashDBMS"
SCRIPT_MAIN_FOLDER_DIR="$HOME/$SCRIPT_MAIN_FOLDER_NAME"

CONFIG_FILE_NAME=".initConfig.ini"
CONFIG_FILE_DIR="$SCRIPT_MAIN_FOLDER_DIR/$CONFIG_FILE_NAME"

# initilize
initializeScript() {
    # if main script dir not exist then create it
    if [[ $(fs_dirExists $SCRIPT_MAIN_FOLDER_DIR) == FALSE ]]; then
        mkdir -p $SCRIPT_MAIN_FOLDER_DIR
    fi
    # if config file not exist create it
    if [[ $(fs_fileExists $CONFIG_FILE_DIR) == FALSE ]]; then
        # create the file
        touch $CONFIG_FILE_DIR
        # add section call [database] and key call [location] and value empty
        # value will be empty until user run script and config the path
        ini_set_value $CONFIG_FILE_DIR "database" "location" ""
    fi

    return 0
}

initializeScript

MODULES_DIR=$(pwd)/modules
BASHDBMS_DIR=$(pwd)/bashDBMS
source "./modules/common.sh"
source "./modules/fs.sh"
source "./modules/ini.sh"
source "./bashDBMS/initialize.sh"

# initial default script configurations
initializeScript

echo $DATABASE_LOCATION_DIR

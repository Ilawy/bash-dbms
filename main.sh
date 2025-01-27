MODULES_DIR=$(pwd)/modules
source "./modules/common.sh"
source "./modules/fs.sh"

echo $(fs_fileExists /etc/passwd)

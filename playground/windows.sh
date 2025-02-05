columns=(
    "--column"
    "ID"
    "--column"
    "name"
    "--column"
    "age"
)

rows=(
    "1" "Mohammed" "25"
    "2" "Ahmed" "30"
    "3" "Hassan" "35"
    "4" "Sayed" "40"

)

zenity --list --title="Choose script" "${columns[@]}" "${rows[@]}"

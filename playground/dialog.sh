# dialog --title "Create Table" --inputbox "\nPlease Enter Table Name:" 10 40 2>&1 >/dev/tty

# dialog --ok-label "Submit" --title "User Info Form" \
#     --form "Enter your details:" 10 40 0 \
#     "Name:" 1 1 "" 1 10 30 0 \
#     "Age:" 2 2 "" 2 10 30 1 \
#     --form "Enter your details:" 20 100 0 \
#     "Name:" 3 3 "" 3 10 30 0 \
#     "Age:" 4 4 "" 4 10 30 1 \
#     2>&1 >/dev/tty

# dialog --title "Confirmation" --yesno "Do you want to continue?" 7 40

primaryKey_At=$(dialog --clear --title "Create Table [Primary Key]" \
    --yesno "\nDo You Want To Set [$column_name] As Primary Key?\n\nif you select yes [$column_name] will be set as primary." 12 40 \
    2>&1 >/dev/tty)

echo "FKFKFF"
echo $primaryKey_At

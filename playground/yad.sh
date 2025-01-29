# holidays=$(echo "Gold Coast,Bali,Phuket,Sydney,other")
# yad --title="My YAD Test" --text="Please enter your details:" \
#     --image="/usr/share/icons/hicolor/48x48/status/phone.png" \
#     --form --date-format="%-d %B %Y" --separator="," --item-separator="," \
#     --field="First Name" \
#     --field="Last Name" \
#     --field="Status":RO \
#     --field="Date of birth":DT \
#     --field="Last holiday":CBE \
#     --field="List your 3 favourite foods:":TXT \
#     "" "" "All round good guy" "Click calendar icon" "$holidays"

#!/bin/bash

# Function to show a dynamic inner form
# show_inner_form() {
#     yad --form --title="Inner Form" --width=250 --height=10 \
#         --field="Dynamic Field 1" \
#         --field="Dynamic Field 2" \
#         --center
# }

# # Fixed-size Parent Window
# yad --form --title="Fixed Form" --width=400 --height=300 \
#     --field="Name" \
#     --field="Email" \
#     --button="Next:3" --button="Cancel:1"

# # If Next is pressed, show the inner form
# if [ $? -eq 3 ]; then
#     show_inner_form
# fi

#!/bin/bash

# yad --notebook --title="Dynamic Form" --width=400 --height=300 \
#     --tab="User Info" --form \
#     --field="Name" \
#     --field="Email" \
#     --tab="Address Info" --form \
#     --field="Street" \
#     --field="City" \
#     --field="ZIP Code"

#!/bin/bash

# plug_id=$(echo $RANDOM) # Generate a unique ID for linking windows

# # Open the main container (will not close)
# yad --form --plug=$plug_id --width=400 --height=300 --title="Main Form" \
#     --field="Switch View:BTN" "bash -c 'yad --form --tabnum=1 --plug=$plug_id --width=400 --height=300 \
#         --field=Name --field=Email'" \
#     --button="Close:1" &

# # Show the initial form inside
# yad --form --tabnum=1 --plug=$plug_id --width=400 --height=300 --field="Street" --field="City" --field="ZIP Code" &

#!/bin/bash

# yad --paned --width=500 --height=400 --title="Main Form" \
#     --form --field="Name" --field="Email" \
#     --form --field="Street" --field="City" --field="ZIP Code"

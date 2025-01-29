# #!/bin/bash

# # Show the combobox (dropdown menu) dialog
# response=$(zenity --list --title="Select Your Country" \
#     --text="Please choose your country" \
#     --column="Country" \
#     "USA" "Canada" "UK" "Australia" "Germany")

# # Display the selected country
# echo "You selected: $response"

# response=$(zenity --forms --title="User Information" \
#     --text="Please enter your details" \
#     --add-entry="Name" \
#     --add-entry="Email")

# # Extract the values
# name=$(echo "$response" | sed -n '1p')
# email=$(echo "$response" | sed -n '2p')

# # Display the collected values
# echo "Name: $name"
# echo "Email: $email"

#!/bin/bash

# Get the screen width and height
screen_width=$(xdpyinfo | awk '/dimensions:/ { print $2 }' | cut -d 'x' -f 1)
screen_height=$(xdpyinfo | awk '/dimensions:/ { print $2 }' | cut -d 'x' -f 2)

# Calculate the dialog box's position to center it
dialog_width=300
dialog_height=150
pos_x=$(((screen_width - dialog_width) / 2))
pos_y=$(((screen_height - dialog_height) / 2))

# Show the form with two input fields, centered
response=$(zenity --forms --title="User Information" \
    --text="Please enter your details" \
    --add-entry="Name" \
    --add-entry="Email" \
    --geometry="${dialog_width}x${dialog_height}+${pos_x}+${pos_y}")

# Extract the values
name=$(echo "$response" | sed -n '1p')
email=$(echo "$response" | sed -n '2p')

# Display the collected values
echo "Name: $name"
echo "Email: $email"

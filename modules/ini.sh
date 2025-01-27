ini_get_value() {
    local INI_FILE="$1"
    local section="$2"
    local key="$3"
    local value

    value=$(awk -F= -v section="$section" -v key="$key" '
    BEGIN { in_section = 0; }
    $0 ~ "^\[" section "\]$" { in_section = 1; next; }
    in_section && $1 ~ "^" key "$" { print $2; exit; }
    $0 ~ "^\[" { in_section = 0; }
  ' "$INI_FILE" | xargs)

    echo "$value"
}

ini_set_value() {
    local INI_FILE="$1"
    local section="$2"
    local key="$3"
    local new_value="$4"

    # Check if section exists
    if ! grep -q "^\[$section\]" "$INI_FILE"; then
        echo "[$section]" >>"$INI_FILE" # Add section if missing
    fi

    # Check if key exists in the section
    if grep -q "^\[$section\]" -A100 "$INI_FILE" | grep -q "^$key="; then
        # Update the key's value
        sed -i "/^\[$section\]/,/^\[/ s|^$key=.*|$key=$new_value|" "$INI_FILE"
    else
        # Add the key-value pair under the section
        sed -i "/^\[$section\]/a$key=$new_value" "$INI_FILE"
    fi
}

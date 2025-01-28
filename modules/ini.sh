ini_get_value() {
    local file="$1"
    local section="$2"
    local key="$3"
    local default_value="$4"

    # Check if file exists
    if [ ! -f "$file" ]; then
        echo "$default_value"
        return
    fi

    # Extract value using awk
    # Only returns value from specified section, even if key exists in multiple sections
    value=$(awk -F'=' '
        /^\[.*\]/ { 
            section=$0;
            gsub(/^\[|\]$/, "", section);
        }
        /=/ {
            gsub(/^[ \t]+|[ \t]+$/, "", $1);  # Trim whitespace from key
            if (section == "'"$section"'" && $1 == "'"$key"'") {
                gsub(/^[ \t]+|[ \t]+$/, "", $2);  # Trim whitespace from value
                print $2;
                found=1;
                exit;
            }
        }
        END {
            if (!found) exit 1;
        }' "$file")

    # Return default value if key not found
    if [ $? -ne 0 ]; then
        echo "$default_value"
    else
        echo "$value"
    fi
}

ini_set_value() {
    local file="$1"
    local section="$2"
    local key="$3"
    local value="$4"

    # Create file if it doesn't exist
    if [ ! -f "$file" ]; then
        touch "$file"
    fi

    # Create temporary file
    local temp_file=$(mktemp)

    # Flags to track section and key status
    local section_exists=false
    local key_updated=false
    local in_target_section=false

    # If file is empty, create section and key directly
    if [ ! -s "$file" ]; then
        echo "[$section]" >"$file"
        echo "$key=$value" >>"$file"
        return
    fi

    # Process the file line by line
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines at the start of file
        if [ -z "$line" ] && [ ! -s "$temp_file" ]; then
            continue
        fi

        # Check for section
        if [[ $line =~ ^\[(.*)\]$ ]]; then
            if [ "${BASH_REMATCH[1]}" == "$section" ]; then
                section_exists=true
                in_target_section=true
            else
                in_target_section=false
            fi
            echo "$line" >>"$temp_file"
            continue
        fi

        # Handle key=value pairs
        if [ "$in_target_section" = true ] && [[ $line =~ ^[[:space:]]*([^=]+)[[:space:]]*=(.*) ]]; then
            # If key exists in current section, update it
            if [ "${BASH_REMATCH[1]}" = "$key" ]; then
                echo "$key=$value" >>"$temp_file"
                key_updated=true
            else
                echo "$line" >>"$temp_file"
            fi
        else
            # Copy all lines from other sections (including duplicate keys)
            echo "$line" >>"$temp_file"
        fi
    done <"$file"

    # Add section and key if they don't exist
    if [ "$section_exists" = false ]; then
        # Add new section at the end of file
        echo >>"$temp_file"
        echo "[$section]" >>"$temp_file"
        echo "$key=$value" >>"$temp_file"
    elif [ "$key_updated" = false ] && [ "$in_target_section" = true ]; then
        # Add new key to existing section
        echo "$key=$value" >>"$temp_file"
    fi

    # Replace original file with temporary file
    mv "$temp_file" "$file"
}

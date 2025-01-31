source "./dt.sh"
source "./common.sh"

# VALID
[[ $(dt_validate "string") == TRUE ]] && echo "(string) OK" || echo "ERROR: (string)"
[[ $(dt_validate "number") == TRUE ]] && echo "(number) OK" || echo "ERROR: (number)"
[[ $(dt_validate "boolean") == TRUE ]] && echo "(boolean) OK" || echo "ERROR: (boolean)"
echo "~~~ invalid cases ~~~"
# INVALID
[[ $(dt_validate " boolean") == FALSE ]] && echo "(non-trimmed) OK" || echo "ERROR: (non-trimmed)"
[[ $(dt_validate "strng") == FALSE ]] && echo "(misspelled) OK" || echo "ERROR: (misspelled)"

echo "~~~ value check ~~~"

{
    $(dt_check_value "string" "hello world")
    [[ $? == 0 ]] && echo "(string 1) OK" || echo "ERROR: (string 1)"
}

{
    $(dt_check_value "string" "245")
    [[ $? == 0 ]] && echo "(string 2) OK" || echo "ERROR: (string 2)"
}

{
    $(dt_check_value "number" "245")
    [[ $? == 0 ]] && echo "(number 1) OK" || echo "ERROR: (number 1)"
}

{
    $(dt_check_value "number" "lol")
    [[ $? -ne 0 ]] && echo "(number 2) OK" || echo "ERROR: (number 2)"
}

{
    $(dt_check_value "boolean" "true")
    [[ $? -eq 0 ]] && echo "(boolean 1) OK" || echo "ERROR: (boolean 1)"
}

{
    $(dt_check_value "boolean" "trua")
    [[ $? -ne 0 ]] && echo "(boolean 2) OK" || echo "ERROR: (boolean 2)"
}

{
    $(dt_check_value "boolean" "false")
    [[ $? -eq 0 ]] && echo "(boolean 3) OK" || echo "ERROR: (boolean 3)"
}

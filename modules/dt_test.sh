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

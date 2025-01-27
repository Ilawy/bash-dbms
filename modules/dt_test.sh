source "./dt.sh"
source "./common.sh"

# VALID
[[ $(dt_validate "string") == TRUE ]] && echo "(string) OK"
[[ $(dt_validate "number") == TRUE ]] && echo "(number) OK"
[[ $(dt_validate "boolean") == TRUE ]] && echo "(boolean) OK"
echo "~~~ invalid cases ~~~"
# INVALID
[[ $(dt_validate " boolean") == FALSE ]] && echo "(non-trimmed) OK"
[[ $(dt_validate "strng") == FALSE ]] && echo "(misspelled) OK"

#!/bin/bash
set -euo pipefail

mod_set_name=$1
echo "1: $1"


echo "test1"
jq '.include[] | select(.name=='\"$mod_set_name\"') | .mods | index("omnilib")' mod-sets.json
jq '.include[] | select(.name=='\"$mod_set_name\"') | .mods | index("omnimatter")' mod-sets.json
echo "test2"
included_set=$(jq '.include[] | select(.name=='\"$mod_set_name\"') | .mods | index("omnilib")' mod-sets.json)
echo "$included_set"


if [[ "$included_set" != "NULL"]]; then
    echo "in"
else
    echo "out"
fi

echo "test3"
included_sett=$(jq '.include[] | select(.name=='\"$mod_set_name\"') | .mods | index("test123")' mod-sets.json)
echo "$included_sett"


if [[ "$included_sett" != "NULL" ]]; then
    echo "in"
else
    echo "out"
fi


jq -c '.[]' mods.json |
while read -r i; do
    mod_repo=$(echo "$i" | jq -cr '.repository')
    mod_name=$(echo "$i" | jq -cr '.name')
    included_set=$(jq '.include[] | select(.name=='\"$mod_set_name\"') | .mods | index('\"$mod_name\"')' mod-sets.json)

    if [[ ! -f ./"$mod_repo"/"info.json" ]]; then
        mod_repo=$mod_repo/$mod_name
    fi

    if [[ -d ./"$mod_repo" ]]; then
        mkdir -p ./factorio/mods/"$mod_name"
        mv ./"$mod_repo"/* ./factorio/mods/"$mod_name"
        rm -r ./"$mod_repo"
    fi

done

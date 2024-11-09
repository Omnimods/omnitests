#!/bin/bash
set -euo pipefail

mod_set_name=$1

echo "mods to move: $(jq '.include[] | select(.name=='\"$mod_set_name\"') | .mods' mod-sets.json)"


jq -c '.[]' mods.json |
while read -r i; do
    mod_repo=$(echo "$i" | jq -cr '.repository')
    mod_name=$(echo "$i" | jq -cr '.name')
    included_set=$(jq '.include[] | select(.name=='\"$mod_set_name\"') | .mods | index('\"$mod_name\"')' mod-sets.json)
    use_SA=$(echo "$i" | jq -cr '.use_SA')

    if [[ ! -f ./"$mod_repo"/"info.json" ]] && [[ "$included_set" != "null" ]]; then
        mod_repo=$mod_repo/$mod_name
    fi

    if [[ -f ./"$mod_repo"/"info.json" ]] && [[ -d ./"$mod_repo" ]]; then
        echo "Moved mod $mod_name"
        mkdir -p ./factorio/mods/"$mod_name"
        mv ./"$mod_repo"/* ./factorio/mods/"$mod_name"
        rm -r ./"$mod_repo"

        if [[ "$use_SA" != true ]] && [[ ! -f "./factorio/mods/mod-list.json" ]]; then
            echo "Moved mod mod-list.json to disable SA"
            mv "mod-list.json" "./factorio/mods/"
        fi
    fi
done

#!/bin/bash
set -euo pipefail

mod_set_name=$1

jq -c '.[]' mods.json |
while read -r i; do
    mod_repo=$(echo "$i" | jq -cr '.repository')
    mod_name=$(echo "$i" | jq -cr '.name')
    included_set=$(jq '.include[] | select(.name=='\"$mod_set_name\"') | .mods | index('\"$mod_name\"')' mod-sets.json)

    if [[ ! -f ./"$mod_repo"/"info.json" ]] $$ [[ "$included_set" != "null" ]]; then
        mod_repo=$mod_repo/$mod_name
    fi

    if [[ -d ./"$mod_repo" ]]; then
        mkdir -p ./factorio/mods/"$mod_name"
        mv ./"$mod_repo"/* ./factorio/mods/"$mod_name"
        rm -r ./"$mod_repo"
    fi
done

#!/bin/bash
set -euo pipefail

mod_set_name=$1

echo "1: $1"

echo jq -c '.include' mod-sets.json | jq '.'
echo "test1"
echo jq -c '.[]' mod-sets.json | jq '.'
echo "test2"


jq -c '.include' mod-sets.json |
while read -r i; do
    setname=$(echo "$i" | jq -cr '.name')
    echo "Setname: $setname"

    if [[ $setname == $mod_set_name ]]; then
        ref=$EVENT_REF
        included_mods=$(echo "$i" | jq -cr '.mods')
        echo "FOUND: $included_mods"
    fi
    
done



jq -c '.[]' mods.json |
while read -r i; do
    mod_repo=$(echo "$i" | jq -cr '.repository')
    mod_name=$(echo "$i" | jq -cr '.name')

    if [[ ! -f ./"$mod_repo"/"info.json" ]]; then
        mod_repo=$mod_repo/$mod_name
    fi

    if [[ -d ./"$mod_repo" ]]; then
        mkdir -p ./factorio/mods/"$mod_name"
        mv ./"$mod_repo"/* ./factorio/mods/"$mod_name"
        rm -r ./"$mod_repo"
    fi

done

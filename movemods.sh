#!/bin/bash
set -euo pipefail

mod_set_name=$1

echo "1: $1"

echo "test0"
jq '.include[]' mod-sets.json
echo "test01"
jq '.include[] | .name' mod-sets.json
echo "test1"
jq '.include[] | select(.name=="pure_omni_qol")' mod-sets.json
echo "test1"
jq '.include[] | select(.name=="$mod_set_name")' mod-sets.json


jq '.include[]' mod-sets.json |
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

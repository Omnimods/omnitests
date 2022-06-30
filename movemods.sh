#!/bin/bash
set -euo pipefail

mod_set_name=$1

echo "1: $1"

mods=(jq -c '.include' mod-sets.json)
echo "mods: $mods"

modss=(jq -c '.include.$mod_set_name' mod-sets.json)
echo "modss: $modss"


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

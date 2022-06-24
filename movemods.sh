#!/bin/bash
set -euo pipefail

pwd
ls -al

jq -c '.[]' mods.json |
while read -r i; do
    mod_repo=$(echo "$i" | jq -cr '.repository')
    mod_name=$(echo "$i" | jq -cr '.name')

    echo $mod_name
    echo $mod_repo

    if [[ ! -f ./"$mod_repo"/"info.json" ]]; then
        mod_repo=$mod_repo/$mod_name
    fi

    echo $mod_name
    echo $mod_repo

    if [[ -d ./"$mod_repo" ]]; then
        mkdir -p ./factorio/mods/"$mod_name"
        mv ./"$mod_repo"/* ./factorio/mods/"$mod_name"
        rm -r ./"$mod_repo"
    fi
done

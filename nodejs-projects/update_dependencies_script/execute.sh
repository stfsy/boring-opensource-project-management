#!/bin/bash

set -ex

declare -r ORIGIN_DOMAIN_AND_PROTOCOL="https://github.com"
declare -r ORIGIN_USER="stfsy"
declare -r REPOSITORIES_FILE="_repositories.txt"
declare -r repositories="$(cat $REPOSITORIES_FILE)"

function remove_current_update_script {
    repository=$1
    script_file="${repository}"/update-deps-and-tag.sh

    if test -f "$script_file"; then
        rm $script_file
    fi
}

function add_update_script {
    repository=$1
    script_file="${repository}"/.update-deps-and-tag.sh
    cp ./update_dependencies_script/.update-deps-and-tag.sh "${script_file}"
}

function commit_push_and_remove_directory {
    repository=$1

    cd $repository
    git add --chmod=+x .update-deps-and-tag.sh
    git add .
    git commit -m "chore: update update dependencies script"
    git push origin master
    
    cd ..
    rm -rf $repository
}

for repository in $repositories; do
    git clone "${ORIGIN_DOMAIN_AND_PROTOCOL}/${ORIGIN_USER}/${repository}"
    
    add_update_script $repository
    remove_current_update_script $repository
    commit_push_and_remove_directory $repository
done
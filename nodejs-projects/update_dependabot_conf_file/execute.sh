#!/bin/bash

set -ex

declare -r ORIGIN_DOMAIN_AND_PROTOCOL="https://github.com"
declare -r ORIGIN_USER="stfsy"
declare -r REPOSITORIES_FILE="_repositories.txt"
declare -r repositories="$(cat $REPOSITORIES_FILE)"

function add_dependabot_file {
    repository=$1
    gh_workflow_file="${repository}"/.github/dependabot.yml
    
    cp ./dependabot_conf_file/dependabot.yml "${gh_workflow_file}"
}

function commit_push_and_remove_directory {
    repository=$1

    cd $repository

    if git diff-index --quiet HEAD --; then
      echo "${repository}: no changes found"
    else
      git add .
      git commit -m "chore: run dependabot only monthly"
      git push origin master
    fi
    
    cd ..
    rm -rf $repository
}

for repository in $repositories; do
    git clone "${ORIGIN_DOMAIN_AND_PROTOCOL}/${ORIGIN_USER}/${repository}"
    
    add_dependabot_file $repository
    commit_push_and_remove_directory $repository
done
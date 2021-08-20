#!/bin/bash

set -ex

declare -r ORIGIN_DOMAIN_AND_PROTOCOL="https://github.com"
declare -r ORIGIN_USER="stfsy"
declare -r REPOSITORIES_FILE="_repositories.txt"
declare -r repositories="$(cat $REPOSITORIES_FILE)"

function add_gh_action_configuration {
    repository=$1
    gh_workflow_file="${repository}"/.github/workflows/release.yml
    
    if test -f "$gh_workflow_file"; then
      echo "${gh_workflow_file} already exists. Skipping directory"
      continue
    fi

    mkdir -p "${repository}"/.github/workflows
    cp ./release_notes/release.yml "${gh_workflow_file}"
}

function add_change_log_script {
    repository=$1
    script_file="${repository}"/.get_latest_changes_for_release_notes.sh
    cp ./release_notes/.get_latest_changes_for_release_notes.sh "${script_file}"
}

function commit_push_and_remove_directory {
    repository=$1

    cd $repository
    git add --chmod=+x .get_latest_changes_for_release_notes.sh
    git add .
    git commit -m "chore: create github releases with changelog"
    git push origin master
    
    cd ..
    rm -rf $repository
}

for repository in $repositories; do
    git clone "${ORIGIN_DOMAIN_AND_PROTOCOL}/${ORIGIN_USER}/${repository}"
    
    add_change_log_script $repository
    add_gh_action_configuration $repository
    commit_push_and_remove_directory $repository
done
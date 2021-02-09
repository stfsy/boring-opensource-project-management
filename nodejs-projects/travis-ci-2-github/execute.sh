#!/bin/bash

set -ex

declare -r ORIGIN_DOMAIN_AND_PROTOCOL="https://github.com"
declare -r ORIGIN_USER="stfsy"
declare -r REPOSITORIES_FILE="_repositories.txt"
declare -r repositories="$(cat $REPOSITORIES_FILE)"

function remove_travis_ci_conf_file {
    repository=$1
    travis_ci_file="${repository}"/.travis.yml

    if test -f "${travis_ci_file}"; then
        rm $travis_ci_file
    fi
}

function add_gh_workflow_conf_file {
    repository=$1
    gh_workflow_file="${repository}"/.github/workflows/tests.yml
    
    if test -f "$gh_workflow_file"; then
      echo "${gh_workflow_file} already exists. Skipping directory"
      continue
    fi

    mkdir -p "${repository}"/.github/workflows
    cp ./tests.yml "${gh_workflow_file}"
}

function commit_push_and_remove_directory {
    repository=$1

    cd $repository
    git add .
    git commit -m "chore: use github actions instead of travis-ci"
    git push origin master
    
    cd ..
    rm -rf $repository
}

for repository in $repositories; do
    git clone "${ORIGIN_DOMAIN_AND_PROTOCOL}/${ORIGIN_USER}/${repository}"
    
    remove_travis_ci_conf_file $repository
    add_gh_workflow_conf_file $repository
    commit_push_and_remove_directory $repository
done
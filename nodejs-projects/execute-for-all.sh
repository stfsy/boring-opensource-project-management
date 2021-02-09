#!/bin/sh

set -x

declare -r ORIGIN_DOMAIN_AND_PROTOCOL="https://github.com"
declare -r ORIGIN_USER="stfsy"
declare -r REPOSITORIES_FILE="_repositories.txt"
declare -r repositories="$(cat $REPOSITORIES_FILE)"

for repository in $repositories; do
    git clone "${ORIGIN_DOMAIN_AND_PROTOCOL}/${ORIGIN_USER}/${repository}"

    cd $repository

    npm install -D conventional-changelog-cli@2.1.1
    has_changes=$(git diff --name-only | grep package -c)

    if [[ has_changes -gt "0" ]]; then
        git add .
        git commit -m "chore: install newest conventional-changelog-cli"
        git push origin master
    fi

    npm run changelog
    has_changes=$(git diff --name-only | grep package -c)

    if [[ has_changes -gt "0" ]]; then
        git add .
        git status
        git commit -m "chore: generate changelog with new format"
        git push origin master
    fi

    cd ..
    rm -rf $repository

done
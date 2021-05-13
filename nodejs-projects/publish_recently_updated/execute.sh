#!/bin/bash

set -ex

declare -r ORIGIN_DOMAIN_AND_PROTOCOL="https://github.com"
declare -r ORIGIN_USER="stfsy"
declare -r REPOSITORIES_FILE="_repositories.txt"
declare -r repositories="$(cat $REPOSITORIES_FILE)"

for repository in $repositories; do
    git clone "${ORIGIN_DOMAIN_AND_PROTOCOL}/${ORIGIN_USER}/${repository}"
    
    cd $repository 
        isRecent=$(git log -1 --format=%cd --date=relative | grep -c -E "hours|minutes")
        isRelease=$(git log -1 --pretty=oneline --abbrev-commit | grep -c release)

        if [[ $isRecent == "1" && $isRelease == "1" ]]; then
            packageName=$(cat package.json | grep name | head -1 | awk -F: '{ print $2 }' | sed 's/[",]//g')
            releaseVersion=$(git log -1 --pretty=oneline --abbrev-commit | awk -Fv '{print $2}')
            isReleased=$(npm show $packageName version | grep -c $releaseVersion)

            if [[ $isReleased != "1" ]]; then
                npm publish
            fi
        fi
    cd ..

    rm -rf $repository 
done
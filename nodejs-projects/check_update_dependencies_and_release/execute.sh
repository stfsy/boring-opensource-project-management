#!/bin/bash

set -ex

declare -r ORIGIN_DOMAIN_AND_PROTOCOL="https://github.com"
declare -r ORIGIN_USER="stfsy"
declare -r REPOSITORIES_FILE="_repositories.txt"
declare -r repositories="$(cat $REPOSITORIES_FILE)"

for repository in $repositories; do
    git clone "${ORIGIN_DOMAIN_AND_PROTOCOL}/${ORIGIN_USER}/${repository}"
    
    cd $repository 
        bash -c ./.update-deps-and-tag.sh
    cd ..

    rm -rf $repository 
done
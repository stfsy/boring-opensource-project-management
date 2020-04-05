#/bin/sh

set -ex

declare -r REMOTE_REPOSITORY_BASE_URL="https://github.com/stfsy"
declare -r REPOSITORIES_FILE="_repositories.txt"
declare -r repositories="$(cat $REPOSITORIES_FILE)"

for repository in $repositories; do
    cd $repository 
    npm publish
    cd ..
done
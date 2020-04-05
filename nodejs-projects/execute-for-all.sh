#/bin/sh

set -ex

declare -r REMOTE_REPOSITORY_BASE_URL="https://github.com/stfsy"
declare -r REPOSITORIES_FILE="_repositories.txt"
declare -r repositories="$(cat $REPOSITORIES_FILE)"

for repository in $repositories; do
    cd $repository
    npm install -D conventional-changelog-cli
    git add package*
    git commit -m "chore: install conventional-changelog-cli"
    git push origin master
    cd ..
done
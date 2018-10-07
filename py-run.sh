#!/bin/bash
set -ev
dir=$(ls -l | grep ^d | awk '/^d/ {print i$NF}' i=`pwd`'/')
for i in $dir
do 
    mes=`python3 check.py $i`
    if [ "$TRAVIS_PULL_REQUEST" != "false" ]
    # just pull request get comments
    then
    echo "Begin Comment"
    curl -H "Authorization: token $GITHUB_TOKEN" -X POST -d "{\"body\": \"$mes\"}" "https://api.github.com/repos/$TRAVIS_REPO_SLUG/issues/$TRAVIS_PULL_REQUEST/comments"
    fi
done
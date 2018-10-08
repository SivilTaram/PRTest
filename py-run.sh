#!/bin/bash
set -v
logfile=log.txt
dir=$(ls -l | grep ^d | awk '/^d/ {print i$NF}' i=`pwd`'/')
exitCode=`python3 check.py $dir $logfile`
logContent=$(cat $logfile)
lastCommit=`curl -X GET https://api.github.com/repos/$TRAVIS_REPO_SLUG/pulls/$TRAVIS_PULL_REQUEST/commits | jq '.[-1].sha' -r`
if [ exitCode == 0 ]
then
buildStatus="Success"
else
buildStatus="Fail"
fi
if [ "$TRAVIS_PULL_REQUEST" != "false" ]
# just pull request get comments
then
curl -H "Authorization: token $GITHUB_TOKEN" -X POST -d "{\"body\": \"**Commit**:$lastCommit  \n\n**Build Status**:  $buildStatus\n\n**Detail**:  $logContent\"}" "https://api.github.com/repos/$TRAVIS_REPO_SLUG/issues/$TRAVIS_PULL_REQUEST/comments"
fi
exit $exitCode

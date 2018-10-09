#!/bin/bash
set -v
logfile=log.txt
dir=$(ls -l | grep ^d | awk '/^d/ {print i$NF}' i=`pwd`'/')
curl -X GET "https://api.github.com/repos/$TRAVIS_REPO_SLUG/pulls/$TRAVIS_PULL_REQUEST/commits" > commit.log
lastCommit=`cat commit.log | jq '.[-1].sha' -r`
shellSuccess=0

for i in $dir
do
  exitCode=`python3 check.py $i $logfile`
  logContent=$(cat $logfile)
  if [ exitCode == 0 ]
  then
  buildStatus="Success"
  else
  buildStatus="Fail"
  shellSuccess=-1
  fi
  if [ "$TRAVIS_PULL_REQUEST" != "false" ]
  # just pull request get comments
  then
  curl -H "Authorization: token $GITHUB_TOKEN" -X POST -d "{\"body\": \"**Commit**:$lastCommit  \n\n**Build Status**:  $buildStatus\n\n**Detail**:  $logContent\"}" "https://api.github.com/repos/$TRAVIS_REPO_SLUG/issues/$TRAVIS_PULL_REQUEST/comments"
  fi
done
exit $shellSuccess

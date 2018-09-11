#!/bin/bash

SCRIPT=$1

if [ ! -z "$JENKINS_USER" ]
then
  CREDENTIALS="-u $JENKINS_USER:$JENKINS_PASSWORD"
fi  

USE_CRUMB=$(curl -s $CREDENTIALS $JENKINS_HOST/api/json | jq -r .useCrumbs)

if [ "$USE_CRUMB" = "true" ]
then
  CRUMB=$(curl -s $CREDENTIALS $JENKINS_HOST/crumbIssuer/api/json | jq -r '"-H " + .crumbRequestField + ":" + .crumb')
fi
 
RESULT=$(curl -s $CREDENTIALS $CRUMB --data-urlencode "script=$(cat $SCRIPT)" $JENKINS_HOST/scriptText)

echo $RESULT

if [[ $RESULT == *"FAILURE"* ]]; then
  exit 1
fi

if [[ $RESULT == *"Exception"* ]]; then
  exit 1
fi

exit 0

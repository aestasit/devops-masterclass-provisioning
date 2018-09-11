#!/bin/bash

PLUGIN=$1

if [ ! -z "$JENKINS_USER" ]
then
  CREDENTIALS="-u $JENKINS_USER:$JENKINS_PASSWORD"
fi  

USE_CRUMB=$(curl -s $CREDENTIALS $JENKINS_HOST/api/json | jq -r .useCrumbs)

if [ "$USE_CRUMB" = "true" ]
then
  CRUMB=$(curl -s $CREDENTIALS $JENKINS_HOST/crumbIssuer/api/json | jq -r '"-H " + .crumbRequestField + ":" + .crumb')
fi

read -r -d '' SCRIPT <<-EOT
String pluginId = '$PLUGIN';
def plugin = Jenkins.instance.updateCenter.getPlugin(pluginId);
if (plugin) {
  plugin.getNeededDependencies().each { dep -> dep.deploy() };
  def d = plugin.deploy();
  def result = d.get();
  if (result.errorMessage) {
    'FAILURE: '.plus(result.errorMessage)
  } else {
    'SUCCESS: '.plus(result)
  }
} else {
  'FAILURE: Not existing plugin <$PLUGIN>';
}
EOT

RESULT=$(curl -s $CREDENTIALS $CRUMB --data "script=$SCRIPT" $JENKINS_HOST/scriptText)

echo $RESULT

if [[ $RESULT == *"FAILURE"* ]]; then
  exit 1
fi

if [[ $RESULT == *"Exception"* ]]; then
  exit 1
fi

exit 0

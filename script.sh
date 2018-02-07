#!/bin/sh
set -e

NOW_DEPLOY_OPTIONS=" --no-clipboard"
NOW_AUTH=""

if [ -n "$NOW_TOKEN" ]
then
    NOW_TOKEN_OPTION=" --token=$NOW_TOKEN"
    NOW_AUTH="$NOW_AUTH $NOW_TOKEN_OPTION"
else
    echo "> Error!! the secret $NOW_TOKEN is required!"
    exit 1;
fi

if [ -n "$PLUGIN_TEAM" ]
then
    echo "> adding team $PLUGIN_TEAM"
    NOW_TEAM_OPTION=" --team $PLUGIN_TEAM"
    NOW_AUTH="$NOW_AUTH $NOW_TEAM_OPTION"
else
    echo "> No team name provided."
fi

if [ -n "$PLUGIN_DEPLOY_NAME" ]
then
    echo "> adding deploy_name $PLUGIN_DEPLOY_NAME"
    NOW_DEPLOY_OPTIONS="${NOW_DEPLOY_OPTIONS} --name $PLUGIN_DEPLOY_NAME"
else
    echo "> No deployment name provided. The directory will be used as the name"
fi

if [ -n "$PLUGIN_TYPE" ]
then
    echo "> adding type $PLUGIN_TYPE"
    NOW_DEPLOY_OPTIONS="${NOW_DEPLOY_OPTIONS} --$PLUGIN_TYPE"
else
    echo "> No deployment type provided."
fi

if [ -n "$PLUGIN_DIRECTORY" ]
then
    NOW_DEPLOY_OPTIONS="${NOW_DEPLOY_OPTIONS}"
    echo "> Deploying $PLUGIN_DIRECTORY on now.sh…" &&
    NOW_DEPLOYMENT_URL=$(now $NOW_AUTH $NOW_DEPLOY_OPTIONS $PLUGIN_DIRECTORY) &&
    echo "> Success! Deployment complete to $NOW_DEPLOYMENT_URL";
else
    echo "> Error!! the directory parameter is required"
fi

if [ -n "$PLUGIN_ALIAS" ]
then
    echo "> Assigning alias…" &&
    ALIAS_SUCCESS_MESSAGE=$(now alias $NOW_AUTH $NOW_DEPLOYMENT_URL $PLUGIN_ALIAS) &&
    echo "$ALIAS_SUCCESS_MESSAGE" &&
    NOW_DEPLOYMENT_URL="https://$PLUGIN_ALIAS";
fi

if [ "$PLUGIN_CLEANUP" == "true" ]
then
    echo "> Cleaning up old deployments…" &&
    echo "now rm --safe --yes $NOW_AUTH $PLUGIN_ALIAS" &&
    ALIAS_SUCCESS_MESSAGE=$(now rm --safe --yes $NOW_AUTH $PLUGIN_ALIAS) &&
    echo "$ALIAS_SUCCESS_MESSAGE"
fi

if [ -n "$PLUGIN_SCALE" ]
then
    echo "> Scaling…" &&
    SCALE_SUCCESS_MESSAGE=$(now scale $NOW_AUTH $NOW_DEPLOYMENT_URL $PLUGIN_SCALE) &&
    echo "$SCALE_SUCCESS_MESSAGE";
fi

if [ -n "$PLUGIN_RULES_DOMAIN" ] && [ -n "$PLUGIN_RULES_FILE" ]
then
    echo "> Assigning domain rules…" &&
    RULES_SUCCESS_MESSAGE=$(now alias $NOW_AUTH $PLUGIN_RULES_DOMAIN -r $PLUGIN_RULES_FILE) &&
    echo "$RULES_SUCCESS_MESSAGE" &&
    NOW_DEPLOYMENT_URL=$PLUGIN_ALIAS;
fi

## Check exit code
rc=$?; 
if [[ $rc != 0 ]];
then 
    echo "> non-zero exit code $rc" &&
    exit $rc
else
    echo $'\n'"> Successfully deployed! $NOW_DEPLOYMENT_URL"$'\n'
fi
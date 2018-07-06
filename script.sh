#!/bin/sh
set -e

NOW_DEPLOY_OPTIONS=" --no-clipboard"
NOW_AUTH=""

# Get the token or error
if [ -z "$PLUGIN_NOW_TOKEN" ]
then
    # No explicit token provided, check for secret
    if [ -z "$NOW_TOKEN" ]
    then
        echo "> Error!! either the parameter now_token or the secret NOW_TOKEN is required!"
        exit 1;
    else
        PLUGIN_NOW_TOKEN="$NOW_TOKEN"
    fi
fi

if [ -n "$PLUGIN_TEAM" ]
then
    echo "> adding custom team scope $PLUGIN_TEAM"
    NOW_TEAM_OPTION="--team $PLUGIN_TEAM"
else
    echo "> No custom team scope provided."
fi

NOW_AUTH="$NOW_AUTH --token $PLUGIN_NOW_TOKEN $NOW_TEAM_OPTION"

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
    echo "> No deployment type provided, now.sh will try to detect it..."
fi

if [ -n "$PLUGIN_LOCAL_CONFIG" ]
then
    echo "> using local config at path $PLUGIN_LOCAL_CONFIG"
    NOW_DEPLOY_OPTIONS="${NOW_DEPLOY_OPTIONS} -A $PLUGIN_LOCAL_CONFIG"
else
    echo "> No local config provided, now will not use a local config"
fi

if [ -n "$PLUGIN_DIRECTORY" ]
then
    echo "> Deploying $PLUGIN_DIRECTORY on now.sh…"
fi

NOW_DEPLOYMENT_URL=$(now $NOW_AUTH $NOW_DEPLOY_OPTIONS $PLUGIN_DIRECTORY) &&
echo "> Success! Deployment complete to $NOW_DEPLOYMENT_URL";

if [ -n "$PLUGIN_LOCAL_CONFIG" ]
then
    # Use alias in local config instead of set alias
    echo "> Assigning alias…" &&
    ALIAS_SUCCESS_MESSAGE=$(now alias $NOW_AUTH $NOW_DEPLOYMENT_URL) &&
    echo "$ALIAS_SUCCESS_MESSAGE"
    NOW_DEPLOYMENT_URL=$(cut -d " " -f2 <<< $ALIAS_SUCCESS_MESSAGE
fi

if [ -n "$PLUGIN_ALIAS" ] && [ -z "$PLUGIN_LOCAL_CONFIG" ]
then
    echo "> Assigning alias…" &&
    ALIAS_SUCCESS_MESSAGE=$(now alias $NOW_AUTH $NOW_DEPLOYMENT_URL $PLUGIN_ALIAS) &&
    echo "$ALIAS_SUCCESS_MESSAGE" &&
    NOW_DEPLOYMENT_URL="https://$PLUGIN_ALIAS";
fi

if [ "$PLUGIN_CLEANUP" == "true" ]
then
    if [ -n "$PLUGIN_ALIAS" ]
    then
        echo "> Cleaning up old deployments…" &&
        ALIAS_SUCCESS_MESSAGE=$(now rm --safe --yes $NOW_AUTH $PLUGIN_ALIAS) &&
        echo "$ALIAS_SUCCESS_MESSAGE"
    else
        echo "> Warning!! You must set the alias parameter when using the cleanup parameter so that now.sh knows which deployments to remove!"
    fi
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
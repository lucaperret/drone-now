#!/bin/sh
set -e

nowBin="./node_modules/.bin/now"

NOW_OPTIONS=""

if [ -n "$PLUGIN_GIT_REPOSITORY" ]
then
    NOW_OPTIONS+=" $PLUGIN_GIT_REPOSITORY"
fi

NOW_OPTIONS+=" --no-clipboard"

if [ -n "$PLUGIN_DEPLOY_NAME" ]
then
    NOW_OPTIONS+=" --name $PLUGIN_DEPLOY_NAME"
fi

if [ -n "$PLUGIN_TEAM" ]
then
    NOW_OPTIONS+=" --team $PLUGIN_TEAM"
fi

if [ -n "$PLUGIN_TYPE" ]
then
    NOW_OPTIONS+=" --$PLUGIN_TYPE"
fi

if [ -n "$PLUGIN_TOKEN" ]
then
    NOW_OPTIONS+=" --token $PLUGIN_TOKEN "
    echo "> Deploying on now.sh…"
    NOW_DEPLOYMENT_URL=`$nowBin$NOW_OPTIONS`
    echo "> Success! Deployment complete to $NOW_DEPLOYMENT_URL!"
else
    echo "> Error! NOW_TOKEN is required"
fi

if [ -n "$PLUGIN_ALIAS" ]
then
    ALIAS_SUCCESS_MESSAGE=`$nowBin alias $NOW_DEPLOYMENT_URL $PLUGIN_ALIAS --token $PLUGIN_TOKEN`
    echo "$ALIAS_SUCCESS_MESSAGE"
    NOW_DEPLOYMENT_URL=$NOW_ALIAS
fi

if [ -n "$PLUGIN_SCALE" ]
then
    SCALE_SUCCESS_MESSAGE=`$nowBin scale $NOW_DEPLOYMENT_URL $PLUGIN_SCALE --token $PLUGIN_TOKEN`
    echo "$SCALE_SUCCESS_MESSAGE"
fi

if [ -n "$PLUGIN_RULES_DOMAIN" ] && [ -n "$PLUGIN_RULES_FILE" ]
then
    RULES_SUCCESS_MESSAGE=`$nowBin alias $PLUGIN_RULES_DOMAIN -r $PLUGIN_RULES_FILE --token $PLUGIN_TOKEN`
    echo "$RULES_SUCCESS_MESSAGE"
    NOW_DEPLOYMENT_URL=$NOW_ALIAS
fi

echo $'\n'"> Successfully deployed! $NOW_DEPLOYMENT_URL"$'\n'
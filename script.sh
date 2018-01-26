#!/bin/sh
set -e

nowBin="now"

NOW_OPTIONS=""

if [ -n "$PLUGIN_GIT_REPOSITORY" ]
then
    NOW_OPTIONS="${NOW_OPTIONS} $PLUGIN_GIT_REPOSITORY"
fi

NOW_OPTIONS="${NOW_OPTIONS} --no-clipboard"

if [ -n "$PLUGIN_DEPLOY_NAME" ]
then
    echo "> adding deploy_name $PLUGIN_DEPLOY_NAME"
    NOW_OPTIONS="${NOW_OPTIONS} --name $PLUGIN_DEPLOY_NAME"
fi

if [ -n "$PLUGIN_TEAM" ]
then
    echo "> adding team $PLUGIN_TEAM"
    NOW_OPTIONS="${NOW_OPTIONS} --team $PLUGIN_TEAM"
fi

if [ -n "$PLUGIN_TYPE" ]
then
    echo "> adding type $PLUGIN_TYPE"
    NOW_OPTIONS="${NOW_OPTIONS} --$PLUGIN_TYPE"
fi

if [ -n "$NOW_TOKEN" ] && [ -n "$PLUGIN_DIRECTORY" ]
then
    NOW_OPTIONS="${NOW_OPTIONS} --token $NOW_TOKEN "
    echo "> Deploying on now.sh… with options ${NOW_OPTIONS} $PLUGIN_DIRECTORY"
    $nowBin$NOW_OPTIONS
    # NOW_DEPLOYMENT_URL=$($nowBin$NOW_OPTIONS)
    echo "> Success! Deployment complete to $NOW_DEPLOYMENT_URL!"
else
    echo "> Error! NOW_TOKEN and `directory` parameter are required"
fi

if [ -n "$PLUGIN_ALIAS" ]
then
    ALIAS_SUCCESS_MESSAGE=`$nowBin alias $NOW_DEPLOYMENT_URL $PLUGIN_ALIAS --token $PLUGIN_API_TOKEN`
    echo "$ALIAS_SUCCESS_MESSAGE"
    NOW_DEPLOYMENT_URL=$NOW_ALIAS
fi

if [ -n "$PLUGIN_SCALE" ]
then
    SCALE_SUCCESS_MESSAGE=`$nowBin scale $NOW_DEPLOYMENT_URL $PLUGIN_SCALE --token $PLUGIN_API_TOKEN`
    echo "$SCALE_SUCCESS_MESSAGE"
fi

if [ -n "$PLUGIN_RULES_DOMAIN" ] && [ -n "$PLUGIN_RULES_FILE" ]
then
    RULES_SUCCESS_MESSAGE=`$nowBin alias $PLUGIN_RULES_DOMAIN -r $PLUGIN_RULES_FILE --token $PLUGIN_API_TOKEN`
    echo "$RULES_SUCCESS_MESSAGE"
    NOW_DEPLOYMENT_URL=$NOW_ALIAS
fi

echo $'\n'"> Successfully deployed! $NOW_DEPLOYMENT_URL"$'\n'
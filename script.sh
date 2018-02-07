#!/bin/sh
set -e

echo "PLUGIN_TOKEN is ${PLUGIN_TOKEN}"

NOW_OPTIONS=""

if [ -n "$NOW_TOKEN" ]
then
    NOW_OPTIONS="--token=$NOW_TOKEN --no-clipboard"
else
    echo "> Error!! the secret $NOW_TOKEN is required!"
fi

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

if [ -n "$PLUGIN_DIRECTORY" ]
then
    NOW_OPTIONS="${NOW_OPTIONS}"
    echo "> Deploying on now.sh… with options ${NOW_OPTIONS} $PLUGIN_DIRECTORY" &&
    echo "Executing: $nowBin $NOW_OPTIONS $PLUGIN_DIRECTORY" &&
    NOW_DEPLOYMENT_URL=$(now $NOW_OPTIONS) &&
    # NOW_DEPLOYMENT_URL=$($nowBin$NOW_OPTIONS)
    echo "> Success! Deployment complete to $NOW_DEPLOYMENT_URL";
    # echo "> Success! Deployment complete to $NOW_DEPLOYMENT_URL!"
else
    echo "> Error!! the `directory` parameter is required"
fi

# if [ -n "$PLUGIN_ALIAS" ]
# then
#     ALIAS_SUCCESS_MESSAGE=`$nowBin alias $NOW_DEPLOYMENT_URL $PLUGIN_ALIAS --token $PLUGIN_API_TOKEN`
#     echo "$ALIAS_SUCCESS_MESSAGE"
#     NOW_DEPLOYMENT_URL=$NOW_ALIAS
# fi

# if [ -n "$PLUGIN_SCALE" ]
# then
#     SCALE_SUCCESS_MESSAGE=`$nowBin scale $NOW_DEPLOYMENT_URL $PLUGIN_SCALE --token $PLUGIN_API_TOKEN`
#     echo "$SCALE_SUCCESS_MESSAGE"
# fi

# if [ -n "$PLUGIN_RULES_DOMAIN" ] && [ -n "$PLUGIN_RULES_FILE" ]
# then
#     RULES_SUCCESS_MESSAGE=`$nowBin alias $PLUGIN_RULES_DOMAIN -r $PLUGIN_RULES_FILE --token $PLUGIN_API_TOKEN`
#     echo "$RULES_SUCCESS_MESSAGE"
#     NOW_DEPLOYMENT_URL=$NOW_ALIAS
# fi

# echo $'\n'"> Successfully deployed! $NOW_DEPLOYMENT_URL"$'\n'
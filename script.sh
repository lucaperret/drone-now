#!/bin/sh
set -e

NOW_TOKEN_OPTION="--token=$PLUGIN_TOKEN"
NOW_DEPLOY_OPTIONS="${NOW_TOKEN_OPTION} --no-clipboard"

if [ -n "$PLUGIN_NAME" ]
then
    NOW_DEPLOY_OPTIONS="${NOW_DEPLOY_OPTIONS} --name ${PLUGIN_NAME}"
fi

if [ -n "$PLUGIN_TYPE" ]
then
    NOW_DEPLOY_OPTIONS="${NOW_DEPLOY_OPTIONS} --${PLUGIN_TYPE}"
fi

if [ -n "$PLUGIN_TOKEN" ]
then
    echo "> Deploying on now.sh…" &&
    NOW_DEPLOYMENT_URL=$(now $NOW_DEPLOY_OPTIONS) &&
    echo "> Success! Deployment complete to $NOW_DEPLOYMENT_URL!";
else
    echo "> Error! NOW_TOKEN is required"
fi

if [ -n "$PLUGIN_ALIAS" ]
then
    echo "> Assigning alias…" &&
    ALIAS_SUCCESS_MESSAGE=$(now alias $NOW_DEPLOYMENT_URL $PLUGIN_ALIAS $NOW_TOKEN_OPTION) &&
    echo "$ALIAS_SUCCESS_MESSAGE" &&
    NOW_DEPLOYMENT_URL="https://$PLUGIN_ALIAS";
fi

if [ -n "$PLUGIN_SCALE" ]
then
    echo "> Scaling…" &&
    SCALE_SUCCESS_MESSAGE=$(now scale $NOW_DEPLOYMENT_URL $PLUGIN_SCALE $NOW_TOKEN_OPTION) &&
    echo "$SCALE_SUCCESS_MESSAGE";
fi

if [ -n "$PLUGIN_RULES_DOMAIN" ] && [ -n "$PLUGIN_RULES_FILE" ]
then
    echo "> Assigning domain rules…" &&
    RULES_SUCCESS_MESSAGE=$(now alias $PLUGIN_RULES_DOMAIN -r $PLUGIN_RULES_FILE $NOW_TOKEN_OPTION) &&
    echo "$RULES_SUCCESS_MESSAGE" &&
    NOW_DEPLOYMENT_URL=$PLUGIN_ALIAS;
fi

echo $'\n'"> Successfully deployed! $NOW_DEPLOYMENT_URL"$'\n'
#!/bin/sh
URL=`./node_modules/.bin/now -e NODE_ENV=production --token $NOW_TOKEN`
./node_modules/.bin/now alias $URL $ALIAS --token $NOW_TOKEN
echo "Deployment finished, check it here https://$ALIAS.now.sh"
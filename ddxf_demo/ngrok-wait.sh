#!/bin/bash

# based on code developed by Sovrin:  https://github.com/hyperledger/aries-acapy-plugin-toolbox

# if a tails network is specified, there should be an associated ngrok as well ...
if ! [ -z "$TAILS_NGROK_NAME" ]; then
    echo "ngrok end point [$TAILS_NGROK_NAME]"
    NGROK_ENDPOINT=null
    while [ -z "$NGROK_ENDPOINT" ] || [ "$NGROK_ENDPOINT" = "null" ]
    do
        echo "Fetching end point from ngrok service"
        NGROK_ENDPOINT=$(curl --silent $TAILS_NGROK_NAME:4040/api/tunnels | ./jq -r '.tunnels[0].public_url')

        if [ -z "$NGROK_ENDPOINT" ] || [ "$NGROK_ENDPOINT" = "null" ]; then
            echo "ngrok not ready, sleeping 5 seconds...."
            sleep 5
        fi
    done

    export PUBLIC_TAILS_URL=$NGROK_ENDPOINT
    echo "fetched tails server end point [$PUBLIC_TAILS_URL]"
fi

export AGENT_NAME=$1
shift
echo "Starting [$AGENT_NAME] agent ... with args [$@]"
echo pwd
python -m ddxf_demo.runners.$AGENT_NAME $@

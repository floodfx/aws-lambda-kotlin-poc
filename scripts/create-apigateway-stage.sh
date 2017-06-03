#!/bin/bash -e

PROFILE=default
REST_API_ID=$1
STAGE=$2

if [ -z "$REST_API_ID" ]; then
  echo "Rest API ID expected. None found."
  exit 1
fi

if [ -z "$STAGE" ]; then
  STAGE='dev'
fi

aws apigateway create-deployment \
  --rest-api-id $REST_API_ID \
  --stage-name $STAGE \
  --profile $PROFILE

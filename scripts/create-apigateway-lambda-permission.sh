#!/bin/bash -e

PROFILE=default
ACCOUNT_ID=$1
REST_API_ID=$2
LAMBDA_NAME=$3
STAGE=$4

if [ -z "$ACCOUNT_ID" ]; then
  echo "AWS Account ID expected. None found."
  exit 1
fi

if [ -z "$REST_API_ID" ]; then
  echo "Rest API ID expected. None found."
  exit 1
fi

if [ -z "$LAMBDA_NAME" ]; then
  echo "LAMBDA Name expected. None found."
  exit 1
fi

if [ -z "$STAGE" ]; then
  STAGE='dev'
fi

FUNCTION_NAME="$LAMBDA_NAME-$STAGE"

aws lambda add-permission \
  --qualifier $STAGE \
  --function-name $FUNCTION_NAME \
  --statement-id apigateway-lambda-execute-star-$REST_API_ID \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn "arn:aws:execute-api:us-west-2:$ACCOUNT_ID:$REST_API_ID/*" \
  --profile $PROFILE

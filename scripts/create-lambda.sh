#!/bin/bash -e

PROFILE=default
ACCOUNT_ID=$1
LAMBDA_NAME=$2
ZIP_FILE=$3
HANDLER=$4
STAGE=$5

if [ -z "$ACCOUNT_ID" ]; then
  echo "AWS Account ID expected. None found."
  exit 1
fi

if [ -z "$LAMBDA_NAME" ]; then
  echo "Lambda name expected. None found."
  exit 1
fi

if [ -z "$ZIP_FILE" ]; then
  echo "Zip file expected. None found."
  exit 1
fi

if [ -z "$HANDLER" ]; then
  echo "HANDLER expected. None found."
  exit 1
fi

if [ -z "$STAGE" ]; then
  STAGE='dev'
fi

ROLE_ARN=arn:aws:iam::$ACCOUNT_ID:role/$LAMBDA_NAME-$STAGE

aws lambda create-function \
  --function-name $LAMBDA_NAME-$STAGE \
  --description "[$STAGE] $LAMBDA_NAME." \
  --zip-file fileb://$ZIP_FILE \
  --runtime java8 \
  --role $ROLE_ARN \
  --handler $HANDLER \
  --timeout 10 \
  --query "Version" \
  --publish \
  --memory-size 1536 \
  --profile $PROFILE

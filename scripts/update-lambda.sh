#!/bin/bash

PROFILE=default
LAMBDA_NAME=$1
ZIP_FILE=$2
STAGE=$3

if [ -z "$LAMBDA_NAME" ]; then
  echo "Lambda name expected. None found."
  exit 1
fi

if [ -z "$ZIP_FILE" ]; then
  echo "Zip file expected. None found."
  exit 1
fi

if [ -z "$STAGE" ]; then
  STAGE='dev'
fi

aws lambda update-function-code \
  --function-name $LAMBDA_NAME-$STAGE \
  --zip-file fileb://$ZIP_FILE \
  --publish \
  --profile $PROFILE

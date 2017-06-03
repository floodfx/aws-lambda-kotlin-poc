#!/bin/bash -e

PROFILE=default
LAMBDA_NAME=$1
VERSION=$2
STAGE=$3

if [ -z "$LAMBDA_NAME" ]; then
  echo "Lambda name expected. None found."
  exit 1
fi

if [ -z "$VERSION" ]; then
  echo "Version expected. None found."
  exit 1
fi

if [ -z "$STAGE" ]; then
  STAGE='dev'
fi


aws lambda create-alias \
  --function-name $LAMBDA_NAME-$STAGE \
  --name $STAGE \
  --function-version $VERSION \
  --profile $PROFILE

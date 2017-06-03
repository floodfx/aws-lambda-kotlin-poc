#!/bin/bash -e

PROFILE=default
ACCOUNT_ID=$1
LAMBDA_NAME=$2
DESCRIPTION=$3
GATEWAY_PATH=$4
VERSION=$5
SWAGGER_TEMPLATE_FILE=$6
STAGE=$7

if [ -z "$ACCOUNT_ID" ]; then
  echo "AWS Account ID expected. None found."
  exit 1
fi

if [ -z "$LAMBDA_NAME" ]; then
  echo "Lambda name expected. None found."
  exit 1
fi

if [ -z "$DESCRIPTION" ]; then
  echo "Description expected. None found."
  exit 1
fi

if [ -z "$GATEWAY_PATH" ]; then
  echo "Path expected. None found."
  exit 1
fi

if [ -z "$VERSION" ]; then
  echo "Version expected. None found."
  exit 1
fi

if [ -z "$SWAGGER_TEMPLATE_FILE" ]; then
  echo "Swagger file expected. None found."
  exit 1
fi

if [ -z "$STAGE" ]; then
  STAGE='dev'
fi

FUNCTION_NAME=$LAMBDA_NAME-$STAGE

TMP=`mktemp`
# replace LAMBDA_NAME in SWAGGER_TEMPLATE
sed "s/ACCOUNT_ID/${ACCOUNT_ID}/g;s/VERSION/${VERSION}/g;s/PATH/${GATEWAY_PATH}/g;s/LAMBDA_NAME/${FUNCTION_NAME}/g;s/LAMBDA_NAME/${FUNCTION_NAME}/g;s/STAGE/${STAGE}/g;" $SWAGGER_TEMPLATE_FILE > $TMP


aws apigateway import-rest-api \
  --body "file://$TMP" \
  --fail-on-warnings \
  --query 'id' \
  --profile $PROFILE

#!/bin/bash

PROFILE=default
LAMBDA_NAME="kotlin-lambda-poc2"
HANDLER="com.floodfx.kotlin.lambda.App::handleRequest"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_DIR=$SCRIPT_DIR/../../scripts
ZIP_PATH="$SCRIPT_DIR/../build/distributions/kotlin-lambda-poc.zip"

STAGE=$1
if [ -z "$STAGE" ]; then
  STAGE='dev'
fi

$SCRIPT_DIR/../gradlew build

aws lambda update-function-configuration \
  --function $LAMBDA_NAME-$STAGE \
  --handler $HANDLER \
  --environment "Variables={STAGE=$STAGE}" \
  --profile $PROFILE

$SCRIPT_DIR/update-lambda.sh $LAMBDA_NAME $ZIP_PATH $STAGE

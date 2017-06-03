#!/bin/bash -e

LAMBDA_NAME="kotlin-lambda-poc"
DESCRIPTION="Kotlin Proof of Concept"
GATEWAY_PATH="kotlin-lambda-poc"
HANDLER="com.floodfx.kotlin.lambda.App::handleRequest"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ZIP_PATH="$SCRIPT_DIR/../../build/distributions/$LAMBDA_NAME.zip"
SCRIPT_DIR=$SCRIPT_DIR/../../scripts

ACCOUNT_ID=$1
if [ -z "$ACCOUNT_ID" ]; then
  echo "Please provide your AWS Account ID"
  exit 1
fi

STAGE=$2
if [ -z "$STAGE" ]; then
STAGE='dev'
fi
VERSION=$STAGE

# create iam role
$SCRIPT_DIR/create-iam-role.sh $LAMBDA_NAME $STAGE

# build
cd $SCRIPT_DIR/..
gradle build

# create lambda function
FUNCTION_VERSION=$($SCRIPT_DIR/create-lambda.sh $ACCOUNT_ID $LAMBDA_NAME $ZIP_PATH $HANDLER $STAGE)
FUNCTION_VERSION=$(sed -e 's/^"//' -e 's/"$//' <<< $FUNCTION_VERSION)

# create lambda alias
$SCRIPT_DIR/create-lambda-alias.sh $LAMBDA_NAME $FUNCTION_VERSION $STAGE

# create api gateway
REST_API_ID=$($SCRIPT_DIR/create-apigateway.sh $ACCOUNT_ID $LAMBDA_NAME "$DESCRIPTION" $GATEWAY_PATH $VERSION $SCRIPT_DIR/templates/swagger-template.json $STAGE)
REST_API_ID=$(sed -e 's/^"//' -e 's/"$//' <<< $REST_API_ID)

# deploy api gateway stage
$SCRIPT_DIR/create-apigateway-stage.sh $REST_API_ID $STAGE

# create api gateway permission to call lambda
$SCRIPT_DIR/create-apigateway-lambda-permission.sh $ACCOUNT_ID $REST_API_ID $LAMBDA_NAME $STAGE

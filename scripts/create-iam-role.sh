#!/bin/bash -e

PROFILE=default
ROLE_NAME=$1
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROLE_POLICY_DOC=$SCRIPT_DIR/templates/role-policy-template.json

STAGE=$2
if [ -z "$STAGE" ]; then
  STAGE='dev'
fi

aws iam create-role \
  --role-name "$ROLE_NAME-$STAGE" \
  --assume-role-policy-document file://$ROLE_POLICY_DOC \
  --profile $PROFILE

aws iam attach-role-policy \
  --role-name "$ROLE_NAME-$STAGE" \
  --policy-arn "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" \
  --profile $PROFILE

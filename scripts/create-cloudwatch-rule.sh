#!/bin/bash -e

PROFILE=default
LAMBDA_NAME=$1
CRON=$2

if [ -z "$LAMBDA_NAME" ]; then
  echo "LAMBDA_NAME expected. None found."
  exit 1
fi

if [ -z "$CRON" ]; then
  echo "CRON expected. None found."
  exit 1
fi


STAGE=$3

if [ -z "$STAGE" ]; then
  STAGE='dev'
fi

RULE_NAME="ping-lambda-function-rule-for-$LAMBDA_NAME-$STAGE"

# create rule
RULE_ARN=$(aws events put-rule \
  --name $RULE_NAME \
  --description "[$STAGE] Rule to call Lambda function ($LAMBDA_NAME-$STAGE)" \
  --schedule-expression "$CRON" \
  --state ENABLED \
  --query "RuleArn" \
  --profile $PROFILE)
# remove quotes
RULE_ARN=$(sed -e 's/^"//' -e 's/"$//' <<< $RULE_ARN)

# add permission to lambda
aws lambda add-permission \
  --function-name $LAMBDA_NAME-$STAGE \
  --statement-id $RULE_NAME \
  --action 'lambda:InvokeFunction' \
  --principal events.amazonaws.com \
  --source-arn $RULE_ARN \
  --profile $PROFILE

# get lambda function arn
LAMBDA_ARN=$(aws lambda get-function \
  --function-name $LAMBDA_NAME-$STAGE \
  --query "Configuration.FunctionArn" \
  --profile $PROFILE
)

# remove quotes
LAMBDA_ARN=$(sed -e 's/^"//' -e 's/"$//' <<< $LAMBDA_ARN)

# add event target
aws events put-targets \
  --rule $RULE_NAME \
  --targets "Id=1,Arn=$LAMBDA_ARN" \
  --profile $PROFILE

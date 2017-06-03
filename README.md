# AWS API Gateway + Kotlin-based AWS Lambda Proxy

## Summary
This is a proof of concept project that shows a [Kotlin](http://kotlinlang.org/)-based Lambda function that is invoked via API Gateway.  We are using a [Proxy Resource](http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-set-up-simple-proxy.html) on API Gateway that sends any HTTP request to the Kotlin-based Lambda function.  The Kotlin Lambda functions uses [POJO Request Handlers](http://docs.aws.amazon.com/lambda/latest/dg/java-handler-io-type-pojo.html) to automatically serialize/deserialize [Kotlin data classes](https://kotlinlang.org/docs/reference/data-classes.html) from/to JSON.

## Building
 1. Checkout this repo `git clone git@github.com:floodfx/aws-lambda-kotlin-poc.git`
 2. [Install Gradle](https://gradle.org/install)
 3. Build the project `./gradlew build`
 
## Deploy
**Note**: the deploy scrips utilize the [AWS Command Line Interface Tools](https://aws.amazon.com/cli/) installed and configured with a `default` profile.  Also, we default to the **US-West-2** AWS Region.  

### Create AWS Resouces
There are two steps for deploying the project.  The first step is creating the AWS resources using the `create.sh` script.
To create the AWS resources run:

 * `chmod +x deploy/app/*.sh`(Make the Deploy scripts executable)
 * `chmod +x scripts/*.sh` (Make the AWS scripts executable)
 
Now you can run:

`./deploy/app/create.sh YOUR_AWS_ACCOUNT_ID`

This will do the following:
 1. Create a IAM Role named `kotlin-lambda-poc-dev` in your AWS Account that has the `AWSLambdaBasicExecutionRole` pre-built Policy attached.
 2. Create a Lambda Function named `kotlin-lambda-poc-dev` using the zip file you built above
 3. Create a Lambda Alias named `dev` that points at version 1 of the Lambda function
 4. Create a API Gateway API named `kotlin-lambda-poc-dev`
 5. Create an API Gateway API Stage named `dev`
 6. Create a Lambda Permission to allow API Gateway to Invoke your Lambda Function
 
### Update AWS Resources
Once you've created the resources, you can change the code and deploy those changes to the existing resources.  Basically, you just upload a new zip and change the alias of the Lambda function like so:

`./deploy/app/update.sh`

This will do the following:
 1. Rebuild your project (it runs `./gradlew build` for you)
 2. Deploys a new Lambda Function
 
You haven't replaced the existing version yet which is alias at the `dev` label.  To do so you run:

`./scrips/update-lambda-alias.sh kotlin-lambda-poc 2`

**Note**: The `2` here is the latest version.  So more generally you'd run:

`./scrips/update-lambda-alias.sh kotlin-lambda-poc VERSION`

## Making Requests to the Kotlin Lambda Function via API Gateway
You should determine your API Gateway API domain by logging into the console or figuring our your API ID. 

```aws apigateway get-rest-apis --query 'items[?name==`kotlin-lambda-poc-dev`]'```

Which should return something like:

```
[
    {
        "createdDate": 1495990917, 
        "id": "abc1234567", 
        "version": "dev", 
        "name": "kotlin-lambda-poc-dev"
    }
]
```
Then you can test the request at using your ID.  The domain is in the format of:

https://APIID.execute-api.us-west-2.amazonaws.com/dev/kotlin-lambda-poc/PROXY 
 
So your domain would be something like: 
 
https://abc1234567.execute-api.us-west-2.amazonaws.com/dev/kotlin-lambda-poc/anything


## Feedback
Would love any thoughts, feedback, pull-requests, or other comments.  Thanks!

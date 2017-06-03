package com.amazonaws.services.lambda.runtime

data class LambdaProxyEvent(
    var resource: String? = null,    
    var path: String? = null,    
    var httpMethod: String? = null,       
    var headers: Map<String,String>? = null,    
    var queryStringParameters: Map<String,String>? = null,    
    var pathParameters: Map<String,String>? = null,    
    var stageVariables: Map<String,String>? = null,    
    var requestContext: RequestContext? = null,    
    var body: String? = null,    
    var isBase64Encoded: Boolean = false
) {
  data class RequestContext(
          var accountId: String? = null,
          var resourceId: String? = null,
          var stage: String? = null,
          var requestId: String? = null,
          var identity: Identity? = null,
          var resourcePath: String? = null,
          var httpMethod: String? = null,
          var apiId: String? = null
  )
  
  data class Identity(
           var cognitoIdentityPoolId: String? = null,        
           var accountId: String? = null,        
           var cognitoIdentityId: String? = null,        
           var caller: String? = null,        
           var apiKey: String? = null,        
           var sourceIp: String? = null,        
           var cognitoAuthenticationType: String? = null,    
           var cognitoAuthenticationProvider: String? = null,        
           var userArn: String? = null,       
           var userAgent: String? = null,        
           var user: String? = null
  )
}
package com.floodfx.kotlin.lambda;

import com.amazonaws.services.lambda.runtime.LambdaProxyEvent
import com.amazonaws.services.lambda.runtime.Context
import com.amazonaws.services.lambda.runtime.LambdaProxyOutput
import com.amazonaws.services.lambda.runtime.RequestHandler

class App : RequestHandler<LambdaProxyEvent, LambdaProxyOutput> {
  
  override fun handleRequest(event: LambdaProxyEvent, context: Context): LambdaProxyOutput {
    println("Event: $event \nContext $context")
    return LambdaProxyOutput(body = "Hello Kotlin")
  }
  
}
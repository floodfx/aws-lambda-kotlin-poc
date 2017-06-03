package com.amazonaws.services.lambda.runtime

data class LambdaProxyOutput(
        var statusCode: Int = 200,
        var headers: Map<String, String> = hashMapOf(),
        var body: String = ""
)
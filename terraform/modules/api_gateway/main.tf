# WebSocket API Gateway for Real-time Data Collection
# This handles incoming browser analytics data from user extensions via websocket connections
resource "aws_apigatewayv2_api" "websocket" {
  name                       = "${var.project_name}-${var.environment}-websocket"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"  # route based on the 'action' field in the message
  
  tags = var.tags
}

# websocket stage for production traffic
resource "aws_apigatewayv2_stage" "websocket_prod" {
  api_id = aws_apigatewayv2_api.websocket.id
  name   = "prod"
  
  default_route_settings {
    throttling_burst_limit = 5000  # allow bursts up to 5k requests
    throttling_rate_limit  = 2000  # steady state limit of 2k requests per second
  }
  
  tags = var.tags
}

# Lambda Integrations for WebSocket Routes
# These connect websocket events to lambda functions that handle the actual processing

# handles new websocket connections and validates jwt tokens
resource "aws_apigatewayv2_integration" "connect" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.authorizer_lambda_arn
  
  integration_method = "POST"  # lambda integrations always use post
}

# handles websocket disconnections and cleanup
resource "aws_apigatewayv2_integration" "disconnect" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.cleanup_lambda_arn
  
  integration_method = "POST"
}

# handles actual data messages and pushes them to kinesis
resource "aws_apigatewayv2_integration" "senddata" {
  api_id           = aws_apigatewayv2_api.websocket.id
  integration_type = "AWS_PROXY"
  integration_uri  = var.kinesis_producer_lambda_arn
  
  integration_method = "POST"
}

# WebSocket Routes
# these define which lambda function handles each type of websocket message

# $connect is a special route that fires when a websocket connection is established
resource "aws_apigatewayv2_route" "connect" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "$connect"    # built-in route for connections
  target    = "integrations/${aws_apigatewayv2_integration.connect.id}"
}

# $disconnect fires when the websocket connection is closed
resource "aws_apigatewayv2_route" "disconnect" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "$disconnect" # built-in route for disconnections
  target    = "integrations/${aws_apigatewayv2_integration.disconnect.id}"
}

# custom route for when browser sends data with action: "sendData"
resource "aws_apigatewayv2_route" "senddata" {
  api_id    = aws_apigatewayv2_api.websocket.id
  route_key = "sendData"    # matches the action field in json messages
  target    = "integrations/${aws_apigatewayv2_integration.senddata.id}"
}

# Lambda Permissions for WebSocket API
# api gateway needs permission to invoke our lambda functions

# permission for api gateway to call the authorizer lambda
resource "aws_lambda_permission" "websocket_connect" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.authorizer_lambda_function_name
  principal     = "apigateway.amazonaws.com"                  # only api gateway can invoke
  source_arn    = "${aws_apigatewayv2_api.websocket.execution_arn}/*/*"  # from our specific api
}

# permission for api gateway to call the cleanup lambda
resource "aws_lambda_permission" "websocket_disconnect" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.cleanup_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket.execution_arn}/*/*"
}

# permission for api gateway to call the data processing lambda
resource "aws_lambda_permission" "websocket_senddata" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.kinesis_producer_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.websocket.execution_arn}/*/*"
}

# REST API Gateway for Ad Recommendations 
# This handles requests from advertisers who want targeting recommendations for users
resource "aws_api_gateway_rest_api" "recommendations" {
  name        = "${var.project_name}-${var.environment}-recommendations"
  description = "Browser Analytics Recommendations API"
  
  endpoint_configuration {
    types = ["REGIONAL"]  # regional endpoint is cheaper and faster than edge
  }
  
  tags = var.tags
}

# API Gateway Resources for REST endpoints
# creates the url structure: /recommendations/{user_id}

resource "aws_api_gateway_resource" "recommendations" {
  rest_api_id = aws_api_gateway_rest_api.recommendations.id
  parent_id   = aws_api_gateway_rest_api.recommendations.root_resource_id
  path_part   = "recommendations"  # this creates /recommendations
}

resource "aws_api_gateway_resource" "user_recommendations" {
  rest_api_id = aws_api_gateway_rest_api.recommendations.id
  parent_id   = aws_api_gateway_resource.recommendations.id
  path_part   = "{user_id}"       # this creates /recommendations/{user_id}
}

# API Gateway Method
resource "aws_api_gateway_method" "get_recommendations" {
  rest_api_id   = aws_api_gateway_rest_api.recommendations.id
  resource_id   = aws_api_gateway_resource.user_recommendations.id
  http_method   = "GET"
  authorization = "AWS_IAM"
  
  request_parameters = {
    "method.request.path.user_id" = true
  }
}

# API Gateway Integration
resource "aws_api_gateway_integration" "recommendations_lambda" {
  rest_api_id = aws_api_gateway_rest_api.recommendations.id
  resource_id = aws_api_gateway_resource.user_recommendations.id
  http_method = aws_api_gateway_method.get_recommendations.http_method
  
  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = var.recommendations_lambda_arn
  
  request_templates = {
    "application/json" = jsonencode({
      user_id = "$input.params('user_id')"
    })
  }
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "recommendations" {
  depends_on = [
    aws_api_gateway_integration.recommendations_lambda
  ]
  
  rest_api_id = aws_api_gateway_rest_api.recommendations.id
  stage_name  = "prod"
}

# API Gateway Stage
resource "aws_api_gateway_stage" "recommendations_prod" {
  deployment_id = aws_api_gateway_deployment.recommendations.id
  rest_api_id   = aws_api_gateway_rest_api.recommendations.id
  stage_name    = "prod"
  
  cache_cluster_enabled = true
  cache_cluster_size    = "0.5"
  
  tags = var.tags
}

# Method settings for caching
resource "aws_api_gateway_method_settings" "recommendations" {
  rest_api_id = aws_api_gateway_rest_api.recommendations.id
  stage_name  = aws_api_gateway_stage.recommendations_prod.stage_name
  method_path = "*/*"
  
  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    
    caching_enabled      = true
    cache_ttl_in_seconds = 300
    cache_key_parameters = ["method.request.path.user_id"]
    
    throttling_burst_limit = 10000
    throttling_rate_limit  = 5000
  }
}

# Lambda permission for REST API
resource "aws_lambda_permission" "rest_api_recommendations" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.recommendations_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.recommendations.execution_arn}/*/*"
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "websocket_api" {
  name              = "/aws/apigateway/${aws_apigatewayv2_api.websocket.name}"
  retention_in_days = 7
  
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "rest_api" {
  name              = "/aws/apigateway/${aws_api_gateway_rest_api.recommendations.name}"
  retention_in_days = 7
  
  tags = var.tags
}
output "websocket_api_id" {
  description = "WebSocket API Gateway ID"
  value       = aws_apigatewayv2_api.websocket.id
}

output "websocket_api_endpoint" {
  description = "WebSocket API Gateway endpoint"
  value       = aws_apigatewayv2_api.websocket.api_endpoint
}

output "websocket_stage_invoke_url" {
  description = "WebSocket stage invoke URL"
  value       = aws_apigatewayv2_stage.websocket_prod.invoke_url
}

output "rest_api_id" {
  description = "REST API Gateway ID"
  value       = aws_api_gateway_rest_api.recommendations.id
}

output "rest_api_endpoint" {
  description = "REST API Gateway endpoint"
  value       = aws_api_gateway_rest_api.recommendations.execution_arn
}

output "rest_api_invoke_url" {
  description = "REST API stage invoke URL"
  value       = aws_api_gateway_stage.recommendations_prod.invoke_url
}
resource "aws_api_gateway_resource" "writeLambda_rest_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "write_user"
}

resource "aws_api_gateway_method" "writeLambda_rest_api_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.writeLambda_rest_api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "writeLambda_rest_api_get_method_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.writeLambda_rest_api_resource.id
  http_method             = aws_api_gateway_method.writeLambda_rest_api_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.writeLambda_function_arn
}

resource "aws_api_gateway_method_response" "writeLambda_rest_api_get_method_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.writeLambda_rest_api_resource.id
  http_method = aws_api_gateway_method.writeLambda_rest_api_get_method.http_method
  status_code = "200"
}


//  Creating a lambda resource based policy to allow API gateway to invoke the lambda function:
resource "aws_lambda_permission" "writeLambda_api_gateway_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.writeLambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

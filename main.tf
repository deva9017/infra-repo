locals {
  environment = terraform.workspace 
}
/*
resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code-bucket19-${local.environment}"
}
*/
resource "aws_lambda_function" "app_lambda" {
  function_name = "my-app-lambda-${local.environment}"
  s3_bucket     = "lambda-code-bucket19-${local.environment}"
  s3_key        = "lambda_function.zip"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_role.arn
}


module "auth" {
  source      = "./modules/auth"
  environment = local.environment
}


resource "aws_apigatewayv2_api" "http_api" {
  name          = "hello-world-api"
  protocol_type = "HTTP"
}
# API Gateway Route
resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
# API Gateway Stage
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

# Lambda Permission to API Gateway
resource "aws_lambda_permission" "apigw_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

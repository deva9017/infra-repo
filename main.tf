locals {
  environment = terraform.workspace
}

resource "aws_lambda_function" "app_lambda" {
  function_name    = "hello-world-lambda-${var.environment}"
  s3_bucket       = "lambda-code-bucket19-${var.environment}"
  s3_key          = "lambda_function.zip"
  
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs18.x"
 }

resource "aws_api_gateway_rest_api" "app_api" {
  name        = "app-api-${local.environment}"
  description = "API Gateway for Lambda app"
}

module "auth" {
  source      = "./modules/auth"
  environment = local.environment
}

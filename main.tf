locals {
  environment = terraform.workspace
}

resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code-bucket19-${local.environment}"
}

resource "aws_lambda_function" "app_lambda" {
  function_name = "my-app-lambda-${local.environment}"
  s3_bucket     = aws_s3_bucket.lambda_code.bucket
  s3_key        = "lambda.zip"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_role.arn
}

resource "aws_api_gateway_rest_api" "app_api" {
  name        = "app-api-${local.environment}"
  description = "API Gateway for Lambda app"
}

module "auth" {
  source      = "./modules/auth"
  environment = local.environment
}


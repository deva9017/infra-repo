locals {
  environment = terraform.workspace
}

resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code-bucket19-${local.environment}"
}

resource "aws_lambda_function" "app_lambda" {
  function_name    = "hello-world-lambda-${var.environment}"
  s3_bucket       = "lambda-code-bucket19-${var.environment}"
  s3_key          = "lambda_function.zip"
  s3_object_version = null # Ensure latest version is used (optional)
  role            = aws_iam_role.lambda_role.arn
  handler         = "index.handler"
  runtime         = "nodejs18.x"
  source_code_hash = filebase64sha256("lambda_function.zip")

  depends_on = [aws_s3_object.lambda_zip]
}

resource "aws_api_gateway_rest_api" "app_api" {
  name        = "app-api-${local.environment}"
  description = "API Gateway for Lambda app"
}

module "auth" {
  source      = "./modules/auth"
  environment = local.environment
}

locals {
  environment = terraform.workspace
}

resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code-bucket-${local.environment}"
}

resource "aws_lambda_function" "app_lambda" {
  function_name    = "hello-world-lambda-${terraform.workspace}"
  role            = aws_iam_role.lambda_role.arn
  runtime         = "nodejs18.x"
  handler         = "index.handler"

  s3_bucket       = aws_s3_bucket.lambda_code.bucket
  s3_key          = aws_s3_object.lambda_zip.key  

  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      ENV = terraform.workspace
    }
  }
}


resource "aws_api_gateway_rest_api" "app_api" {
  name        = "app-api-${local.environment}"
  description = "API Gateway for Lambda app"
}

module "auth" {
  source      = "./modules/auth"
  environment = local.environment
}

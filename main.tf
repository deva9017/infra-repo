locals {
  environment = terraform.workspace
}

resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code-bucket19-${local.environment}"
}

resource "aws_lambda_function" "app_lambda" {
  function_name    = "hello-world-lambda-${terraform.workspace}"
  role            = aws_iam_role.lambda_role.arn
  runtime         = "nodejs18.x"
  handler         = "index.handler"
  

  s3_bucket       = data.aws_s3_bucket.lambda_code_bucket.id
  s3_key          = aws_s3_object.lambda_zip.key  

  source_code_hash = null_resource.trigger.id # Force redeployment

  environment {
    variables = {
      ENV = terraform.workspace
    }
  }
}

resource "null_resource" "trigger" {
  triggers = {
    redeploy = timestamp()
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

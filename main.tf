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

module "auth" {
  source      = "./modules/auth"
  environment = local.environment
}

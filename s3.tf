/*
resource "aws_s3_bucket" "lambda_code" {
  bucket = "lambda-code-bucket19-${terraform.workspace}"
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_code.bucket
  key    = "lambda_function.zip"
  source = "/dev/null"  # Placeholder since app repo uploads it
}

*/

data "aws_s3_bucket" "lambda_code_bucket" {
  bucket = "lambda-code-bucket19-prod"  # Replace with your actual bucket name
}

resource "aws_s3_object" "lambda_zip" {
  bucket = data.aws_s3_bucket.lambda_code_bucket.id
  key    = "lambda_function.zip"
  source = "lambda_function.zip"
  
}

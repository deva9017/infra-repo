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

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "lambda-code-bucket19-${var.environment}"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = "lambda_function.zip"
  etag   = filemd5("lambda_function.zip")
}


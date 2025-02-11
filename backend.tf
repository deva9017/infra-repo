terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket986"
    key            = "testinfra/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

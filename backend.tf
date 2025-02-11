terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket986"
    key            = "infra/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

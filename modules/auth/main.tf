resource "aws_cognito_user_pool" "app_user_pool" {
  name = "app-user-pool-${var.environment}"
}

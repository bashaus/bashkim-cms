/* db_password */

resource "aws_secretsmanager_secret" "db_password" {
  name = "bashkim-cms-${var.app_env}-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

/* strapi_app_keys */

resource "aws_secretsmanager_secret" "strapi_app_keys" {
  name = "bashkim-cms-${var.app_env}-strapi-app-keys"
}

resource "aws_secretsmanager_secret_version" "strapi_app_keys" {
  secret_id     = aws_secretsmanager_secret.strapi_app_keys.id
  secret_string = var.strapi_app_keys
}

/* strapi_api_token_salt */

resource "aws_secretsmanager_secret" "strapi_api_token_salt" {
  name = "bashkim-cms-${var.app_env}-strapi-api-token-salt"
}

resource "aws_secretsmanager_secret_version" "strapi_api_token_salt" {
  secret_id     = aws_secretsmanager_secret.strapi_api_token_salt.id
  secret_string = var.strapi_api_token_salt
}

/* strapi_admin_jwt_secret */

resource "aws_secretsmanager_secret" "strapi_admin_jwt_secret" {
  name = "bashkim-cms-${var.app_env}-strapi-admin-jwt-secret"
}

resource "aws_secretsmanager_secret_version" "strapi_admin_jwt_secret" {
  secret_id     = aws_secretsmanager_secret.strapi_admin_jwt_secret.id
  secret_string = var.strapi_admin_jwt_secret
}

/* strapi_transfer_token_salt */

resource "aws_secretsmanager_secret" "strapi_transfer_token_salt" {
  name = "bashkim-cms-${var.app_env}-strapi-transfer-token-salt"
}

resource "aws_secretsmanager_secret_version" "strapi_transfer_token_salt" {
  secret_id     = aws_secretsmanager_secret.strapi_transfer_token_salt.id
  secret_string = var.strapi_transfer_token_salt
}

/* strapi_jwt_secret */

resource "aws_secretsmanager_secret" "strapi_jwt_secret" {
  name = "bashkim-cms-${var.app_env}-strapi-jwt-secret"
}

resource "aws_secretsmanager_secret_version" "strapi_jwt_secret" {
  secret_id     = aws_secretsmanager_secret.strapi_jwt_secret.id
  secret_string = var.strapi_jwt_secret
}

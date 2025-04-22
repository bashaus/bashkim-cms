/* amazon web services */

variable "aws_region" {
  type        = string
  description = "AWS Region where the provider will operate"
  default     = "eu-west-1"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  sensitive   = true
  description = "AWS secret key"
}

/* application */

variable "app_env" {
  type        = string
  description = "Application environment (e.g.: production, demo)"
  default     = "production"
}

/* database */

variable "db_name" {
  type    = string
  default = "strapi"
}

variable "db_username" {
  type    = string
  default = "strapi"
}

variable "db_password" {
  type      = string
  sensitive = true
}

/* strapi */

variable "strapi_app_keys" {
  type      = string
  sensitive = true
}

variable "strapi_api_token_salt" {
  type      = string
  sensitive = true
}

variable "strapi_admin_jwt_secret" {
  type      = string
  sensitive = true
}

variable "strapi_transfer_token_salt" {
  type      = string
  sensitive = true
}

variable "strapi_jwt_secret" {
  type      = string
  sensitive = true
}

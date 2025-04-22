resource "aws_apprunner_service" "bashkim_cms" {
  service_name = "bashkim-cms-${var.app_env}-strapi"

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.bashkim_cms.arn

  source_configuration {
    auto_deployments_enabled = true

    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner.arn
    }

    image_repository {
      image_repository_type = "ECR"
      image_identifier      = "${aws_ecr_repository.bashkim_cms.repository_url}:latest"

      image_configuration {
        port = "1337"

        runtime_environment_variables = {
          DATABASE_HOST     = aws_rds_cluster.bashkim_cms.endpoint
          DATABASE_PORT     = 5432
          DATABASE_NAME     = var.db_name
          DATABASE_USERNAME = var.db_username

          S3_ASSETS_BUCKET = aws_s3_bucket.s3_assets.bucket
        }

        runtime_environment_secrets = {
          DATABASE_PASSWORD = aws_secretsmanager_secret.db_password.arn

          APP_KEYS            = aws_secretsmanager_secret.strapi_app_keys.arn
          API_TOKEN_SALT      = aws_secretsmanager_secret.strapi_api_token_salt.arn
          ADMIN_JWT_SECRET    = aws_secretsmanager_secret.strapi_admin_jwt_secret.arn
          TRANSFER_TOKEN_SALT = aws_secretsmanager_secret.strapi_transfer_token_salt.arn
          JWT_SECRET          = aws_secretsmanager_secret.strapi_jwt_secret.arn
        }
      }
    }
  }

  instance_configuration {
    cpu    = "512"  # 1024 for 1 vCPU
    memory = "1024" # 2048 for 2GB

    instance_role_arn = aws_iam_role.apprunner.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.bashkim_cms.arn
    }
  }

  observability_configuration {
    observability_enabled           = true
    observability_configuration_arn = aws_apprunner_observability_configuration.bashkim_cms.arn
  }
}

resource "aws_apprunner_custom_domain_association" "bashkim_cms" {
  domain_name = "cms.bashkim.com"
  service_arn = aws_apprunner_service.bashkim_cms.arn
}

resource "aws_apprunner_observability_configuration" "bashkim_cms" {
  observability_configuration_name = "bashkim-cms-${var.app_env}-otel"

  trace_configuration {
    vendor = "AWSXRAY"
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "bashkim_cms" {
  auto_scaling_configuration_name = "bashkim-cms-${var.app_env}-autoscale"

  max_concurrency = 100
  min_size        = 1
  max_size        = 1
}

resource "aws_apprunner_vpc_connector" "bashkim_cms" {
  vpc_connector_name = "bashkim-cms-${var.app_env}-vpc-connector"

  subnets         = aws_subnet.bashkim_cms[*].id
  security_groups = [aws_security_group.apprunner.id]
}

resource "aws_ecr_repository" "bashkim_cms" {
  name = "bashkim-cms-${var.app_env}-ecr"

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_ecr_repository_policy" "bashkim_cms" {
  repository = aws_ecr_repository.bashkim_cms.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.apprunner.arn
        },
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "bashkim_cms" {
  repository = aws_ecr_repository.bashkim_cms.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Delete old untagged images"

        selection = {
          tagStatus   = "untagged"
          countType   = "imageCountMoreThan"
          countNumber = 12
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}

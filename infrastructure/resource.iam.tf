resource "aws_iam_role" "apprunner" {
  name = "bashkim-cms-${var.app_env}-iam-apprunner"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "apprunner_ssm" {
  name = "bashkim-cms-${var.app_env}-iam-policy-apprunner-ssm"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ssm:GetParameters"
        Resource = "arn:aws:ssm:eu-west-1:${data.aws_caller_identity.current.account_id}:parameter/*"
      },
      {
        Effect = "Allow"
        Action = "secretsmanager:GetSecretValue"
        Resource = [
          "arn:aws:secretsmanager:eu-west-1:${data.aws_caller_identity.current.account_id}:secret:bashkim-cms-${var.app_env}-*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "apprunner_ec2" {
  name = "bashkim-cms-${var.app_env}-iam-policy-apprunner-ec2"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow"
        "Resource" : "*"
        "Action" : [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
      }
    ]
  })
}

resource "aws_iam_policy" "apprunner_ecr" {
  name = "bashkim-cms-${var.app_env}-iam-policy-apprunner-ecr"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ],
        Resource = [
          "${aws_ecr_repository.bashkim_cms.arn}",
          "${aws_ecr_repository.bashkim_cms.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "rds-data:*",
          "rds:*"
        ]
        Resource = aws_rds_cluster.bashkim_cms.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr" {
  policy_arn = aws_iam_policy.apprunner_ecr.arn
  role       = aws_iam_role.apprunner.name
}

resource "aws_iam_role_policy_attachment" "apprunner_ssm" {
  policy_arn = aws_iam_policy.apprunner_ssm.arn
  role       = aws_iam_role.apprunner.name
}

resource "aws_iam_role_policy_attachment" "apprunner_ec2" {
  policy_arn = aws_iam_policy.apprunner_ec2.arn
  role       = aws_iam_role.apprunner.name
}

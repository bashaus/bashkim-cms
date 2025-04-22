resource "aws_s3_bucket" "s3_assets" {
  bucket = "bashkim-cms-${var.app_env}-assets"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_cors_configuration" "s3_assets" {
  bucket = aws_s3_bucket.s3_assets.id

  cors_rule {
    max_age_seconds = 3000

    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = [
      "https://bashkim.com",
      "https://www.bashkim.com",
      "https://cms.bashkim.com"
    ]
  }

  depends_on = [
    aws_s3_bucket.s3_assets
  ]
}

data "aws_iam_policy_document" "s3_assets" {
  statement {
    effect = "Allow"
    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      aws_s3_bucket.s3_assets.arn,
      "${aws_s3_bucket.s3_assets.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_assets" {
  name   = "StrapiUserPolicy"
  policy = data.aws_iam_policy_document.s3_assets.json
}

resource "aws_iam_role_policy_attachment" "apprunner_s3" {
  role       = aws_iam_role.apprunner.name
  policy_arn = aws_iam_policy.s3_assets.arn
}

resource "aws_s3_bucket_policy" "apprunner" {
  bucket = aws_s3_bucket.s3_assets.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.apprunner.arn
        },

        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],

        Resource = "${aws_s3_bucket.s3_assets.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_ownership_controls" "s3_assets" {
  bucket = aws_s3_bucket.s3_assets.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_assets" {
  bucket = aws_s3_bucket.s3_assets.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_assets" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_assets,
    aws_s3_bucket_public_access_block.s3_assets,
  ]

  bucket = aws_s3_bucket.s3_assets.id
  acl    = "public-read"
}

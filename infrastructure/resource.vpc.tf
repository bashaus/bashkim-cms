resource "aws_security_group" "apprunner" {
  name   = "bashkim-cms-${var.app_env}-sg-apprunner"
  vpc_id = aws_vpc.bashkim_cms.id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "aurora" {
  name        = "bashkim-cms-${var.app_env}-sg-aurora"
  description = "Restrict access to Aurora from App Runner"
  vpc_id      = aws_vpc.bashkim_cms.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.apprunner.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bashkim-cms-${var.app_env}-sg-aurora"
  }
}

resource "aws_vpc" "bashkim_cms" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "bashkim-cms-${var.app_env}-vpc"
  }
}

resource "aws_subnet" "bashkim_cms" {
  count             = 2
  vpc_id            = aws_vpc.bashkim_cms.id
  cidr_block        = cidrsubnet(aws_vpc.bashkim_cms.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "bashkim-cms-${var.app_env}-vpc-subnet"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = toset([
    "rds"
  ])

  vpc_id              = aws_vpc.bashkim_cms.id
  service_name        = "com.amazonaws.${var.aws_region}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.bashkim_cms[*].id
  security_group_ids  = [aws_security_group.apprunner.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.bashkim_cms.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.bashkim_cms.id]
}

resource "aws_route_table" "bashkim_cms" {
  vpc_id = aws_vpc.bashkim_cms.id
}


resource "aws_internet_gateway" "bashkim_cms" {
  vpc_id = aws_vpc.bashkim_cms.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.bashkim_cms.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bashkim_cms.id
}

resource "aws_route_table_association" "subnet" {
  count          = 2
  subnet_id      = aws_subnet.bashkim_cms[count.index].id
  route_table_id = aws_route_table.bashkim_cms.id
}

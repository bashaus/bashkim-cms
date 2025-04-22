resource "aws_db_subnet_group" "bashkim_cms" {
  name       = "bashkim-cms-${var.app_env}-aurora-subnet"
  subnet_ids = aws_subnet.bashkim_cms[*].id
}

resource "aws_rds_cluster_parameter_group" "bashkim_cms" {
  name   = "bashkim-cms-${var.app_env}-aurora-params"
  family = "aurora-postgresql16"

  parameter {
    apply_method = "pending-reboot"
    name         = "rds.force_ssl"
    value        = "0"
  }
}

resource "aws_rds_cluster" "bashkim_cms" {
  cluster_identifier = "bashkim-cms-${var.app_env}-aurora-cluster"
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned"
  engine_version     = "16.6"

  database_name   = var.db_name
  master_username = var.db_username
  master_password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.bashkim_cms.name
  vpc_security_group_ids = [aws_security_group.aurora.id]
  skip_final_snapshot    = true
  storage_encrypted      = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.bashkim_cms.name

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 1
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_rds_cluster_instance" "bashkim_cms" {
  identifier          = "bashkim-cms-${var.app_env}-aurora-instance"
  cluster_identifier  = aws_rds_cluster.bashkim_cms.id
  instance_class      = "db.serverless"
  engine              = aws_rds_cluster.bashkim_cms.engine
  engine_version      = aws_rds_cluster.bashkim_cms.engine_version
  publicly_accessible = false

  lifecycle {
    prevent_destroy = true
  }
}

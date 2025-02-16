resource "aws_db_subnet_group" "main" {
  name       = "${var.identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.identifier}-security-group"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "main" {
  identifier           = var.identifier
  allocated_storage    = var.allocated_storage
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "14"
  instance_class      = "db.t3.micro"
  db_name             = var.db_name
  username            = var.username
  password            = var.password
  skip_final_snapshot = true
  publicly_accessible = true

  # Disable Enhanced Monitoring (CloudWatch)
  monitoring_interval = 0
  enabled_cloudwatch_logs_exports = []

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = {
    Environment = var.environment
  }
} 
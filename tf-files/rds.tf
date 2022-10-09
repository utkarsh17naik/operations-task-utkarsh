resource "random_string" "rds-db-password" {
  length  = 32
  upper   = true
  lower   = true
  numeric = true
  special = false
}
resource "aws_security_group" "rds-sg" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.environment}-rds-sg"
  description = "Allow all inbound for Postgres"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  tags = {
    Name = "${var.app-name}-${var.environment}-subnet-grp"
  }
}
resource "aws_db_instance" "rds" {
  identifier             = "${var.environment}-rds-postgres"
  db_name                = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 50
  engine                 = "postgres"
  engine_version         = "13.5"
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  username               = "postgres"
  password               = random_string.rds-db-password.result
}

resource "aws_secretsmanager_secret" "rds-postgres-secret" {
  name = "${var.app-name}-${var.environment}-rds-secret"
}

resource "aws_secretsmanager_secret_version" "rds-postgres-secret" {
  secret_id = aws_secretsmanager_secret.rds-postgres-secret.id
  secret_string = jsonencode({
    "user" : "postgres",
    "password" : random_string.rds-db-password.result,
    "name" : "postgres",
    "host" : aws_db_instance.rds.endpoint
  })
}

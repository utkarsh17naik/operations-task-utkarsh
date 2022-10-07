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
resource "aws_db_instance" "rds" {
  identifier             = "${var.environment}-rds-postgres"
  db_name                = "postgres"
  instance_class         = "db.t2.micro"
  allocated_storage      = 50
  engine                 = "postgres"
  engine_version         = "13.5"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  username               = "postgres"
  password               = "random_string.rds-db-password.result"
}

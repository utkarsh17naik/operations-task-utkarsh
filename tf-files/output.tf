output "db-name" {
  value = aws_db_instance.rds.db_name
}

output "db-user" {
  value = aws_db_instance.rds.username
}

output "db-password" {
  value = aws_db_instance.rds.password
}

output "db-host" {
  value = aws_db_instance.rds.address
}

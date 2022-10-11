resource "aws_cloudwatch_log_group" "rates_log_group" {
  name              = "/ecs/rates-app"
  retention_in_days = 30

  tags = {
    Name = "rates-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "rates_log_stream" {
  name           = "rates-log-stream"
  log_group_name = aws_cloudwatch_log_group.rates_log_group.name
}

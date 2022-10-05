resource "aws_s3_bucket" "lb_logs" {
  bucket = var.s3-bucket

}
resource "aws_lb" "alb" {
  name               = "${var.environment}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "${var.environment}-lb"
    enabled = true
  }

  tags = {
    Environment = var.environment
  }
}

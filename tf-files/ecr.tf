resource "aws_ecr_repository" "app-ecr" {
  name                 = "${var.app-name}-ecr-${var.environment}"
  image_tag_mutability = "MUTABLE"
}

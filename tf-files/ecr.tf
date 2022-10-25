resource "aws_ecr_repository" "app-ecr" {
  name                 = "${var.app-name}-ecr-${var.environment}"
  image_tag_mutability = "MUTABLE"
}

resource "aws_secretsmanager_secret" "ecr-repo" {
  name = "${var.environment}-ecr-repo-secret"
}

resource "aws_secretsmanager_secret_version" "ecr-repo" {
  secret_id     = aws_secretsmanager_secret.ecr-repo.id
  secret_string = aws_ecr_repository.app-ecr.repository_url
}


resource "aws_codebuild_source_credential" "github" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = file("~/Downloads/git-token")
}



resource "aws_codebuild_project" "build" {
  name          = "${var.app-name}-${var.environment}-build"
  build_timeout = "60"
  service_role  = aws_iam_role.codebuild-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.lb_logs.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.lb_logs.id}/build-log"
    }
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/utkarsh17naik/operations-task-utkarsh.git"

    git_submodules_config {
      fetch_submodules = true
    }
  }

  source_version = "master"

  vpc_config {
    vpc_id             = aws_vpc.vpc.id
    security_group_ids = [aws_security_group.alb-sg.id]

    subnets = [for subnet in aws_subnet.private : subnet.id]

  }

  tags = {
    Environment = var.environment
  }
}

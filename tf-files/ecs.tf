#ECS Cluster
resource "aws_ecs_cluster" "app-ecs" {
  name = "${var.app-name}-cluster-${var.environment}"
}

#Task Definitions
resource "aws_ecs_task_definition" "ecs-td" {
  network_mode             = "awsvpc"
  family                   = "${var.app-name}-td-${var.environment}"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = <<DEFINITION
  [{
    "name" : "${var.app-name}-container-${var.environment}",
    "image" : "${aws_ecr_repository.app-ecr.name}:latest",
    "essential" : true,
    "portMappings" : [{
      "containerPort" : 80,
      "hostPort" : 80
    }]
    }
  ]
  DEFINITION
}


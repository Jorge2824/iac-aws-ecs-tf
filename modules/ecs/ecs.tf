resource "aws_ecs_cluster" "interseguros-cluster" {
  name = var.interseguros_cluster_name

  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

resource "aws_default_vpc" "default_vpc" {}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = var.availability_zones[0]
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = var.availability_zones[1]
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = var.availability_zones[2]
}

resource "aws_ecs_task_definition" "interseguros_fiber_task_definition" {
  family                   = var.fiber_task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = var.cpu_usage
  memory                   = var.memory_usage
  container_definitions    = jsonencode([
    {
        name            = var.fiber_go_api_name
        image           = var.fiber_go_image_url
        essential       = true
        portMappings    = [
            {
                containerPort   = var.go_listen_port
                hostPort        = var.go_listen_port
            }
        ]
    }
  ])
}

resource "aws_ecs_task_definition" "interseguros_express_task_definition" {
  family                   = var.express_task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = var.cpu_usage
  memory                   = var.memory_usage
  container_definitions    = jsonencode([
    {
        name            = var.express_node_api_name
        image           = var.express_node_image_url
        essential       = true
        portMappings    = [
            {
                containerPort   = var.node_listen_port
                hostPort        = var.node_listen_port
            }
        ]
    }
  ])
}

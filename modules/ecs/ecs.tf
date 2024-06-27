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

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
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

resource "aws_security_group" "lb_sg" {
  name        = "interseguros-lb-sg"
  description = "Security group para ALB"
  vpc_id      = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb" "interseguros_lb" {
  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id,
    aws_default_subnet.default_subnet_c.id
  ]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "fiber_target_group" {
  name     = "fiber-target-group"
  port     = var.go_listen_port
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default_vpc.id
}

resource "aws_lb_target_group" "express_target_group" {
  name     = "express-target-group"
  port     = var.node_listen_port
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default_vpc.id
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.interseguros_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "fiber_listener_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fiber_target_group.arn
  }

  condition {
    path_pattern {
      values = [ "/fiber/*" ]
    }
  }
}

resource "aws_lb_listener_rule" "express_listener_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.express_target_group.arn
  }

  condition {
    path_pattern {
      values = [ "/express/*" ]
    }
  }
}

resource "aws_ecs_service" "fiber_service" {
  name            = var.fiber_service_name
  cluster         = aws_ecs_cluster.interseguros-cluster.id
  task_definition = aws_ecs_task_definition.interseguros_fiber_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [
      aws_default_subnet.default_subnet_a.id,
      aws_default_subnet.default_subnet_b.id,
      aws_default_subnet.default_subnet_c.id
    ]
    security_groups  = [aws_security_group.lb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fiber_target_group.arn
    container_name   = var.fiber_go_api_name
    container_port   = var.go_listen_port
  }
}

resource "aws_ecs_service" "express_service" {
  name            =  var.express_service_name
  cluster         = aws_ecs_cluster.interseguros-cluster.id
  task_definition = aws_ecs_task_definition.interseguros_express_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  propagate_tags  = "TASK_DEFINITION"

  network_configuration {
    subnets          = [
      aws_default_subnet.default_subnet_a.id,
      aws_default_subnet.default_subnet_b.id,
      aws_default_subnet.default_subnet_c.id
    ]
    security_groups  = [aws_security_group.lb_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.express_target_group.arn
    container_name   = var.express_node_api_name
    container_port   = var.node_listen_port
  }
}
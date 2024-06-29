resource "aws_ecr_repository" "fiber-go-api-proc" {
  name = var.fiber_go_api_name
  force_delete = true
}

resource "aws_ecr_repository" "express-node-api-proc" {
  name = var.express_node_api_name
  force_delete = true
}
terraform {
  required_version = "~> 1.3"
  
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

module "fiber-and-node-ecr-repositories" {
  source                = "./modules/ecr"
  express_node_api_name = local.node_express_api_repo_name
  fiber_go_api_name     = local.fiber_go_api_repo_name
}

module "ecsCluster" {
  source                        = "./modules/ecs"
  availability_zones            = var.availability_zones
  cpu_usage                     = local.cpu_usage
  memory_usage                  = local.memory_usage
  project_name                  = local.name
  go_listen_port                = local.go_listen_port
  node_listen_port              = local.node_listen_port
  fiber_go_image_url            = module.fiber-and-node-ecr-repositories.fiber_go_repository_url
  express_node_image_url        = module.fiber-and-node-ecr-repositories.express_node_repository_url
  express_node_api_name         = local.node_express_api_repo_name
  fiber_go_api_name             = local.fiber_go_api_repo_name
  interseguros_cluster_name     = local.cluster_name
  fiber_task_definition_name    = local.fiber_task_definition_name
  express_task_definition_name  = local.express_task_definition_name
  ecs_task_execution_role_name  = local.task_role_name
  load_balancer_name            = local.load_balancer_name
  express_service_name          = local.express_service_name
  fiber_service_name            = local.fiber_service_name
}
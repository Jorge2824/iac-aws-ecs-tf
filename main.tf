terraform {
  required_version = "~> 1.3"
  
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

module "fiber-ecr-repository" {
  source = "./modules/ecr"
  express_node_api_name = local.node_express_api_repo_name
  fiber_go_api_name = local.fiber_go_api_repo_name
}

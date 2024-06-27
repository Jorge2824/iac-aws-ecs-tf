locals {
  name                          = "factorizacion-qr-interseguros-api-proc"
  region_short                  = "UE1"
  entorno                       = "PROD"
  cpu_usage                     = "1024"
  memory_usage                  = "2048"
  go_listen_port                = 3000
  node_listen_port              = 4000

  fiber_go_api_repo_name        = "fiber-go-api-proc"
  node_express_api_repo_name    = "node-express-api-proc"

  task_role_name                = "${local.region_short}${local.entorno}EXECIAMROLECS"
  cluster_name                  = "${local.region_short}${local.entorno}COMECSFACQR1"

  load_balancer_name            = "${local.region_short}${local.entorno}NETLBFACQR1"

  fiber_service_name            = "${local.region_short}${local.entorno}ECSSVCFIBER1"
  express_service_name          = "${local.region_short}${local.entorno}ECSSVCEXPRESS1"

  fiber_task_definition_name    = "${local.region_short}${local.entorno}ECSTSDFIBER1"
  express_task_definition_name  = "${local.region_short}${local.entorno}ECSTSDEXPRESS1"
}
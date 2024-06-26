variable "interseguros_cluster_name" {
    description = "Nombre ECS Interseguros Cluster"
    type = "string"
}

variable "availability_zones" {
  description = "us-east-1 AZs"
  type        = list(string)
}

variable "fiber_task_definition_name" {
  description = "ECS Task Definition Family"
  type        = string
}

variable "express_task_definition_name" {
  description = "ECS Task Definition Family"
  type        = string
}

variable "fiber_go_api_name" {
  description = "Nombre de Repo ECR para imagen Docker GO Fiber"
  type = string
}

variable "express_node_api_name" {
  description = "Nombre de Repo ECR para imagen Docker Node.js Express"
  type = string
}

variable "fiber_go_image_url" {
  description = "Url de imagen Docker GO Fiber"
  type = string
}

variable "express_node_image_url" {
  description = "Url de imagen Docker Node.js Express"
  type = string
}

variable "cpu_usage" {
  description = "Uso de CPU para Task"
  type = string
}

variable "memory_usage" {
  description = "Uso de memoria para Task"
  type = string
}

variable "go_listen_port" {
  description = "Puerto de Escucha del Contenedor Go Fiber"
  type        = number
}

variable "node_listen_port" {
  description = "Puerto de Escucha del Contenedor Node Express"
  type        = number
}
variable "region" {
  description = "Region AWS"
  default = "us-east-1"
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad"
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" ]
}

variable "key_name" {
    description = "Nombre de par de claves SSH"
    type = string
}

variable "node_express_image" {
  description = "Imagen Docker para Node Express Api"
  type = string
}
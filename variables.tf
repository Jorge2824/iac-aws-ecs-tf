variable "region" {
  description = "Region AWS"
  default = "us-east-1"
}

variable "availability_zones" {
  description = "Lista de zonas de disponibilidad"
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" ]
}

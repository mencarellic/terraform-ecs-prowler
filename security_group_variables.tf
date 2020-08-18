variable "sg_variables" {
  description = "Dictionary of parameters to overwrite defaults for security groups"
  default = {
    production = {}
  }
}

variable "sg_defaults" {
  description = "Dictionary of parameters to use as a default for security groups"
  default = {
    "name" = "ecs_service"
  }
}
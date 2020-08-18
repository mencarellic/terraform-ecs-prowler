variable "ecs_variables" {
  description = "Dictionary of parameters to overwrite defaults for ECS"
  default = {
    production = {}
  }
}

variable "ecs_defaults" {
  description = "Dictionary of parameters to use as a default for ECS"
  default = {
    "name" = "prowler"
    "task_definition" = {
      "cpu"                      = 256
      "memory"                   = 512
      "network_mode"             = "awsvpc"
      "requires_compatibilities" = ["FARGATE"]
    }
    "tags" = {
      "role" = "ECS Cluster"
    }
  }
}
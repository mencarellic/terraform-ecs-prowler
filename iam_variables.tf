variable "iam_variables" {
  description = "Dictionary of parameters to overwrite defaults for IAM"
  default = {
    staging    = {}
    production = {}
  }
}

variable "iam_defaults" {
  description = "Dictionary of parameters to use as a default for IAM"
  default = {
    "ecs_execute" = {
      "name" = "ecs_execute"
    }
    "ecs_events" = {
      "name" = "ecs_events"
    }
    "tags" = {
      "role" = "IAM Role"
    }
  }
}
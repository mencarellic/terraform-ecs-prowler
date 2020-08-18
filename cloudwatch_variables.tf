variable "cloudwatch_variables" {
  description = "Dictionary of parameters to overwrite defaults for Cloudwatch"
  default = {
    production = {}
  }
}

variable "cloudwatch_defaults" {
  description = "Dictionary of parameters to use as a default for Cloudwatch"
  default = {
    "log_group" = {
      "name"              = "/ecs/prowler"
      "retention_in_days" = 7
    }
    "event_rule" = {
      "name"                = "Prowler-Daily"
      "description"         = "Runs Prowler on a cron"
      "schedule_expression" = "cron(15 0 ? * SUN *)"
      "task_count"          = 1
      "launch_type"         = "FARGATE"
      "assign_public_ip"    = false
    }
    "scheduled_tasks" = ["group1", "group2", "group3", "group4", "cislevel1", "rds", "gdpr"]
    "tags" = {
      "role" = "logging"
    }
  }
}
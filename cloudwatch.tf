resource "aws_cloudwatch_log_group" "prowler" {
  name = try(
    var.cloudwatch_variables[terraform.workspace].log_group.name,
    var.cloudwatch_defaults.log_group.name
  )
  retention_in_days = try(
    var.cloudwatch_variables[terraform.workspace].log_group.retention_in_days,
    var.cloudwatch_defaults.log_group.retention_in_days
  )

  tags = merge(
    var.default_tags[terraform.workspace],
    {
      "Name" = try(
        var.cloudwatch_variables[terraform.workspace].log_group.name,
        var.cloudwatch_defaults.log_group.name
      ),
      "Role" = try(
        var.cloudwatch_variables[terraform.workspace].tags.role,
        var.cloudwatch_defaults.tags.role
      )
    }
  )
}

resource "aws_cloudwatch_event_rule" "prowler_daily" {
  for_each = toset(try(
    var.cloudwatch_variables[terraform.workspace].scheduled_tasks,
    var.cloudwatch_defaults.scheduled_tasks
  ))
  name = join("-", [
    try(
      var.cloudwatch_variables[terraform.workspace].event_rule.name,
      var.cloudwatch_defaults.event_rule.name
    ),
    each.value
  ])
  description = try(
    var.cloudwatch_variables[terraform.workspace].event_rule.description,
    var.cloudwatch_defaults.event_rule.description
  )
  schedule_expression = try(
    var.cloudwatch_variables[terraform.workspace].event_rule.schedule_expression,
    var.cloudwatch_defaults.event_rule.schedule_expression
  )
}

resource "aws_cloudwatch_event_target" "ecs_scheduled_task" {
  for_each = toset(try(
    var.cloudwatch_variables[terraform.workspace].scheduled_tasks,
    var.cloudwatch_defaults.scheduled_tasks
  ))
  arn       = aws_ecs_cluster.prowler.arn
  rule      = aws_cloudwatch_event_rule.prowler_daily[each.value].name
  target_id = aws_cloudwatch_event_rule.prowler_daily[each.value].name
  role_arn  = aws_iam_role.ecs_events.arn

  ecs_target {
    task_count = try(
      var.cloudwatch_variables[terraform.workspace].event_rule.task_count,
      var.cloudwatch_defaults.event_rule.task_count
    )
    task_definition_arn = aws_ecs_task_definition.prowler.arn
    launch_type = try(
      var.cloudwatch_variables[terraform.workspace].event_rule.launch_type,
      var.cloudwatch_defaults.event_rule.launch_type
    )

    network_configuration {
      subnets         = data.aws_subnet_ids.private.ids
      security_groups = [aws_security_group.ecs_service.id]
      assign_public_ip = try(
        var.cloudwatch_variables[terraform.workspace].event_rule.assign_public_ip,
        var.cloudwatch_defaults.event_rule.assign_public_ip
      )
    }
  }

  input = <<DOC
{
  "containerOverrides": [
    {
      "name": "prowler",
      "environment": [
        {
          "name": "GROUPID",
          "value": "${each.key}"
        }
      ]
    }
  ]
}
DOC
}
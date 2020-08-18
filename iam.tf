resource "aws_iam_role" "ecs_execute" {
  name = try(
    var.iam_variables[terraform.workspace].ecs_execute.name,
    var.iam_defaults.ecs_execute.name
  )

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json

  tags = merge(
    var.default_tags[terraform.workspace],
    {
      "Name" = try(
        var.iam_variables[terraform.workspace].ecs_execute.name,
        var.iam_defaults.ecs_execute.name
      ),
      "Role" = try(
        var.iam_variables[terraform.workspace].tags.role,
        var.iam_defaults.tags.role
      )
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_execute_attach" {
  role       = aws_iam_role.ecs_execute.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_role" "ecs_events" {
  name = try(
    var.iam_variables[terraform.workspace].ecs_events.name,
    var.iam_defaults.ecs_events.name
  )

  assume_role_policy = data.aws_iam_policy_document.ecs_event_assume_role_policy.json

  tags = merge(
    var.default_tags[terraform.workspace],
    {
      "Name" = try(
        var.iam_variables[terraform.workspace].ecs_events.name,
        var.iam_defaults.ecs_events.name
      ),
      "Role" = try(
        var.iam_variables[terraform.workspace].tags.role,
        var.iam_defaults.tags.role
      )
    }
  )
}

resource "aws_iam_role_policy_attachment" "ecs_events_attach" {
  role       = aws_iam_role.ecs_events.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceEventsRole"
}
resource "aws_ecs_cluster" "prowler" {
  name = try(
    var.ecs_variables[terraform.workspace].name,
    var.ecs_defaults.name
  )

  tags = merge(
    var.default_tags[terraform.workspace],
    {
      "Name" = try(
        var.ecs_variables[terraform.workspace].name,
        var.ecs_defaults.name
      ),
      "Role" = try(
        var.ecs_variables[terraform.workspace].tags.role,
        var.ecs_defaults.tags.role
      )
    }
  )
}

resource "aws_ecs_task_definition" "prowler" {
  family = aws_ecs_cluster.prowler.name
  cpu = try(
    var.ecs_variables[terraform.workspace].task_definition.cpu,
    var.ecs_defaults.task_definition.cpu
  )
  memory = try(
    var.ecs_variables[terraform.workspace].task_definition.memory,
    var.ecs_defaults.task_definition.memory
  )
  network_mode = try(
    var.ecs_variables[terraform.workspace].task_definition.network_mode,
    var.ecs_defaults.task_definition.network_mode
  )
  requires_compatibilities = try(
    var.ecs_variables[terraform.workspace].task_definition.requires_compatibilities,
    var.ecs_defaults.task_definition.requires_compatibilities
  )
  execution_role_arn = aws_iam_role.ecs_execute.arn

  container_definitions = <<DEFINITION
[
  {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.prowler.name}",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "environment": [
      {
        "name": "AWS_ACCESS_KEY_ID",
        "value": "${var.aws_access_key[terraform.workspace]}"
      },
      {
        "name": "AWS_SECRET_ACCESS_KEY",
        "value": "${var.aws_secret_key[terraform.workspace]}"
      },
      {
        "name": "GROUPID",
        "value": "group1,group2,group3,group4,cislevel1,gdpr,rds"
      },
      {
        "name": "REGION",
        "value": "us-east-1"
      },
      {
        "name": "BUCKET",
        "value": "${aws_s3_bucket.bucket.bucket}"
      }
    ],
    "image": "${aws_ecr_repository.prowler.repository_url}:latest",
    "name": "${aws_ecs_cluster.prowler.name}"
  }
]
DEFINITION
}
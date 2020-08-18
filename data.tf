# Current AWS Account
data "aws_caller_identity" "current" {}

# Get VPC info based on varibale
data "aws_vpc" "default" {
  id = var.default_vpc[terraform.workspace]
}

# Get private subnet ids in VPC, given availability zones
data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name = "tag:Name"
    values = [
      "*private"
    ]
  }
  filter {
    name   = "availabilityZone"
    values = var.ebs_availability_zones
  }
}

# Get public subnet ids in VPC, given availability zones
data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name = "tag:Name"
    values = [
      "*public"
    ]
  }
  filter {
    name   = "availabilityZone"
    values = var.ebs_availability_zones
  }
}

# IAM Assume Role Policy for ECS
data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# IAM Assume Role Policy for ECS
data "aws_iam_policy_document" "ecs_event_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}
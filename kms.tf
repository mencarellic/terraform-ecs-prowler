resource "aws_kms_key" "prowler" {
  deletion_window_in_days = try(
    var.kms_variables[terraform.workspace].deletion_window_in_days,
    var.kms_defaults.deletion_window_in_days
  )
  description = try(
    var.kms_variables[terraform.workspace].description,
    var.kms_defaults.description
  )
  enable_key_rotation = try(
    var.kms_variables[terraform.workspace].enable_key_rotation,
    var.kms_defaults.enable_key_rotation
  )
  is_enabled = try(
    var.kms_variables[terraform.workspace].is_enabled,
    var.kms_defaults.is_enabled
  )
  key_usage = try(
    var.kms_variables[terraform.workspace].key_usage,
    var.kms_defaults.key_usage
  )
  policy = try(
    var.kms_variables[terraform.workspace].policy,
    var.kms_defaults.policy
  )

  tags = merge(
    var.default_tags[terraform.workspace],
    {
      "Name" = try(
        var.kms_variables[terraform.workspace].alias,
        var.kms_defaults.alias
      ),
      "Role" = try(
        var.kms_variables[terraform.workspace].tags.role,
        var.kms_defaults.tags.role
      )
    }
  )
}

resource "aws_kms_alias" "kms_alias" {
  name = try(
    var.kms_variables[terraform.workspace].alias,
    var.kms_defaults.alias
  )
  target_key_id = aws_kms_key.prowler.key_id
}
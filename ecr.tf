resource "aws_ecr_repository" "prowler" {
  name = try(
    var.ecr_variables[terraform.workspace].name,
    var.ecr_defaults.name
  )
  image_tag_mutability = try(
    var.ecr_variables[terraform.workspace].image_tag_mutability,
    var.ecr_defaults.image_tag_mutability
  )

  image_scanning_configuration {
    scan_on_push = try(
      var.ecr_variables[terraform.workspace].image_scanning_configuration.scan_on_push,
      var.ecr_defaults.image_scanning_configuration.scan_on_push
    )
  }

  tags = merge(
    var.default_tags[terraform.workspace],
    {
      "Name" = try(
        var.ecr_variables[terraform.workspace].name,
        var.ecr_defaults.name
      ),
      "Role" = try(
        var.ecr_variables[terraform.workspace].tags.role,
        var.ecr_defaults.tags.role
      )
    }
  )
}   
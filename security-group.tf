resource "aws_security_group" "ecs_service" {
  name = try(
    var.sg_variables[terraform.workspace].name,
    var.sg_defaults.name
  )
  vpc_id = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
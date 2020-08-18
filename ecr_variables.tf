variable "ecr_variables" {
  description = "Dictionary of parameters to overwrite defaults for ECR"
  default = {
    production = {}
  }
}

variable "ecr_defaults" {
  description = "Dictionary of parameters to use as a default for ECR"
  default = {
    "name"                 = "mencarellic/prowler"
    "image_tag_mutability" = "MUTABLE"
    "image_scanning_configuration" = {
      "scan_on_push" = true
    }
    "tags" = {
      "role" = "Prowler Image Repo"
    }
  }
}
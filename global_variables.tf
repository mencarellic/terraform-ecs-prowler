#--------#
# Global #
#--------#
variable "aws_region" {
  description = "The AWS region to use"
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS profile to use"
  default     = "default-mfasession"
}

variable "aws_workspace_assume_roles" {
  default = {
    production = "arn:aws:iam::123456789012:role/administrator_production_us"
  }
}

variable "aws_account_id" {
  description = "The AWS account ID"
  default = {
    production = "123456789012"
  }
}

variable "ebs_availability_zones" {
  description = "A list of zones that can have ebs enabled instances"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "aws_access_key" {
  description = "Access key to run tasks as"
  default = {
    production = "####"
  }
}

variable "aws_secret_key" {
  description = "Secret key to run tasks as"
  default = {
    production = "####"
  }
}

#-----------------------#
# Resource Tagging Vars #
#-----------------------#

variable "default_tags" {
  description = "Dictionary of tags to use as a base default"
  default = {
    production = {
      "Name"              = "REPLACE THIS"
      "Project"           = "REPLACE THIS"
      "Role"              = "REPLACE THIS"
      "Environment"       = "production"
      "Terraform Managed" = "true"
    }
  }
}

variable "stages" {
  description = "Which stage to tag with"
  default = {
    production = "prd"
  }
}

variable "project" {
  description = "What project is this for?"
  default     = "core"
}


#------------------------------#
# General Networking Variables #
#------------------------------#

variable "default_vpc" {
  description = "The default AWS VPC"
  default = {
    production = "vpc-12345678"
  }
}

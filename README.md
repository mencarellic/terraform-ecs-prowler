# Terraform ECS Prowler Module

This repo pairs with my [fork of Prowler](https://github.com/mencarellic/prowler).

## Requirements

* Terraform >0.12.20
  * I use 0.12.20, but any version after this in the 0.12 minor version should work
  * The reliance on 0.12.20 and new is due to reliance on `try`

## How To Use This Module

This module relies heavily on setting a series of defaults that are repeated across multiple AWS accounts. If specific variables are needing to be overwritten, this can be done in the module definition. If nothing needs to be overwritten, you can specify the module as such:

```hcl
module "prowler" {
  source = "git@github.com:mencarellic/terraform-ecs-prowler?ref=v0.1.0"

  #----------------------------------------------#
  # Variables that aren't changing from defaults #
  #----------------------------------------------#

  #   kms_variables = {
  #       staging = { }
  #       production = { }
  #   }

  #   iam_variables = {
  #       staging = { }
  #       production = { }
  #   }

  #   cloudwatch_variables = {
  #       staging = { }
  #       production = { }
  #   }

  #   sg_variables = {
  #       staging = { }
  #       production = { }
  #   }

  #   ecs_variables = {
  #       staging = { }
  #       production = { }
  #   }

  #   ecr_variables = {
  #       staging = { }
  #       production = { }
  #   }

  #   s3_variables = {
  #     staging = { }
  #     production = { }
  #   }
}
```

## What This Creates

### Elastic Container Repository

The GitHub Action in [mencarellic/prowler](https://github.com/mencarellic/prowler) builds the Docker image and pushes it to ECR. This repo creates a repository that can be used by ECS to pull from.

### IAM

This module will create two roles. One that executes the task in ECS (`ecs_execute`) and one that triggers the schedule in Cloudwatch (`ecs_events`). 

### Elastic Container Service

A pretty basic cluster is created so the task will have somewhere to live. After that, the task itself is created, mainly specifying a lot of the container configuration options like `cpu`, `memory`, etc. [This heredoc block](https://github.com/mencarellic/terraform-ecs-prowler/blob/bf2739e8c67ff80a6efcbf2ebe1cbfa8e4fe6db5/ecs.tf#L42-L79) is also where the default environment variables are defined. 

### Cloudwatch

First a Cloudwatch log group is created for ECS logging. Next an event rule is created for each Prowler group specified in the `cloudwatch_defaults.scheduled_tasks` variable (specified [here](https://github.com/mencarellic/terraform-ecs-prowler/blob/bf2739e8c67ff80a6efcbf2ebe1cbfa8e4fe6db5/cloudwatch_variables.tf#L23)) using a `for_each` loop. An event target for each group is created in a similar way.

### Key Management Service

The output from Prowler is uploaded to an S3 bucket that's defined at runtime. This S3 bucket is encrypted with a key generated and stored in KMS.

### S3

A private bucket in S3 is created for the output to be stored. This is encrypted by the key created in the module and can optionally be configued with lifecycle and versioning rules. 

### Security Groups

A generic SG is needed for the container, so one is created here with no ingress and open egress. 

## To Do

* Extract the requirement to have a AWS keys :scream:
* Provide some additional examples

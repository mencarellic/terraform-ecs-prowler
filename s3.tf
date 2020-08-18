resource "aws_s3_bucket" "bucket" {
  bucket = try(
    var.s3_variables[terraform.workspace].bucket,
    join("-", ["mencarellic", var.stages[terraform.workspace], "prowler-archive"]),
    var.s3_defaults.bucket
  )
  acl = try(
    var.s3_variables[terraform.workspace].acl,
    var.s3_defaults.acl
  )

  versioning {
    enabled = try(
      var.s3_variables[terraform.workspace].versioning.enabled,
      var.s3_defaults.versioning.enabled
    )
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.prowler.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    id = try(
      var.s3_variables[terraform.workspace].lifecycle_rule.id,
      var.s3_defaults.lifecycle_rule.id
    )
    abort_incomplete_multipart_upload_days = try(
      var.s3_variables[terraform.workspace].lifecycle_rule.abort_incomplete_multipart_upload_days,
      var.s3_defaults.lifecycle_rule.abort_incomplete_multipart_upload_days
    )
    enabled = true

    expiration {
      days = try(
        var.s3_variables[terraform.workspace].lifecycle_rule.expiration.days,
        var.s3_defaults.lifecycle_rule.expiration.days
      )
    }

    noncurrent_version_expiration {
      days = try(
        var.s3_variables[terraform.workspace].lifecycle_rule.noncurrent_version_expiration.days,
        var.s3_defaults.lifecycle_rule.noncurrent_version_expiration.days
      )
    }
  }

}
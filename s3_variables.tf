variable "s3_variables" {
  description = "Dictionary of parameters to overwrite defaults for S3"
  default = {
    production = {}
  }
}

variable "s3_defaults" {
  description = "Dictionary of parameters to use as a default for S3"
  default = {
    "bucket" = null
    "acl"    = "private"
    "versioning" = {
      "enabled" = false
    }
    "lifecycle_rule" = {
      "id"                                     = "expiration"
      "abort_incomplete_multipart_upload_days" = 5
      "expiration" = {
        "days" = 90
      }
      "noncurrent_version_expiration" = {
        "days" = 7
      }
    }
  }
}
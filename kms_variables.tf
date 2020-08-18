variable "kms_variables" {
  description = "Dictionary of parameters to overwrite defaults for KMS"
  default = {
    production = {}
  }
}

variable "kms_defaults" {
  description = "Dictionary of parameters to use as a default for KMS"
  default = {
    alias                   = "alias/prowler"
    deletion_window_in_days = 30
    description             = "Key for Prowler S3 encryption"
    enable_key_rotation     = true
    is_enabled              = true
    key_usage               = "ENCRYPT_DECRYPT"
    policy                  = null
    "tags" = {
      "role" = "S3 Encryption Key"
    }
  }
}

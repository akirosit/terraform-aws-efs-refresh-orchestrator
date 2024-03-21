variable "efs_to_refresh" {
  type = map(object({
    SourceEFSId    = string
    EFSName        = string
    EFSArn         = string
    Encrypted      = optional(bool)
    KmsKeyId       = optional(string)
    ItemsToRestore = optional(list(string))
  }))
}

variable "sns_topic_arn" {
  description = "Existing SNS topic ARN to send notifications"
  type        = string
  default     = null
}
variable "create_s3_bucket" {
  description = "Create S3 bucket to put step function input json files"
  type        = bool
  default     = false
}
variable "put_step_function_input_json_files_on_s3" {
  description = "Push or not step function input json files to S3 bucket"
  type        = bool
  default     = false
}
variable "s3_bucket_name" {
  description = "Name of the bucket s3 created within this module or existing S3 name to put step function input json files"
  type        = string
  default     = null
}

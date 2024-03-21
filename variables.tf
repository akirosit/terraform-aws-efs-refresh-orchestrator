variable "efs_to_refresh" {
  type = map(object({
    SourceEFSName  = string
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
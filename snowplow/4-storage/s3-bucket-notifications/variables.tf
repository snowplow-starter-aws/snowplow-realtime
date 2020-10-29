variable "bucket" {}
variable "bucket_arn" {}
variable "lambda_notifications" {
  type = list(object({
    lambda_arn = string
    filter_prefix = string
    events = list(string)
  }))
}

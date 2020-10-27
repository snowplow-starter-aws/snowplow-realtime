variable "region" {}
variable "account_id" {}
variable "ecs_cluster_id" {}

variable "in_stream_name" {}
variable "out_stream_name" {}
variable "in_stream_arn" {}
variable "out_stream_arn" {}
variable "s3_bucket" {}
variable "s3_bucket_arn" {}
variable "image" {}

variable "desired_count" {
  default = 1
}

variable "task_cpu" {
  default = 1024
}

variable "task_memory" {
  default = 1024
}


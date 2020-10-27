variable "region" {}
variable "account_id" {}
variable "ecs_cluster_id" {}
variable "collector_stream_good_arn" {}
variable "enricher_stream_good_arn" {}
variable "enricher_stream_good_pii_arn" {}
variable "enricher_stream_bad_arn" {}
variable "enricher_state_table" {}
variable "image" {}

variable "task_cpu" {
  default = 1024
}

variable "task_memory" {
  default = 1024
}

variable "desired_count" {}


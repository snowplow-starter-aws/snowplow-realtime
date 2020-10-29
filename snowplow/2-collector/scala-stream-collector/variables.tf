variable "image" {}
variable "domain" {}
variable "dns_provider" {}
variable "dns_provider_region" {}
variable "account_id" {}

variable "vpc_id" {}
variable "ecs_cluster_id" {}
variable "ecs_cluster_name" {}
variable "ecs_default_capacity_provider" {}
variable "ecs_default_capacity_provider_base" {}
variable "ecs_default_capacity_provider_weight" {}

variable "collector_stream_good_arn" {}
variable "collector_stream_bad_arn" {}

variable "zone_id" {}
variable "lb_zone_id" {}
variable "lb_dns_name" {}
variable "lb_listener_443_arn" {}
variable "lb_listener_80_arn" {}

variable "task_cpu" {
  default = 1024
}

variable "task_memory" {
  default = 1024
}

variable "max_count" {}
variable "min_count" {}
variable "desired_count" {}

variable "collector_cookie_domain1" {}
variable "collector_cookie_domain2" {}
variable "collector_cookie_fallback_domain" {}


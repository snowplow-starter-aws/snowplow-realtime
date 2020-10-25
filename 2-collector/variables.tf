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

# CPU value 	    Memory value (MiB)
# 256 (.25 vCPU) 	512 (0.5GB), 1024 (1GB), 2048 (2GB)
# 512 (.5 vCPU) 	1024 (1GB), 2048 (2GB), 3072 (3GB), 4096 (4GB)
# 1024 (1 vCPU) 	2048 (2GB), 3072 (3GB), 4096 (4GB), 5120 (5GB), 6144 (6GB), 7168 (7GB), 8192 (8GB)
# 2048 (2 vCPU) 	Between 4096 (4GB) and 16384 (16GB) in increments of 1024 (1GB)
# 4096 (4 vCPU) 	Between 8192 (8GB) and 30720 (30GB) in increments of 1024 (1GB)
variable "task_cpu" {
  default = 1024
}

variable "task_memory" {
  default = 1024
}

variable "max_count" {}
variable "min_count" {}
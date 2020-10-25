variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "security_group_lb_id" {}
variable "amazon_linux_2_ecs_ami" {}

variable "instance_type" {}
variable "key_name" {}
variable "health_check_grace_period" {
  default = 600
}
variable "desired_capacity" {}
variable "min_size" {}
variable "max_size" {}
variable "enabled_metrics" {
  type = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]
}
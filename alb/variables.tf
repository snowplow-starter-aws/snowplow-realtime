variable "vpc_id" {}
variable "vpc_public_subnets" {
  type = list(string)
}
variable "domain" {}
variable "dns_zone_id" {}
variable "dns_provider" {}
variable "dns_provider_region" {}

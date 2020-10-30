output "alb_name" {
  value = aws_lb.alb-external.name
}

output "alb_arn" {
  value = aws_lb.alb-external.arn
}

output "alb_dns_name" {
  value = aws_lb.alb-external.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb-external.zone_id
}

output "arn_suffix" {
  value = aws_lb.alb-external.arn_suffix
}

output "alb_listener_80_arn" {
  value = aws_lb_listener.forward-from-port-80.arn
}

output "alb_listener_443_arn" {
  value = aws_lb_listener.forward-from-port-443.arn
}

output "security_group_lb_id" {
  value = aws_security_group.lb.id
}
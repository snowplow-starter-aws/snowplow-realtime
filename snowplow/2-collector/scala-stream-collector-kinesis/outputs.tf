output "ecs_service_name" {
  value = aws_ecs_service.service.name
}

output "svc" {
  value = aws_iam_service_linked_role.ecs-autoscaling.name
}
locals {
  resource_id = "service/${var.ecs_cluster_name}/${aws_ecs_service.service.name}"
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_count
  min_capacity       = var.min_count
  resource_id        = local.resource_id
  role_arn           = aws_iam_role.ecs_task_role.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "by_cpu" {
  name               = "scale-by-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = local.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    target_value       = 60
    scale_in_cooldown  = 60
    scale_out_cooldown = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }

  depends_on = [
  aws_appautoscaling_target.ecs_target]
}

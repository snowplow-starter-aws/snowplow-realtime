resource "aws_ecs_service" "service" {

  depends_on = [
    aws_iam_role.ecs_task_role,
    aws_iam_role.ecs_execution_role
  ]

  name            = "snowplow-scala-stream-collector"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 600

  iam_role = "arn:aws:iam::${var.account_id}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"


  load_balancer {
    target_group_arn = aws_lb_target_group.target-group.arn
    container_name   = "snowplow-scala-stream-collector"
    container_port   = 8080
  }

  capacity_provider_strategy {
    base              = var.ecs_default_capacity_provider_base
    capacity_provider = var.ecs_default_capacity_provider
    weight            = var.ecs_default_capacity_provider_weight
  }

}


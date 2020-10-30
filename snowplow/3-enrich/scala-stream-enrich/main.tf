locals {
  name = "snowplow-stream-enrich"
}

resource "aws_ecs_service" "service" {

  depends_on = [
    aws_iam_role.ecs_task_role,
    aws_iam_role.ecs_execution_role
  ]

  name            = local.name
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.desired_count

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  capacity_provider_strategy {
    base              = var.ecs_default_capacity_provider_base
    capacity_provider = var.ecs_default_capacity_provider
    weight            = var.ecs_default_capacity_provider_weight
  }


}
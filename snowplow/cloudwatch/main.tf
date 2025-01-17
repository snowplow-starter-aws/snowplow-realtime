resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "snowplow"
  dashboard_body = templatefile("${path.module}/dashboard-body.json",
    {
      ecs_cluster_name           = var.ecs_cluster_name,
      alb_arn_suffix             = var.alb_arn_suffix
      ecs_service_name_collector = var.ecs_service_name_collector
      ecs_service_name_enrich    = var.ecs_service_name_enrich
  })

}

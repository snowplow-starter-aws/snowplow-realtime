output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}
output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}

output "ecs_ec2_instance_profile_arn" {
  value = aws_iam_instance_profile.container_instance.arn
}

output "ecs_ec2_launchtemplate_id" {
  value = aws_launch_template.container_instance.id
}

output "default_capacity_provider" {
  value = tolist(aws_ecs_cluster.cluster.default_capacity_provider_strategy)[0].capacity_provider
}

output "default_capacity_provider_base" {
  value = tolist(aws_ecs_cluster.cluster.default_capacity_provider_strategy)[0].base
}

output "default_capacity_provider_weight" {
  value = tolist(aws_ecs_cluster.cluster.default_capacity_provider_strategy)[0].weight
}
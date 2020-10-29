locals {
  name = "snowplow"
}

resource "aws_ecs_cluster" "cluster" {
  name = local.name

  capacity_providers = [
  aws_ecs_capacity_provider.cp.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.cp.name

    # The weight value designates the relative percentage of the total number of
    # launched tasks that should use the specified capacity provider.
    # For example, if you have a strategy that contains two capacity providers,
    # and both have a weight of 1, then when the base is satisfied,
    # the tasks will be split evenly across the two capacity providers.
    # Using that same logic, if you specify a weight of 1 for capacityProviderA
    # and a weight of 4 for capacityProviderB, then for every one task that
    # is run using capacityProviderA, four tasks would use capacityProviderB.

    weight = 1

    # The base value designates how many tasks, at a minimum, to run on the specified capacity provider.
    # Only one capacity provider in a capacity provider strategy can have a base defined.
    //    base = 1
  }
}


resource "aws_iam_service_linked_role" "ecs" {
  aws_service_name = "ecs.amazonaws.com"
}


resource "aws_ecs_capacity_provider" "cp" {
  depends_on = [aws_iam_service_linked_role.ecs]
  //  name = "${var.name}-cluster-managed-scaling-${var.capacity_provider_suffix}"
  name = "snowplow-cluster-managed-scaling"


  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.container_instance.arn

    # When managed termination protection is enabled, Amazon ECS prevents Amazon EC2 instances that contain
    # tasks and that are in an Auto Scaling group from being terminated during a scale-in action.
    # Managed termination protection can only be enabled if the Auto Scaling group also has
    # instance protection from scale in enabled.
    managed_termination_protection = "ENABLED"

    managed_scaling {

      status                    = "ENABLED"
      target_capacity           = 80
      maximum_scaling_step_size = 3
      minimum_scaling_step_size = 1
    }
  }
}


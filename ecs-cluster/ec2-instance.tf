resource "aws_iam_role" "container_instance_ec2" {
  name               = "snowplow-ecs-ec2-instance-profile"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "container_instance" {
  name = aws_iam_role.container_instance_ec2.name
  role = aws_iam_role.container_instance_ec2.name
}


resource "aws_iam_role_policy_attachment" "enable-ssm-on-container-instance" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.container_instance_ec2.name
}


resource "aws_iam_role_policy_attachment" "ec2_service_role" {
  role       = aws_iam_role.container_instance_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "clouwatch" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.container_instance_ec2.name
}


resource "aws_security_group" "container_instance" {
  name   = "snowplow-ecs-ec2-instance"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "container_instance_http_ingress" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
  "0.0.0.0/0"]
  security_group_id = aws_security_group.container_instance.id
}

resource "aws_security_group_rule" "container_instance_http_ingress_from_lb" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = var.security_group_lb_id
  security_group_id        = aws_security_group.container_instance.id
}

resource "aws_security_group_rule" "container_instance_http_egress" {
  type      = "egress"
  from_port = 0
  to_port   = 65535
  protocol  = "tcp"
  cidr_blocks = [
  "0.0.0.0/0"]

  security_group_id = aws_security_group.container_instance.id
}


data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    ecs_cluster_name = local.name
  }
}

resource "aws_launch_template" "container_instance" {

  disable_api_termination = false

  name_prefix = "snowplow-container-instance-"

  iam_instance_profile {
    name = aws_iam_instance_profile.container_instance.name
  }


  image_id = var.amazon_linux_2_ecs_ami

  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  key_name                             = var.key_name


  vpc_security_group_ids = [
  aws_security_group.container_instance.id]

  user_data = base64encode(data.template_file.user_data.rendered)

  monitoring {
    enabled = true
  }
}


resource "aws_autoscaling_group" "container_instance" {
  lifecycle {
    create_before_destroy = true
  }

  name = "snowplow-ecs-managed-autoscaling-group"

  launch_template {
    id      = aws_launch_template.container_instance.id
    version = "$Latest"
  }

  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "EC2"
  termination_policies = [
    "OldestLaunchConfiguration",
  "Default"]
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  enabled_metrics       = var.enabled_metrics
  protect_from_scale_in = true


  vpc_zone_identifier = var.private_subnets

  tag {
    key                 = "Name"
    value               = "snowplow-ecs-cluster-instance"
    propagate_at_launch = true
  }


}

locals {
  subnet_id = var.subnet_ids[0]
}


resource "aws_iam_instance_profile" "ec2" {
  name = "jumphost-ec2-instance-profile"
  path = "/terraform/"
  role = aws_iam_role.ec2-role.name
}

resource "aws_iam_role" "ec2-role" {
  name = "jumphost-ec2-role"
  path = "/terraform/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "enable-ssm-on-jumphost" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2-role.name
}


resource "aws_security_group" "dmz" {
  name   = "jumphost-dmz"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ssh-into-dmz-from-home" {
  from_port         = 22
  protocol          = "TCP"
  security_group_id = aws_security_group.dmz.id
  to_port           = 22
  type              = "ingress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

# needed for ssm
resource "aws_security_group_rule" "https-into-dmz" {
  from_port         = 443
  protocol          = "TCP"
  security_group_id = aws_security_group.dmz.id
  to_port           = 443
  type              = "ingress"

  cidr_blocks = [
    "0.0.0.0/0"
  ]
}


# access to internet
resource "aws_security_group_rule" "out-from-dmz" {
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  security_group_id = aws_security_group.dmz.id

  type = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")
}


resource "aws_instance" "jumphost" {
  ami                  = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2.id

  root_block_device {
    volume_size = 50
  }

  subnet_id = local.subnet_id

  user_data = base64encode(data.template_file.user_data.rendered)

  vpc_security_group_ids = [
    aws_security_group.dmz.id
  ]

  tags = {
    Name = "snowplow-jumphost"
  }

}


resource "aws_iam_policy" "temporary-access" {
  name = "temporary-access-for-jumphost"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "temporary" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = aws_iam_policy.temporary-access.arn
}

resource "aws_iam_role_policy_attachment" "read-only-access-for-jumphost" {
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.ec2-role.name
}
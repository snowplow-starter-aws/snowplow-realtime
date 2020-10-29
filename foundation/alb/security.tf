resource "aws_security_group" "lb" {
  name   = "lb"
  vpc_id = var.vpc_id
}

# needed for checking target's health in target groups. lb is curling out to instances in target group
resource "aws_security_group_rule" "out-from-lb" {
  description       = "ping out for target health"
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.lb.id
  to_port           = 65535
  type              = "egress"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

resource "aws_security_group_rule" "access-from-everywhere" {
  from_port         = 0
  protocol          = "TCP"
  security_group_id = aws_security_group.lb.id
  to_port           = 65535
  type              = "ingress"

  cidr_blocks = [
    "0.0.0.0/0",
  ]
}
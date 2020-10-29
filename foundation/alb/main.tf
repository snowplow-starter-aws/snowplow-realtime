resource "aws_lb" "alb-external" {
  name               = "alb-external-snowplow-ecs"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
  aws_security_group.lb.id]
  subnets = var.vpc_public_subnets

  enable_deletion_protection = false
}


resource "aws_lb_listener" "forward-from-port-80" {

  load_balancer_arn = aws_lb.alb-external.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "default_action: check LB config"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener" "forward-from-port-443" {

  load_balancer_arn = aws_lb.alb-external.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn


  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "default_action: check LB config"
      status_code  = "404"
    }
  }

}

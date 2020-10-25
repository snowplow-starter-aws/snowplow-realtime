provider "aws" {
  alias   = "dns-provider"
  profile = var.dns_provider
  region  = var.dns_provider_region
}

resource "aws_lb_target_group" "target-group" {
  name        = "snowplow-collector"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"


  health_check {
    path                = "/health"
    interval            = 6
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
    port                = "traffic-port"
  }
}


resource "aws_lb_listener_rule" "listener-rule-80" {
  depends_on = [
  aws_lb_target_group.target-group]
  listener_arn = var.lb_listener_80_arn

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [
        "collector.${var.domain}"
      ]
    }
  }
}

resource "aws_lb_listener_rule" "listener-rule-443" {
  depends_on = [
  aws_lb_target_group.target-group]
  listener_arn = var.lb_listener_443_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }

  condition {
    host_header {
      values = [
        "collector.${var.domain}"
      ]
    }
  }
}

resource "aws_route53_record" "route53" {
  provider = aws.dns-provider

  zone_id = var.zone_id
  name    = "collector"
  type    = "A"

  alias {
    name                   = var.lb_dns_name
    zone_id                = var.lb_zone_id
    evaluate_target_health = true
  }
}

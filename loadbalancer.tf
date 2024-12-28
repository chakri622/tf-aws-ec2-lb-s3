# aws_elb_service_account
data "aws_elb_service_account" "root" {}
#aws_lb
resource "aws_lb" "nginx-alb" {

  name                       = "global-web-lb"
  internal                   = false
  load_balancer_type         = "application"
  subnets                    = module.app.public_subnets
  security_groups            = [aws_security_group.alb_sg.id]
  depends_on                 = [module.web_app_s3]
  enable_deletion_protection = false

  tags = local.common_tags

  access_logs {
    bucket  = module.web_app_s3.web_bucket.id
    prefix  = "alb-logs"
    enabled = true
  }

}



#aws_lb_target_group

resource "aws_lb_target_group" "nginx" {
  name        = "nginx-target-group"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.app.vpc_id
  tags        = local.common_tags

}

#aws_lb_listener

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }

}

#aws_lb_target_group_attachments

resource "aws_lb_target_group_attachment" "nginx" {
  count            = var.instances_count
  target_group_arn = aws_lb_target_group.nginx.arn
  target_id        = aws_instance.nginx_instances[count.index].id
  port             = 80

}


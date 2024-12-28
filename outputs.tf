

output "aws_lb_public_dns" {
  value       = "http://${aws_lb.nginx-alb.dns_name}"
  description = "Public DNS hostname for the LB"
}       
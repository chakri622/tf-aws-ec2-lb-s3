############################################################################################################################################
# PROVIDERS
###############################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}


# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}


##############################################################################
# RESOURCES
##############################################################################

module "app" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Globomantics"
  cidr = var.vpc_cidr_block

  azs            = slice(data.aws_availability_zones.available.names, 0, var.vpc_public_subnet_count)
  public_subnets = [for subnet in range(var.vpc_public_subnet_count) : cidrsubnet(var.vpc_cidr_block, 8, subnet)]

  enable_nat_gateway      = false
  enable_vpn_gateway      = false
  enable_dns_hostnames    = var.enable_dns_hostnames
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-vpc" })
}


#NETWORKING

#security groups
#Nginx securoty group
resource "aws_security_group" "nginx_sg" {
  name        = "${local.naming_prefix}-nginx_sg"
  description = "Nginx Security Group"
  vpc_id      = module.app.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

#Alb security group
resource "aws_security_group" "alb_sg" {
  name        = "nginx_alb_sg"
  description = "Application Load Balancer Security Group"
  vpc_id      = module.app.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}






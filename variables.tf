variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base AWS CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnet_count" {
  type        = number
  description = "Number of public subnets"
  default     = 2

}

variable "instances_count" {
  type        = number
  description = "Number of instances"
  default     = 2

}


variable "aws_public_subnets_cidr_block" {
  type        = list(string)
  description = "Base AWS CIDR block for the VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
  default     = true

}
variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map public IP addresses to the instance automatically"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instances"
  default     = "t2.micro"

}

variable "company" {
  type        = string
  description = "Company name"
  default     = "Chakri Mantics"

}

variable "project" {
  type        = string
  description = "Project name for resource tagging"


}

variable "billing_code" {
  type        = string
  description = "Billing for resource tagging"


}

variable "naming_prefix" {
  type        = string
  description = "A prefix for the resources created by this module"
  default     = "chakri-mantics"

}


variable "environment" {
  type        = string
  description = "Environment for resource tagging"
  default     = "dev"


}


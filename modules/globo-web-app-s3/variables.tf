#bucket-name
variable "bucket_name" {
  type        = string
  description = "Name of S3 bucket"

}

#elb_service_account_arn
variable "elb_service_account_arn" {
  type        = string
  description = "ARN of the IAM role to attach to the Elastic Load Balancer"
}

#vpc_id
variable "common_tags" {
  type        = map(string)
  description = "Common tags for resources"
  default     = {}

}
  
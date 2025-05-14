variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Account region"
}

variable "vpc_name" {
  type = string
  default = "tech-challenge-vpc"
  description = "Custom VPC name"
}

variable "nlb_name" {
  type = string
  default = "tech-challenge-nlb3"
  description = "Network Load Balancer name"
}

variable "lambda_authorizer_name" {
  type = string
  default = "tech-challenge-lambda-authorizer"
  description = "Lambda Authorizer name"
}
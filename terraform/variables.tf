variable "aws_region" {
  description = "AWS region where the infrastructure will be provisioned"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_blocks" {
  description = "CIDR blocks for the subnets"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "email-api"
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default = "email-api-ecs-cluster"
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 8000
}

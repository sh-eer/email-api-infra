# Configure the AWS provider
provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}

# Create a subnet within the VPC
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_blocks
}

# Create an ECR repository
resource "aws_ecr_repository" "ecr_repository" {
  name = var.ecr_repository_name
}

# Create an ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

# Create a task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = "email-api"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "email-api-container",
      "image": "${aws_ecr_repository.ecr_repository.repository_url}:latest",
      "portMappings": [
        {
          "containerPort": var.container_port,
          "hostPort": 0,
          "protocol": "tcp"
        }
      ],
      "environment": []
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}

# Create a security group allowing inbound traffic on port 8000
resource "aws_security_group" "security_group" {
  name        = "email-api-security-group"
  description = "Allow inbound traffic on port 8000"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a load balancer
resource "aws_lb" "load_balancer" {
  name               = "email-api-load-balancer"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet.id]
  security_groups    = [aws_security_group.security_group.id]
}

# Create a target group
resource "aws_lb_target_group" "target_group" {
  name     = "email-api-target-group"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path = "/health"
  }
}

# Create a listener
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Create a service
resource "aws_ecs_service" "ecs_service" {
  name            = "email-api-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "email-api"
    container_port   = var.container_port
  }
}

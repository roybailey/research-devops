provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------------
# ecr repository

resource "aws_ecr_repository" "sample_ecr_repo" {
  name = "sample-ecr-repo"
}


# ------------------------------------------------------------
# ecs cluster, using default vpc and subnets

resource "aws_ecs_cluster" "sample_ecs_cluster" {
  name = "sample-ecs-cluster"
}

# Providing a reference to our default VPC
resource "aws_default_vpc" "default_vpc" {
}

# Providing a reference to our default subnets
resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "us-east-1a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "us-east-1b"
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "us-east-1c"
}


# ------------------------------------------------------------
# iAM roles

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}


# ------------------------------------------------------------
# ecs task definition

resource "aws_ecs_task_definition" "sample_ecs_task" {
  family = "sample-ecs-task"
  # Naming the definition
  container_definitions = <<DEFINITION
  [
    {
      "name": "sample-ecs-task",
      "image": "${aws_ecr_repository.sample_ecr_repo.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  # Stating that we are using ECS Fargate
  requires_compatibilities = [
    "FARGATE"
  ]
  # Using awsvpc as our network mode as this is required for Fargate
  network_mode = "awsvpc"
  # Specifying the memory our container requires
  memory = 512
  # Specifying the CPU our container requires
  cpu = 256
  # Specifying the iAM role for executing the task
  execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
}


# ------------------------------------------------------------
# ecs load balancer

# Creating a security group for the load balancer:
resource "aws_security_group" "sample_ecs_load_balancer_security_group" {

  # Allowing traffic in from port 80 from all sources
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  # Allowing all traffic out from all IP addresses
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_alb" "sample_ecs_load_balancer" {
  name = "sample-ecs-load-balancer"
  load_balancer_type = "application"
  # Referencing the default subnets
  subnets = [
    aws_default_subnet.default_subnet_a.id,
    aws_default_subnet.default_subnet_b.id,
    aws_default_subnet.default_subnet_c.id
  ]
  # Referencing the security group
  security_groups = [
    aws_security_group.sample_ecs_load_balancer_security_group.id
  ]
}


# ------------------------------------------------------------
# ecs target group and listener

resource "aws_lb_target_group" "sample_ecs_target_group" {
  depends_on = [
    aws_alb.sample_ecs_load_balancer,
  ]
  name = "sample-ecs-target-group"
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  # Referencing the default VPC
  vpc_id = aws_default_vpc.default_vpc.id
}

resource "aws_lb_listener" "sample_ecs_listener" {
  # Referencing our load balancer
  load_balancer_arn = aws_alb.sample_ecs_load_balancer.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    # Referencing our target group
    target_group_arn = aws_lb_target_group.sample_ecs_target_group.arn
  }
}


# ------------------------------------------------------------
# ecs service

resource "aws_security_group" "sample_ecs_security_group" {

  # all traffic in from load balancer security group
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.sample_ecs_load_balancer_security_group.id]
  }

  # all traffic out
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "sample_ecs_service" {
  depends_on = [
    aws_alb.sample_ecs_load_balancer,
    aws_lb_target_group.sample_ecs_target_group,
    aws_ecs_task_definition.sample_ecs_task
  ]
  name = "sample-ecs-service"
  # Referencing our created Cluster
  cluster = aws_ecs_cluster.sample_ecs_cluster.id
  # Referencing the task our service will spin up
  task_definition = aws_ecs_task_definition.sample_ecs_task.arn
  # Using FARGATE instead of self managed EC2
  launch_type = "FARGATE"
  # Setting the number of containers we want deployed
  desired_count = 3

  load_balancer {
    # Referencing our target group
    target_group_arn = aws_lb_target_group.sample_ecs_target_group.arn
    # Specifying the container name and port
    container_name = aws_ecs_task_definition.sample_ecs_task.family
    container_port = 3000
  }

  network_configuration {
    subnets = [
      aws_default_subnet.default_subnet_a.id,
      aws_default_subnet.default_subnet_b.id,
      aws_default_subnet.default_subnet_c.id
    ]
    # Providing our containers with public IPs
    assign_public_ip = true
    security_groups = [
      aws_security_group.sample_ecs_security_group.id
    ]
  }
}



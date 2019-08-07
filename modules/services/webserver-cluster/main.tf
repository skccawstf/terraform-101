data "aws_availability_zones" "all" {}

module "default_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.14.1"
  namespace   = var.namespace
  stage       = var.stage
  name        = var.name
  attributes  = var.attributes
  delimiter   = var.delimiter
  tags        = var.tags

  additional_tag_map = {
    propagate_at_launch = "true"
  }

}

resource "aws_security_group" "instance" {
  name = "${module.default_label.id}-ec2"
  tags = module.default_label.tags
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "example" {

  # terraform-null-label example used here: Set launch configuration name prefix
  name_prefix     = "${module.default_label.id}-"
  image_id        = "ami-0a25005e83c56767a"
  instance_type   = "t2.nano"
  security_groups = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {

  # terraform-null-lable example used here: Set ASG name prefix
  name_prefix = "${module.default_label.id}-"
  tags = module.default_label.tags_as_list_of_maps
  launch_configuration = aws_launch_configuration.example.id
  availability_zones = data.aws_availability_zones.all.names
  min_size = 2
  max_size = 3
  load_balancers = [aws_elb.example.name]
  health_check_type = "ELB"

}

resource "aws_security_group" "elb" {
  name = "${module.default_label.id}-elb"
  tags = module.default_label.tags
  # Allow all outbound
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "elb_port" {
  description = "The port elb will use for HTTP requests"
  type = number
  default = 80
}

resource "aws_elb" "example" {
  name = module.default_label.id
  tags = module.default_label.tags
  security_groups = [aws_security_group.elb.id]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target = "HTTP:${var.server_port}/"
    interval = 30
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port = var.elb_port
    lb_protocol = "http"
    instance_port = var.server_port
    instance_protocol = "http"
  }
}
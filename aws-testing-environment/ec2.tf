data "aws_ami" "amzn_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_key_pair" "public_key" {
  key_name   = var.ec2_public_key_name
  public_key = file(var.ec2_public_key_path)
}

resource "aws_launch_template" "worker_nodes_lt" {
  name          = "worker-nodes-lt"
  description   = "Launch Template for the worker nodes instances"
  image_id      = data.aws_ami.amzn_linux_2.id
  instance_type = var.ec2_worker_nodes_instance_type
  key_name      = var.ec2_public_key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.worker_nodes_sg.id]
  }
}

resource "aws_autoscaling_group" "worker_nodes_asg" {
  name                = "worker-nodes-asg"
  desired_capacity    = var.ec2_worker_nodes_asg_desired_cap
  min_size            = var.ec2_worker_nodes_asg_min_cap
  max_size            = var.ec2_worker_nodes_asg_max_cap
  vpc_zone_identifier = [data.aws_subnet.default.id]

  launch_template {
    id      = aws_launch_template.worker_nodes_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "worker-nodes-asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "master_nodes_lt" {
  name          = "master-nodes-lt"
  description   = "Launch Template for the master nodes instances"
  image_id      = data.aws_ami.amzn_linux_2.id
  instance_type = var.ec2_master_nodes_instance_type
  key_name      = var.ec2_public_key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.master_nodes_sg.id]
  }
}

resource "aws_autoscaling_group" "master_nodes_asg" {
  name                = "master-nodes-asg"
  desired_capacity    = var.ec2_master_nodes_asg_desired_cap
  min_size            = var.ec2_master_nodes_asg_min_cap
  max_size            = var.ec2_master_nodes_asg_max_cap
  vpc_zone_identifier = [data.aws_subnet.default.id]


  launch_template {
    id      = aws_launch_template.master_nodes_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "master-nodes-asg"
    propagate_at_launch = true
  }
}


data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet" "default" {
  vpc_id            = data.aws_vpc.default.id
  default_for_az    = true
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_security_group" "worker_nodes_sg" {
  name        = "worker-node-sg"
  description = "Cluster Worker Nodes instances security group"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = local.worker_nodes.ingress
    iterator = each
    content {
      from_port       = each.value.from_port
      to_port         = each.value.to_port
      protocol        = each.value.protocol
      cidr_blocks     = try(each.value.cidr_blocks, [])
      self            = try(each.value.self, false)
      security_groups = try(each.value.security_groups, [])
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "master_nodes_sg" {
  name        = "master-node-sg"
  description = "Cluster master nodes instances security group"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = local.master_nodes.ingress
    iterator = each
    content {
      from_port       = each.value.from_port
      to_port         = each.value.to_port
      protocol        = each.value.protocol
      cidr_blocks     = try(each.value.cidr_blocks, [])
      self            = try(each.value.self, false)
      security_groups = try(each.value.security_groups, [])
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

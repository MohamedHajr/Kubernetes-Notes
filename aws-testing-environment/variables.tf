######################
## Global Variables #######
#####################

variable "env" {
  type        = string
  description = "current enviroment pod, dev etc.."
}

variable "region" {
  type        = string
  description = "AWS Region to use"
  default     = "us-east-1"
}

######################
## EC2 Variables #######
#####################
variable "ec2_worker_nodes_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "ec2_master_nodes_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "ec2_public_key_name" {
  type        = string
  description = "SSH public key name for the AWS key pair"
}

variable "ec2_public_key_path" {
  type        = string
  description = "The path on the local machine for the SSH public key"
}

variable "ec2_sg_ingress_ports" {
  type        = list(number)
  description = "inbound Security group ports to be opened"
}

variable "ec2_worker_nodes_asg_desired_cap" {
  type        = number
  description = "the desired capacity for the bastion instacnes in the auto scaling group"
  default     = 2
}

variable "ec2_worker_nodes_asg_min_cap" {
  type        = number
  description = "the minimum capacity for the bastion instacnes in the auto scaling group"
  default     = 2
}

variable "ec2_worker_nodes_asg_max_cap" {
  type        = number
  description = "the maximum capacity to scale out to, for the bastion instacnes in the auto scaling group"
  default     = 2
}

variable "ec2_master_nodes_asg_desired_cap" {
  type        = number
  description = "the desired capacity for the master nodes instacnes in the auto scaling group"
  default     = 1
}

variable "ec2_master_nodes_asg_min_cap" {
  type        = number
  description = "the minimum capacity for the master nodes instacnes in the auto scaling group"
  default     = 1
}

variable "ec2_master_nodes_asg_max_cap" {
  type        = number
  description = "the maximum capacity to scale out to, for the master nodes instacnes in the auto scaling group"
  default     = 1
}

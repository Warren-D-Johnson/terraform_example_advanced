variable "instances" {
  description = "List of instance names"
  type        = list(string)
}

variable "subnet_names" {
  description = "Names of the subnets"
  type        = map(string)
}

variable "availability_zones" {
  type = map(string)
  description = "Map of availability zones for each instance."
}

variable "hostnames" {
  description = "A map of instance names to hostnames"
  type        = map(string)
}

variable "security_group_names" {
  description = "Names of the security groups"
  type        = list(string)
}

variable "volume_tags" {
  description = "Tags for the EBS volumes"
  type        = map(map(string))
}

variable "instance_tags" {
  description = "Tags for the EC2 instances"
  type        = map(map(string))
}

variable "root_block_device" {
  description = "Configuration for the root block device"
  type        = map(string)
}

variable "ebs_block_device" {
  description = "Configuration for the additional EBS block device"
  type        = map(string)
}

variable "ec2_ami" {
  description = "The AMI ID for the EC2 instances"
  type        = string
}

variable "ec2_instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to be used"
  type        = string
}

variable "iam_role" {
  description = "IAM role for instances"
  type        = string
}

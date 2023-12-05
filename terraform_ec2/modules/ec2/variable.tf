variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "subnet ID"
  type        = string
}

variable "instance_ami" {
  type = string
  default = "ami-06dd92ecc74fdfb36"
}

variable "key" {
  type = string
  default = "demo1"
}
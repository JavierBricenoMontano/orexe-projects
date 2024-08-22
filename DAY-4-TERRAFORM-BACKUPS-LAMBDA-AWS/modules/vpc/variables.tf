variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC."
}

variable "public_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for public subnets."
}

variable "private_subnets" {
  type        = list(string)
  description = "List of CIDR blocks for private subnets."
}

variable "availability_zones" {
  type        = list(string)
  description = "The list of availability zones where the subnets will be created."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
}

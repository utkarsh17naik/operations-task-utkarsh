variable "environment" {
  description = "Specify environment: Dev/Stage/Preprod/Prod"
  type        = string
}

variable "vpc_cidr" {
  description = "Specify VPC CIDR Range"
  type        = string
}

variable "public_subnets_cidr" {
  description = "Specify Public Subnet CIDR Range"
  type        = list(string)
}

variable "private_subnets_cidr" {
  description = "Specify Private Subnet CIDR Range"
  type        = list(string)
}

variable "availability_zones" {
  description = "Specific Availability zone for subnets"
  type        = list(string)

}

variable "s3-bucket" {
  description = "Name of S3 Bucket"
  type        = string
}

variable "app-name" {
  description = "Name of the Application"
  type        = string
}

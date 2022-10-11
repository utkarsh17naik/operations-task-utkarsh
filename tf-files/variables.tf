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

variable "container_port" {
  description = "Specify Container port"
  type        = number
}

variable "host_port" {
  description = "Specify Host port"
  type        = number
}

variable "container_cpu" {
  description = "Specify Container CPU"
  type        = number
}

variable "container_memory" {
  description = "Specify Container Memory"
  type        = number

}
variable "health_check_path" {
  description = "Health check path"
  type        = string
}

variable "port_mappings" {
  description = "Port mappings for ECS"
  type        = map(number)
}

variable "AWS_DEFAULT_REGION" {
  description = "Default region for AWS"
  type        = string
  default     = "ap-south-1"
}

variable "public-key" {
  description = "Enter your public key"
  type        = string
  sensitive   = true
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCswVScXRwofq3QRmBhYH+lX25uZkYjj25VYuQQzqgjwbnWpq/PGZbzzGLu751mxhKKlWRyd/5n3wUwHd46Ib9PNFY1bs3zDgRip0bINyW9vz8Fo01qYyTHi4/6aA+DvmCzlqMSm3H7cZn35LvNHpBTvj3I9+hkxDldYPQe2u2+Sv+8DDRtaJIlF1R3xDX6hv4Inr/+02TuLvj2MD3QUQt/0IqyJI5oMDsozQWeAaVRgFriZaZQbNpyfUd4B0RjRL7nUBHyY8izT72FLnD512XcyZ1O0Ka/YeeeKUfjV5Tt2lK/1s21kJnqweIDW642vC9IEPNb5luRahrApuPpY3k/6B3zmjZuvMFP3OSGpkLNn8WFiVro+ocCwhCKcwd8Lo3wwuFbEBwBK7vkXWOdx7N1RH3UXmHhJCyJCp2vntPf0mN5dRZmf6GE1nHaB/VxGaiFZcROfECqHZZRafbj0CyFe3Z95wF4Y6VjN5AeNpK6VdQ4EQNZm6HF/Yj48zh4m0M= neosoft@neosoft"
}

variable "ami" {
  description = "ami id"
  type        = string

}

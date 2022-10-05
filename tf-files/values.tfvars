environment          = "dev"
vpc_cidr             = "192.168.1.0/24"
public_subnets_cidr  = ["192.168.1.0/26", "192.168.1.128/26"]
private_subnets_cidr = ["192.168.1.64/26", "192.168.1.192/26"]
availability_zones   = ["ap-south-1a", "ap-south-1b"]

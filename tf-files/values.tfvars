environment          = "dev"
vpc_cidr             = "192.168.1.0/24"
public_subnets_cidr  = ["192.168.1.0/26", "192.168.1.128/26"]
private_subnets_cidr = ["192.168.1.64/26", "192.168.1.192/26"]
availability_zones   = ["ap-south-1a", "ap-south-1b"]
s3-bucket            = "rates-7821"
app-name             = "rates-api"
container_port       = 80
host_port            = 80
container_cpu        = 1024
container_memory     = 2048
health_check_path    = "/"
port_mappings = {
  containerPort : 80,
  hostPort : 80
}

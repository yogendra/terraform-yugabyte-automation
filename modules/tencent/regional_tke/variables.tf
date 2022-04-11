variable "name" {
  type        = string
  description = "Name of the cluster. This will be used as prefix for resources also"
}

variable "region" {
  type        = string
  description = "region name"
}

variable "ssh_public_key" {
  type        = string
  description = "Public key to register for the region"
}
variable "availability_zones_list" {
  type        = list(string)
  description = "List of availability zones for TKE cluster"
}
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.1.0.0/16"
}
variable "service_cidr" {
  type        = string
  description = "TKE Cluster service CIDR"
  default     = "192.168.1.0/24"
}
variable "vpc_dns_server_list" {
  type        = list(string)
  default     = ["183.60.83.19", "183.60.82.98"]
  description = "List of DNS servers"
}
variable "tags" {
  type = map
  default = {
  }
  description = "Tags (object list) for cloud resources"
}

variable "default_instance_type" {
  type        = string
  default     = "S5.4XLARGE32"
  description = "Size of the machine"
}
variable "default_backup_instance_types" {
  type        = list(string)
  default     = ["S4.4XLARGE32"]
  description = "Size of the backup machine"
}
variable "allowed_subnets" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Which external networks should be allowed to access "
}


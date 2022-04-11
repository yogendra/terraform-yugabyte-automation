
variable "name" {
  type        = string
  description = "Project Name - Will be used as prefix for evenrything"
  default      = "yb"
}
# variable "region1" {
#   type        = list(string)
#   description = "Region 1 : List of regions to deploy"

# }
# variable "region1_az_list" {
#   type = list(string)
#   description = "Region 1 : List of azs"

# }
# variable "region1_vpc_cidr" {
#   type = string
#   description = "Region 1 : VPC CIDR"
#   default = "10.1.0.0/16"
# }
# variable "region1_service_cidr" {
#   type = string
#   description = "Region 1 : TKE Service CIDR"
#   default = "192.168.1.0/24"
# }
# variable "region1_tags"{
#   type = any,
#   description = "Region 1 : Tags"
#   default =  {}

# }
# variable "region2" {
#   type        = list(string)
#   description = "Region 2 : List of regions to deploy"

# }
# variable "region2_az_list" {
#   type = list(string)
#   description = "Region 2 : List of azs"

# }
# variable "region2_vpc_cidr" {
#   type = string
#   description = "Region 2 : VPC CIDR"
#   default = "10.2.0.0/16"
# }
# variable "region2_service_cidr" {
#   type = string
#   description = "Region 2 : TKE Service CIDR"
#   default = "192.168.2.0/24"
# }
# variable "region2_tags"{
#   type = any,
#   description = "Region 2 : Tags"
#   default =  {}

# }
# variable "region3" {
#   type        = list(string)
#   description = "Region 3 : List of regions to deploy"

# }
# variable "region3_az_list" {
#   type = list(string)
#   description = "Region 3 : List of azs"

# }
# variable "region3_vpc_cidr" {
#   type = string
#   description = "Region 3 : VPC CIDR"
#   default = "10.3.0.0/16"
# }
# variable "region3_service_cidr" {
#   type = string
#   description = "Region 3 : TKE Service CIDR"
#   default = "192.168.3.0/24"
# }
# variable "region3_tags"{
#   type = any,
#   description = "Region 3 : Tags"
#   default =  {}

# }




variable "region_list" {
  type = list(string)
  description = "list of regions"
  default = ["ap-guangzhou", "na-siliconvalley", "eu-frankfurt"]
}
variable "region_az_list" {
  type = list(list(string))
  description = "list of availability zones correspoding to regions"
  default = [
    ["ap-guangzhou-4","ap-guangzhou-6","ap-guangzhou-7"],
    ["na-siliconvalley-1","na-siliconvalley-2"],
    ["eu-frankfurt-1"]
  ]
}

variable "vpc_cidr_list" {
  type = list(string)
  description = "vpc cidr"
  default = ["10.1.0.0/16","10.2.0.0/16", "10.3.0.0/16"]
}

variable "service_cidr_list" {
  type = list(string)
  description = "services cidr"
  default = ["192.168.1.0/8","192.168.2.0/8","192.168.3.0/8"]
}

variable "tags" {
  type = any
  description = "Common tags for all regions"
  default = {
  }
}
# variable "config"{
#   type = list(object({
#     az_list : list(string),
#     vpc_cidr : string,
#     service_cidr: string
#   })

#   )
# }

# variable "secret_id" {
#   type        = string
#   description = "secret_id"
# }


# variable "secret_key" {
#   type        = string
#   description = "secret_key"
#   defaul = ""
# }

terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}


resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}



module "regional_tke" {

  count = length(var.region_list)

  local {
    rg = var.region_list[count.index]
  }
  region                  = local.sg
  source                  = "../regional_tke"
  name                    = "${var.name}-${local.rg}"
  ssh_public_key          = chomp(tls_private_key.ssh.public_key_openssh)
  availability_zones_list = var.region_az_list[count.index]
  vpc_cidr                = var.vpc_cidr_list[count.index]
  service_cidr            = var.service_cidr_list[count.index]

  tags = merge(
    var.tags
  )

}



resource "tencentcloud_ccn" "main" {
  name        = "${var.name}-ccn"
  description = "CCN for ${var.name}"
  qos         = "AG"
}



resource "tencentcloud_ccn_attachment" "region_attachment" {
  count           = length(var.region_list)
  ccn_id          = tencentcloud_ccn.main.id
  instance_type   = "VPC"
  instance_id     = module.regional_tke[count.index].vpc_id
  instance_region = var.region_list[count.index]
}

# module "region1" {
#   source                  = "../regional_tke"
#   name                    = "${var.name}-gz"
#   ssh_public_key          = chomp(tls_private_key.ssh.public_key_openssh)
#   availability_zones_list = var.region1_az_list
#   vpc_cidr                = var.region1_vpc_cidr
#   service_cidr            = var.region1_service_cidr

#   tags = merge(
#     var.region1_tags,
#     var.tags
#   )
#   providers = {
#     tencentcloud = tencentcloud.region1
#   }
# }


# module "region2" {
#   source                  = "./tencent_regional_tke"
#   name                    = "${var.name}-gz"
#   ssh_public_key          = chomp(tls_private_key.ssh.public_key_openssh)
#   availability_zones_list = var.region2_az_list
#   vpc_cidr                = var.region2_vpc_cidr
#   service_cidr            = var.region2_service_cidr

#   tags = merge(
#     var.region2_tags,
#     var.tags
#   )
#   providers = {
#     tencentcloud = tencentcloud.region2
#   }
# }

# module "region3" {
#   source                  = "./tencent_regional_tke"
#   name                    = "${var.name}-gz"
#   ssh_public_key          = chomp(tls_private_key.ssh.public_key_openssh)
#   availability_zones_list = var.region3_az_list
#   vpc_cidr                = var.region3_vpc_cidr
#   service_cidr            = var.region3_service_cidr

#   tags = merge(
#     var.region3_tags,
#     var.tags
#   )
#   providers = {
#     tencentcloud = tencentcloud.region3
#   }
# }


# resource "tencentcloud_ccn" "main" {
#   name        = "${var.name}-ccn"
#   description = "CCN for ${var.name}"
#   qos         = "AG"
# }

# resource "tencentcloud_ccn_attachment" "region1_attachment" {
#   ccn_id          = tencentcloud_ccn.main.id
#   instance_type   = "VPC"
#   instance_id     = module.region1.vpc_id
#   instance_region = var.region1
# }

# resource "tencentcloud_ccn_attachment" "region2_attachment" {
#   ccn_id          = tencentcloud_ccn.main.id
#   instance_type   = "VPC"
#   instance_id     = module.region2.vpc_id
#   instance_region = var.region2
# }

# resource "tencentcloud_ccn_attachment" "region3_attachment" {
#   ccn_id          = tencentcloud_ccn.main.id
#   instance_type   = "VPC"
#   instance_id     = module.region3.vpc_id
#   instance_region = var.region3
# }

/*
TODO
1. Create Cluster in region 1
2. Create Cluster in region 2
3. Create Cluster in region 3
4. Create CCN
5. Attach region 1 vpc to ccn
6. Attach region 2 vpc to ccn
7. Attach region 3 vpc to ccn
8. Create Yugaware namespace in region 1
9. Add k8s secret to yugaware namespace
10. Deploy Yugaware
10. Configure CoreDNS for  region1
11. Configure CoreDNS for region2
12. Configure CoreDNS for region3
*/


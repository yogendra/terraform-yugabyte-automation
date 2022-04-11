terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}

module "test" {
  source                  = "../"
  name                    = "test"

  region = ["ap-guangzhou", "na-siliconvalley"]
  region_az_list = [
      ["ap-guangzhou-4"],
      ["na-siliconvalley-1"],
  ]
  vpc_cidr_list = ["10.1.0.0/16","10.2.0.0/16" ]
  services_cidr_list = ["192.168.1.0/24", "192.168.2.0/24"]



  # region1 = "ap-guangzhou"
  # region1_az_list = ["ap-guangzhou-4","ap-guangzhou-6","ap-guangzhou-7"]


  # region2 = "eu-frankfurt"
  # region2_az_list = ["eu-frankfurt-1"]

  # region3 = "na-siliconvalley"
  # region3_az_list = ["na-siliconvalley-1","na-siliconvalley-2"]

  tags = {
    task = "testsuite"
  }
  # providers = {
  #   tencentcloud = tencentcloud.region1
  # }
}

output "kubeconfig_list" {
  description = "K8s config"
  value = module.tencent_regional_tke.kubeconfig_list
}

output "vpc_id" {
  description = "VPC ID"
  value = module.tencent_regional_tke.vpc_id
}

output "ssh_private_key" {
  description = "SSH Private key"
  value = tls_private_key.test_ssh.private_key_openssh
}

output "ssh_public_key" {
  description = "SSH Private key"
  value = tls_private_key.test_ssh.private_key_openssh
}

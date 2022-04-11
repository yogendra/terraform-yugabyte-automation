terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}

module "tencent_multireion_k8s" {
  source "../../modules/tencent/multi_region_tke"
  # region = ["ap-guangzhou", "na-siliconvalley", "eu-frankfurt"]
  # region_az_list = [
  #   ["ap-guangzhou-4","ap-guangzhou-6","ap-guangzhou-7"],
  #   ["na-siliconvalley-1","na-siliconvalley-2"],
  #   ["eu-frankfurt-1"]
  # ]

  # region1 = "ap-guangzhou"
  # region1_az_list = ["ap-guangzhou-4","ap-guangzhou-6","ap-guangzhou-7"]


  # region2 = "eu-frankfurt"
  # region2_az_list = ["eu-frankfurt-1"]

  # region3 = "na-siliconvalley"
  # region3_az_list = ["na-siliconvalley-1","na-siliconvalley-2"]


}

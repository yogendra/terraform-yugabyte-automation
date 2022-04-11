terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}

# provider "tencentcloud" {
#   region = "ap-guangzhou"
# }
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}


module "test" {
  source                  = "../"
  name                    = "test-gz"
  region                  = "ap-guangzhou"
  ssh_public_key          = chomp(tls_private_key.ssh.public_key_openssh)
  availability_zones_list = ["ap-guangzhou-4","ap-guangzhou-6","ap-guangzhou-7"]
  vpc_cidr                = "10.200.0.0/16"
  service_cidr            = "192.168.200.0/24"

  tags = {
    task = "testsuite"
  }

}

output "kubeconfig" {
  value = module.test.kubeconfig
  description = "K8s config"
}


output "vpc_id" {
  value = module.test.vpc_id
  description = "VPC ID"
}

# resource "tencentcloud_kubernetes_cluster" "managed_cluster" {
#   vpc_id                  = "vpc-o7zb92qn"
#   cluster_max_pod_num     = 256
#   cluster_name            = "test-tke"
#   cluster_desc            = "test-tee - TKE Cluster for Region"
#   cluster_max_service_num = 256
#   cluster_version         = "1.20.6"
#   cluster_os              = "ubuntu18.04.1x86_64"
#   cluster_deploy_type     = "MANAGED_CLUSTER"
#   network_type            = "VPC-CNI"
#   container_runtime       = "containerd"
#   service_cidr            = "192.168.2.0/24"
#   eni_subnet_ids          = ["subnet-f7u7v7v0","subnet-lknm6ylq","subnet-fuata0xu"]

#   cluster_internet        = true
#   managed_cluster_internet_security_policies = ["0.0.0.0/0"]

#   node_pool_global_config {
#     is_scale_in_enabled            = false
#     expander                       = "random"
#     ignore_daemon_sets_utilization = true
#     max_concurrent_scale_in        = 5
#     scale_in_delay                 = 15
#     scale_in_unneeded_time         = 15
#     scale_in_utilization_threshold = 30
#     skip_nodes_with_local_storage  = false
#     skip_nodes_with_system_pods    = true
#   }
# }



# //this is one example of managing node using node pool
# resource "tencentcloud_kubernetes_node_pool" "nodepool" {

#   name                     = "test-ap-singapore-1}"
#   cluster_id               = tencentcloud_kubernetes_cluster.managed_cluster.id
#   max_size                 = 3
#   min_size                 = 1
#   vpc_id                   = "vpc-o7zb92qn"
#   subnet_ids               = ["subnet-f7u7v7v0"]
#   retry_policy             = "INCREMENTAL_INTERVALS"
#   desired_capacity         = 1
#   enable_auto_scale        = false
#   multi_zone_subnet_policy = "EQUALITY"
#   node_os                  = "ubuntu18.04.1x86_64"

#   auto_scaling_config {
#     instance_type      = var.default_instance_type
#     key_ids            = ["skey-7ituaid7"]
#     system_disk_type   = "CLOUD_PREMIUM"
#     system_disk_size   = "50"
#     security_group_ids = ["sg-2rbaet0c"]

#     data_disk {
#       disk_type = "CLOUD_PREMIUM"
#       disk_size = 50
#     }

#     internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
#     internet_max_bandwidth_out = 10
#     public_ip_assigned         = true
#     # password                   = "test123#"
#     enhanced_security_service  = false
#     enhanced_monitor_service   = false

#   }

#   labels = {
#     "topology.kybernetes.io/zone" = var.availability_zones_list[count.index],
#     "failure-domain.beta.kybernetes.io/zone" = var.availability_zones_list[count.index],
#   }

# }

terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
    }
  }
}


provider "tencentcloud"{
  region = var.region
}

resource "tencentcloud_vpc" "vpc" {
  name         = "${var.name}-vpc"
  cidr_block   = var.vpc_cidr
  dns_servers  = var.vpc_dns_server_list
  is_multicast = false
  tags         = var.tags
}


resource "tencentcloud_key_pair" "ssh_key" {
  key_name   = replace("${var.name}_ssh","-","_")
  public_key = chomp(var.ssh_public_key)
}


resource "tencentcloud_eip" "nat_gw_eip" {
  name = "${var.name}-nat-gw-eip"
  tags = var.tags
}

resource "tencentcloud_nat_gateway" "nat_gw" {
  name             = "${var.name}-nat-gw"
  vpc_id           = tencentcloud_vpc.vpc.id
  bandwidth        = 100
  max_concurrent   = 1000000
  assigned_eip_set = [tencentcloud_eip.nat_gw_eip.public_ip]
  tags             = var.tags
}

resource "tencentcloud_route_table_entry" "nat_gw_rte" {
  route_table_id         = tencentcloud_vpc.vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  next_type              = "NAT"
  next_hub               = tencentcloud_nat_gateway.nat_gw.id
  description            = "Send external traffic via NAT GW"
}


resource "tencentcloud_subnet" "private" {
  count             = length(var.availability_zones_list)
  name              = "${var.name}-${var.availability_zones_list[count.index]}-private"
  cidr_block        = cidrsubnet(tencentcloud_vpc.vpc.cidr_block, 3, count.index)
  availability_zone = var.availability_zones_list[count.index]
  vpc_id            = tencentcloud_vpc.vpc.id
  tags              = var.tags
  route_table_id    = tencentcloud_vpc.vpc.default_route_table_id
}



resource "tencentcloud_security_group" "tke_wroker" {
  name        = "${var.name}-sg"
  description = "Security Group for TKE machines"
  project_id  = 0
}


resource "tencentcloud_security_group_rule" "allow_internal" {
  security_group_id = tencentcloud_security_group.tke_wroker.id
  type              = "ingress"
  cidr_ip           = "10.0.0.0/8"
  policy            = "ACCEPT"
  description       = "Allow all internal traffic"
}

resource "tencentcloud_security_group_rule" "allow_internal_b" {
  security_group_id = tencentcloud_security_group.tke_wroker.id
  type              = "ingress"
  cidr_ip           = "172.16.0.0/16"
  policy            = "ACCEPT"
  description       = "Allow all internal traffic"
}

resource "tencentcloud_security_group_rule" "allow_internal_c" {
  security_group_id = tencentcloud_security_group.tke_wroker.id
  type              = "ingress"
  cidr_ip           = "192.168.0.0/16"
  policy            = "ACCEPT"
  description       = "Allow all internal traffic"
}
resource "tencentcloud_security_group_rule" "allow_external" {
  security_group_id = tencentcloud_security_group.tke_wroker.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  policy            = "ACCEPT"
  description       = "Allow all traffic"
}
//this is the cluster with empty worker config
resource "tencentcloud_kubernetes_cluster" "managed_cluster" {
  vpc_id                  = tencentcloud_vpc.vpc.id
  cluster_max_pod_num     = 256
  cluster_name            = "${var.name}-tke"
  cluster_desc            = "${var.name} - TKE Cluster for Region"
  cluster_max_service_num = 256
  cluster_version         = "1.20.6"
  cluster_deploy_type     = "MANAGED_CLUSTER"
  network_type            = "VPC-CNI"
  container_runtime       = "containerd"
  service_cidr            = var.service_cidr
  eni_subnet_ids          = tencentcloud_subnet.private[*].id


  cluster_internet                           = true
  managed_cluster_internet_security_policies = var.allowed_subnets

  node_pool_global_config {
    is_scale_in_enabled = false
  }

  tags = var.tags
}

//this is one example of managing node using node pool
resource "tencentcloud_kubernetes_node_pool" "nodepool" {
  count                    = length(var.availability_zones_list)
  name                     = "${var.name}-${var.availability_zones_list[count.index]}"
  cluster_id               = tencentcloud_kubernetes_cluster.managed_cluster.id
  max_size                 = 3
  min_size                 = 1
  vpc_id                   = tencentcloud_vpc.vpc.id
  subnet_ids               = [tencentcloud_subnet.private[count.index].id]
  retry_policy             = "INCREMENTAL_INTERVALS"
  desired_capacity         = 1
  enable_auto_scale        = false
  multi_zone_subnet_policy = "EQUALITY"
  node_os                  = "ubuntu18.04.1x86_64"
  delete_keep_instance     = false
  termination_policies     = ["NEWEST_INSTANCE"]


  auto_scaling_config {
    instance_type         = var.default_instance_type
    backup_instance_types = var.default_backup_instance_types

    key_ids            = [tencentcloud_key_pair.ssh_key.id]
    system_disk_type   = "CLOUD_PREMIUM"
    system_disk_size   = "50"
    security_group_ids = [tencentcloud_security_group.tke_wroker.id]

    data_disk {
      disk_type = "CLOUD_PREMIUM"
      disk_size = 50
    }

    # internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
    # internet_max_bandwidth_out = 10
    public_ip_assigned        = false
    enhanced_security_service = false
    enhanced_monitor_service  = false

  }

  labels = {
    "topology.kubernetes.io/zone"            = var.availability_zones_list[count.index],
    "failure-domain.beta.kubernetes.io/zone" = var.availability_zones_list[count.index],
  }

}

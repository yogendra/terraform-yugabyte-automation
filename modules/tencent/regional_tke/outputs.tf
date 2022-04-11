output "kubeconfig" {
  description = "Kubeconfig for TKE cluster"
  value = tencentcloud_kubernetes_cluster.managed_cluster.kube_config
}

output "vpc_id" {
  description = "VPC ID"
  value       = tencentcloud_vpc.vpc.id
}


output "ssh_private_key" {
  description = "SSH Private Key"
  value = tls_private_key.ssh.private_key_pem
  sensitive = true
}


output "ssh_public_key" {
  description = "SSH Public Key"
  value = tls_private_key.ssh.public_key_openssh
}

output "kubeconfig_list" {
  description = "Kubeconfig for all clusters"
  sensitive = true
  value = module.regional_tke[*].kubeconfig
}

output "vpc_id_list" {
  description = "VPC ID list"
  value = module.regional_tke[*].vpc_id
}
# output "region1_kubeconfig" {
#   description = "Region 1: Kubeconfig"
#   sensitive = true
#   value = module.region1.kubeconfig
# }

# output "region2_kubeconfig" {
#   description = "Region 2: Kubeconfig"
#   sensitive = true
#   value = module.region2.kubeconfig
# }

# output "region3_kubeconfig" {
#   description = "Region 3: Kubeconfig"
#   sensitive = true
#   value = module.region3.kubeconfig
# }


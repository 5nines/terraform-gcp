output "master01_internal_ip" {
  description = "The internal IP addresses of the master instances"
  value       = "${google_compute_instance.okdmasters.*.network_interface.0.network_ip}"
}

output "infra_nodes_internal_ip" {
  description = "The internal IP addresses of the infrastructure node instances"
  value       = "${google_compute_instance.okdinfra.*.network_interface.0.network_ip}"
}

output "nodes_internal_ip" {
  description = "The internal IP addresses of the node instances"
  value       = "${google_compute_instance.okdnodes.*.network_interface.0.network_ip}"
}
output "lb_external_ip" {
  description = "The external IP addresses of the lb instance"
  value       = "${google_compute_instance.okdlb.0.network_interface.0.access_config.0.nat_ip}"
}

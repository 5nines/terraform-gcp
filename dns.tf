# DNS zone
resource "google_dns_managed_zone" "test" {
  name     = "test-lab59"
  dns_name = "test.59labs.com."
}

# DNS record sets
resource "google_dns_record_set" "okdmasters" {
  count        = "${var.master_count}"
  name         = "${lookup(var.master_names, count.index)}.${google_dns_managed_zone.test.dns_name}"
  managed_zone = "${google_dns_managed_zone.test.name}"
  type         = "A"
  ttl          = 300

  rrdatas = ["${element(google_compute_instance.okdmasters.*.network_interface.0.network_ip, count.index)}"]
}

resource "google_dns_record_set" "okdinfra" {
  count        = "${var.infra_count}"
  name         = "${lookup(var.infra_names, count.index)}.${google_dns_managed_zone.test.dns_name}"
  managed_zone = "${google_dns_managed_zone.test.name}"
  type         = "A"
  ttl          = 300

  rrdatas = ["${element(google_compute_instance.okdinfra.*.network_interface.0.network_ip, count.index)}"]
}

resource "google_dns_record_set" "oknodes" {
  count        = "${var.node_count}"
  name         = "${lookup(var.node_names, count.index)}.${google_dns_managed_zone.test.dns_name}"
  managed_zone = "${google_dns_managed_zone.test.name}"
  type         = "A"
  ttl          = 300

  rrdatas = ["${element(google_compute_instance.okdinfra.*.network_interface.0.network_ip, count.index)}"]
}

resource "google_dns_record_set" "okdlb" {
  name         = "okdlb01.${google_dns_managed_zone.test.dns_name}"
  managed_zone = "${google_dns_managed_zone.test.name}"
  type         = "A"
  ttl          = 300

  rrdatas = ["${google_compute_instance.okdlb.0.network_interface.0.access_config.0.nat_ip}"]
}

resource "google_dns_record_set" "okdweb" {
  name         = "okdweb.${google_dns_managed_zone.test.dns_name}"
  managed_zone = "${google_dns_managed_zone.test.name}"
  type         = "CNAME"
  ttl          = 300

  rrdatas = ["okdlb.${google_dns_managed_zone.test.dns_name}"]
}

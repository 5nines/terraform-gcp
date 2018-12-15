# Compute disk creation
resource "google_compute_disk" "infra-gluster-disk-0-" {
  count       = "${var.infra_count}"
  name        = "${lookup(var.infra_names, count.index)}-gluster-disk-0"
  type        = "pd-standard"
  size        = 50
  zone        = "${var.zone}"
  description = "${lookup(var.infra_names, count.index)} Gluster Disk 0"
}

# resource "google_compute_disk" "infra-docker-vg-" {
#   count = "${var.infra_count}"
#   name  = "infra-docker-vg-${count.index}"
#   type  = "pd-standard"
#   size = 30
#   zone = "${var.zone}"
#   description = "docker-vg"
# }


# resource "google_compute_disk" "master-docker-vg-" {
#   count = "${var.master_count}"
#   name  = "master-docker-vg-${count.index}"
#   type  = "pd-standard"
#   size = 30
#   zone = "${var.zone}"
#   description = "docker-vg"
# }


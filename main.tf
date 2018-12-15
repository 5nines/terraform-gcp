# Instance creation

resource "google_compute_instance" "build" {
  name         = "okdbuild"
  machine_type = "n1-standard-2"
  zone         = "${var.zone}"
  tags         = ["bastion", "ansible", "build"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "10"
    }
  }

  # attached_disk {
  #   source      = "${element(google_compute_disk.master-docker-vg-.*.self_link, count.index)}"
  #   device_name = "${element(google_compute_disk.master-docker-vg-.*.name, count.index)}"
  # }


  // Local SSD disk
  #   scratch_disk {
  #   }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file(var.ssh_public_key_filepath)}"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "echo '--> Updating CentOS System'",
  #     "yum -y update",
  #     "reboot",
  #   ]

  #   connection {
  #     type = "ssh"
  #     private_key = "centos:${file(var.ssh_private_key_filepath)}"
  #   }
  # }
}

resource "google_compute_instance" "okdmasters" {
  count        = "${var.master_count}"
  name         = "${lookup(var.master_names, count.index)}"
  machine_type = "n1-standard-2"
  zone         = "${var.zone}"
  tags         = ["masters"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  # attached_disk {
  #   source      = "${element(google_compute_disk.master-docker-vg-.*.self_link, count.index)}"
  #   device_name = "${element(google_compute_disk.master-docker-vg-.*.name, count.index)}"
  # }


  // Local SSD disk
  #   scratch_disk {
  #   }

  network_interface {
    network = "default"

    # access_config {
    #   // Ephemeral IP
    # }
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file(var.ssh_public_key_filepath)}"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "echo '--> Updating CentOS System'",
  #     "yum -y update",
  #     "reboot",
  #   ]

  #   connection {
  #     type = "ssh"
  #     private_key = "centos:${file(var.ssh_private_key_filepath)}"
  #   }
  # }
}

resource "google_compute_instance" "okdinfra" {
  count        = "${var.infra_count}"
  name         = "${lookup(var.infra_names, count.index)}"
  machine_type = "n1-standard-2"
  zone         = "${var.zone}"
  tags         = ["infra-nodes"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  #   attached_disk {
  #         source      = "${element(google_compute_disk.infra-docker-vg-.*.self_link, count.index)}"
  #         device_name = "${element(google_compute_disk.infra-docker-vg-.*.name, count.index)}"
  #    }

  attached_disk {
    source      = "${element(google_compute_disk.infra-gluster-disk-0-.*.self_link, count.index)}"
    device_name = "${element(google_compute_disk.infra-gluster-disk-0-.*.name, count.index)}"
  }
  network_interface {
    network = "default"

    # access_config {
    #   // Ephemeral IP
    # }
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file(var.ssh_public_key_filepath)}"
  }
}

resource "google_compute_instance" "okdnodes" {
  count        = "${var.infra_count}"
  name         = "${lookup(var.node_names, count.index)}"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["nodes"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "50"
    }
  }

  #   attached_disk {
  #         source      = "${element(google_compute_disk.infra-docker-vg-.*.self_link, count.index)}"
  #         device_name = "${element(google_compute_disk.infra-docker-vg-.*.name, count.index)}"
  #    }


  # attached_disk {
  #       source      = "${element(google_compute_disk.infra-gluster-disk-0-.*.self_link, count.index)}"
  #       device_name = "${element(google_compute_disk.infra-gluster-disk-0-.*.name, count.index)}"
  #  }

  network_interface {
    network = "default"

    # access_config {
    #   // Ephemeral IP
    # }
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file(var.ssh_public_key_filepath)}"
  }
}

resource "google_compute_instance" "okdlb" {
  count        = "1"
  name         = "okdlb01"
  machine_type = "n1-standard-1"
  zone         = "${var.zone}"
  tags         = ["lb"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
      size  = "10"
    }
  }

  #   attached_disk {
  #         source      = "${element(google_compute_disk.infra-docker-vg-.*.self_link, count.index)}"
  #         device_name = "${element(google_compute_disk.infra-docker-vg-.*.name, count.index)}"
  #    }


  # attached_disk {
  #       source      = "${element(google_compute_disk.infra-gluster-disk-0-.*.self_link, count.index)}"
  #       device_name = "${element(google_compute_disk.infra-gluster-disk-0-.*.name, count.index)}"
  #  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file(var.ssh_public_key_filepath)}"
  }
}

# Load balancers
# resource "google_compute_target_pool" "okdweb-pool" {
#   name = "okdweb-instance-pool"


#   instances = [
#     "us-east1-b/okdmaster01",
#     "us-east1-b/okdmaster02",
#   ]


#   health_checks = [
#     "${google_compute_http_health_check.okdweb-health.name}",
#   ]
# }
# resource "google_compute_http_health_check" "okdweb-health" {
#   name               = "okdweb-health-check"
#   request_path       = "/"
#   check_interval_sec = 15
#   timeout_sec        = 2
# }
# resource "google_compute_forwarding_rule" "okdweb-pfr" {
#   name       = "okdweb-forwarding-rule"
#   target     = "${google_compute_target_pool.okdweb-pool.self_link}"
#   port_range = "80"
# }


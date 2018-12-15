variable "zone" {
  default = "us-east1-b"
}
variable "gce_ssh_user" {
  type    = "string"
  default = "centos"
}
variable "ssh_public_key_filepath" {
  description = "Filepath for the ssh public key"
  type        = "string"

  default = "../public_keys/centos.pub"
}

variable "ssh_private_key_filepath" {
  description = "Filepath for the ssh private key"
  type        = "string"

  default = "/home/fivener/.ssh/gcp-centos.pem"
}
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

  provisioner "remote-exec" {
    inline = [
      "echo '--> Updating CentOS System'",
      "sudo yum -y update",
      "sudo yum -y install git nano",
      "sudo reboot",
    ]

    connection {
      type = "ssh"
      private_key = "${file(var.ssh_private_key_filepath)}"
      user = "${var.gce_ssh_user}"
    }
  }
}

output "build_instance_external_ip" {
  description = "The external IP addresses of the build machine instance"
  value       = "${google_compute_instance.build.0.network_interface.0.access_config.0.nat_ip}"
}
variable "ssh_public_key_filepath" {
  description = "Filepath for the ssh public key"
  type        = "string"

  default = "public_keys/centos.pub"
}

variable "gce_ssh_user" {
  type    = "string"
  default = "centos"
}

variable "ssh_private_key_filepath" {
  description = "Filepath for the ssh private key"
  type        = "string"

  default = "~/.ssh/gcp-centos.pem"
}

variable "master_names" {
  default = {
    "0" = "okdmaster01"
    "1" = "okdmaster02"
  }
}

variable "infra_names" {
  default = {
    "0" = "okdinfra01"
    "1" = "okdinfra02"
    "2" = "okdinfra03"
  }
}

variable "node_names" {
  default = {
    "0" = "okdnode01"
    "1" = "okdnode02"
    "2" = "okdnode03"
  }
}

variable "zone" {
  default = "us-east1-b"
}

variable "master_count" {
  default = "2"
}

variable "infra_count" {
  default = "3"
}

variable "node_count" {
  default = "1"
}

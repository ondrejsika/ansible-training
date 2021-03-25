variable "digitalocean_token" {}
variable "cloudflare_api_token" {}

variable "vm_count" {
  default = 2
}

locals {
  zone_id = "f2c00168a7ecd694bb1ba017b332c019"
}


provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  api_token   = var.cloudflare_api_token
}


data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}


resource "digitalocean_droplet" "ansible" {
  image  = "debian-10-x64"
  name   = "ansible"
  region = "fra1"
  size   = "s-4vcpu-8gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]

  connection {
    user = "root"
    type = "ssh"
    host = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get -y install python3 python3-pip",
    ]
  }
}


resource "cloudflare_record" "ansible" {
  zone_id = local.zone_id
  name    = "ansible"
  value   = digitalocean_droplet.ansible.ipv4_address
  type    = "A"
  proxied = false
}


resource "digitalocean_droplet" "vm" {
  count = var.vm_count

  image  = "debian-10-x64"
  name   = "vm${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]

  connection {
    user = "root"
    type = "ssh"
    host = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update",
      "sudo apt-get -y install python3 python3-pip"
    ]
  }
}

resource "cloudflare_record" "vm" {
  count = var.vm_count

  zone_id = local.zone_id
  name    = "vm${count.index}"
  value   = digitalocean_droplet.vm[count.index].ipv4_address
  type    = "A"
  proxied = false
}

variable "do_token" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}

variable "vm_count" {
  default = 2
}

provider "digitalocean" {
  token = var.do_token
}

provider "cloudflare" {
  version = "~> 1.0"
  email = var.cloudflare_email
  token = var.cloudflare_token
}


data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}


resource "digitalocean_droplet" "ansible" {
  image  = "debian-10-x64"
  name   = "ansible"
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
      "sudo apt-get -y install python3 python3-pip",
      "pip3 install ansible",
    ]
  }
}


resource "cloudflare_record" "ansible" {
  domain = "sikademo.com"
  name   = "ansible"
  value  = digitalocean_droplet.ansible.ipv4_address
  type   = "A"
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

  domain = "sikademo.com"
  name   = "vm${count.index}"
  value  = digitalocean_droplet.vm[count.index].ipv4_address
  type   = "A"
  proxied = false
}

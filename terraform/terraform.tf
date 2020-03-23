variable "do_token" {}
variable "cloudflare_email" {}
variable "cloudflare_token" {}

variable "vm_count" {
  default = 1
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


// Main VM for Ansible

resource "digitalocean_droplet" "ansible" {
  count = var.vm_count

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
      "sudo apt-get -y install python3 python3-pip"
    ]
  }
}

resource "cloudflare_record" "ansible" {
  count = var.vm_count

  domain = "sikademo.com"
  name   = "ansible${count.index}"
  value  = digitalocean_droplet.ansible[count.index].ipv4_address
  type   = "A"
  proxied = false
}


// Managed VM 0

resource "digitalocean_droplet" "vm0" {
  count = var.vm_count

  image  = "debian-10-x64"
  name   = "ansible-vm0"
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

resource "cloudflare_record" "vm0" {
  count = var.vm_count

  domain = "sikademo.com"
  name   = "ansible${count.index}-vm0"
  value  = digitalocean_droplet.vm0[count.index].ipv4_address
  type   = "A"
  proxied = false
}


// Managed VM 1

resource "digitalocean_droplet" "vm1" {
  count = var.vm_count

  image  = "debian-10-x64"
  name   = "ansible-vm1"
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

resource "cloudflare_record" "vm1" {
  count = var.vm_count

  domain = "sikademo.com"
  name   = "ansible${count.index}-vm1"
  value  = digitalocean_droplet.vm1[count.index].ipv4_address
  type   = "A"
  proxied = false
}

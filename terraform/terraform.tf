variable "digitalocean_token" {}
variable "cloudflare_api_token" {}

locals {
  lab_count = 1
}

locals {
  zone_id = "f2c00168a7ecd694bb1ba017b332c019"
}

locals {
  ansible_count = local.lab_count
  vm_count      = local.lab_count * 2
}

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}


data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}


resource "digitalocean_droplet" "ansible" {
  count = local.ansible_count

  image  = "debian-10-x64"
  name   = "ansible${count.index}"
  region = "fra1"
  size   = "s-2vcpu-4gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
  user_data = <<EOF
#cloud-config
ssh_pwauth: yes
password: asdfasdf2020
chpasswd:
  expire: false
runcmd:
  - |
    rm -rf /etc/update-motd.d/99-one-click
    apt update
    apt install -y curl sudo git mc tree htop python3 python3-pip
    curl -fsSL https://raw.githubusercontent.com/sikalabs/slu/master/install.sh | sudo sh
    install-slu install -v v0.53.0-dev-4
EOF
}


resource "cloudflare_record" "ansible" {
  count   = local.ansible_count
  zone_id = local.zone_id
  name    = "ansible${count.index}"
  value   = digitalocean_droplet.ansible[count.index].ipv4_address
  type    = "A"
  proxied = false
}


resource "digitalocean_droplet" "vm" {
  count = local.vm_count

  image  = "debian-10-x64"
  name   = "vm${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
  user_data = <<EOF
#cloud-config
ssh_pwauth: yes
password: asdfasdf2020
chpasswd:
  expire: false
runcmd:
  - |
    rm -rf /etc/update-motd.d/99-one-click
    apt update
    apt install -y curl sudo git mc tree htop python3 python3-pip
    curl -fsSL https://raw.githubusercontent.com/sikalabs/slu/master/install.sh | sudo sh
    install-slu install -v v0.53.0-dev-4
EOF
}

resource "cloudflare_record" "vm" {
  count = local.vm_count

  zone_id = local.zone_id
  name    = "vm${count.index}"
  value   = digitalocean_droplet.vm[count.index].ipv4_address
  type    = "A"
  proxied = false
}

output "ips" {
  value = merge(
    {
      for i in range(local.ansible_count) :
      cloudflare_record.vm[i].hostname => cloudflare_record.vm[i].value
    },
    {
      for i in range(local.vm_count) :
      cloudflare_record.vm[i].hostname => cloudflare_record.vm[i].value
    }
  )
}

output "ansible-hosts" {
  value = {
    "all" : {
      "hosts" : cloudflare_record.vm.*.hostname
    }
  }
}

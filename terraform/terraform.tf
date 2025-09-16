variable "digitalocean_token" {}
variable "cloudflare_api_token" {}

locals {
  zone_id  = "f2c00168a7ecd694bb1ba017b332c019"
  vm_count = 2
  vm_size  = "s-1vcpu-512mb-10gb"
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

resource "digitalocean_droplet" "vm" {
  count = local.vm_count

  image  = "debian-12-x64"
  name   = "vm${count.index}"
  region = "fra1"
  size   = local.vm_size
  ssh_keys = [
    data.digitalocean_ssh_key.ondrejsika.id
  ]
  user_data = <<EOF
#cloud-config
ssh_pwauth: yes
password: asdfasdf2020
chpasswd:
  expire: false
ssh_authorized_keys:
  # Ondrej Sika
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslNKgLyoOrGDerz9pA4a4Mc+EquVzX52AkJZz+ecFCYZ4XQjcg2BK1P9xYfWzzl33fHow6pV/C6QC3Fgjw7txUeH7iQ5FjRVIlxiltfYJH4RvvtXcjqjk8uVDhEcw7bINVKVIS856Qn9jPwnHIhJtRJe9emE7YsJRmNSOtggYk/MaV2Ayx+9mcYnA/9SBy45FPHjMlxntoOkKqBThWE7Tjym44UNf44G8fd+kmNYzGw9T5IKpH1E1wMR+32QJBobX6d7k39jJe8lgHdsUYMbeJOFPKgbWlnx9VbkZh+seMSjhroTgniHjUl8wBFgw0YnhJ/90MgJJL4BToxu9PVnH
  # Lab
  - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClalhUbYLKno7EPL8zsPj7pabTMGoyY/Ky88GK28SPVvxEy83vlv6fKlLYm8dTm4pWBtqJ0jPkmzgGFsavaV1BuX302qKa+v/Sv+ykC2k9zB0TV/2vkon8VkZoR2Tlyxp0NQ4V7CH9V1NUQxNdYhbQPeBxXwK7bgvwDHXgDKtgfsMt4Ij1r/my++5Cr3ZHtDTYb560wpIIggiZ6t/NsAjyepPc+ZbZkDzrui2A5T7g1OXtdq4nG1XDCffN3shL+hjj3AAjgNs6dVm/zAKIKGwNgOTwftLJv47JkcQe901G0eM10Ts5DpIJQPW/XTJUSj65BwjhY7Y/3YMdnxHrgcTbNKacFpgbdpFfCJ1ghdGmw+A4pp5DNB7YgEeDRJ3QIWuueif3SX2zeGi4Cm39kCUyS5ziJgePTvzGCspFvp4ox5Xm9phatyN7DsCNWvRI6w1cjcZFRn3Um6CFcXm5Sjs8wgafNVm88BzJRkQFCW04bO5qAj4x1HuZYhBNdWqOvgs=
runcmd:
  - |
    rm -rf /etc/update-motd.d/99-one-click
    apt update
    apt install -y curl sudo git mc tree htop python3 python3-pip
    curl -fsSL https://raw.githubusercontent.com/sikalabs/slu/master/install.sh | sudo sh
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

resource "cloudflare_record" "vm_wildcard" {
  count = local.vm_count

  zone_id = local.zone_id
  name    = "*.${cloudflare_record.vm[count.index].name}"
  value   = cloudflare_record.vm[count.index].hostname
  type    = "CNAME"
  proxied = false
}

output "ips" {
  value = merge(
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

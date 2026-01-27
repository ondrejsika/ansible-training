locals {
  zone_id = "f2c00168a7ecd694bb1ba017b332c019" // zone sikademo.com

  vm_prefixes = concat(flatten([
    for lab_n in range(local.lab_count) :
    [
      for vm_n in range(local.vm_count) :
      "lab${lab_n}-vm${vm_n}"
    ]
  ]), local.extra_vm_prefixes)
}

data "digitalocean_ssh_key" "ondrejsika" {
  name = "ondrejsika"
}

resource "digitalocean_droplet" "vm" {
  for_each = toset(local.vm_prefixes)

  image  = "debian-13-x64"
  name   = each.key
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
  - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPkABc2RE2nmH/w0Sm3VE2SrQxlj71uBMqORAIyIUftv ondrejsika_lab
runcmd:
  - |
    rm -rf /etc/update-motd.d/99-one-click
    apt update
    apt install -y curl sudo git mc tree htop python3 python3-pip
    curl -fsSL https://raw.githubusercontent.com/sikalabs/slu/master/install.sh | sudo sh
EOF
}

resource "cloudflare_record" "vm" {
  for_each = toset(local.vm_prefixes)

  zone_id = local.zone_id
  name    = each.key
  value   = digitalocean_droplet.vm[each.key].ipv4_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "vm_wildcard" {
  for_each = toset(local.vm_prefixes)

  zone_id = local.zone_id
  name    = "*.${cloudflare_record.vm[each.key].name}"
  value   = cloudflare_record.vm[each.key].hostname
  type    = "CNAME"
  proxied = false
}

output "ips" {
  value = merge(
    {
      for prefix in local.vm_prefixes :
      cloudflare_record.vm[prefix].hostname => cloudflare_record.vm[prefix].value
    }
  )
}

output "ansible-hosts" {
  value = {
    "_meta" : {
      "hostvars" : {
        for prefix in local.vm_prefixes :
        cloudflare_record.vm[prefix].hostname => {
          "ansible_host" : cloudflare_record.vm[prefix].value
        }
      }
    },
    "all" : {
      "hosts" : [
        for prefix in local.vm_prefixes :
        cloudflare_record.vm[prefix].hostname
      ]
    }
  }
}

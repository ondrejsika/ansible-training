terraform {
  required_providers {
    awx = {
      source  = "denouche/awx"
      version = "0.15.6"
    }
  }
}

variable "awx_password" {}

provider "awx" {
  hostname = "https://awx.k8s.sikademo.com"
  username = "admin"
  password = var.awx_password
}

data "awx_organization" "default" {
  name = "Default"
}

# https://registry.terraform.io/providers/denouche/awx/latest/docs/resources/inventory
resource "awx_inventory" "ondrejsika" {
  name            = "tf-ondrejsika"
  organization_id = data.awx_organization.default.id
}

# https://registry.terraform.io/providers/denouche/awx/latest/docs/resources/host
resource "awx_host" "ondrejsika" {
  for_each = {
    "vm0.sikademo.com" = null
    "vm1.sikademo.com" = null
    "vm2.sikademo.com" = null
    "vm3.sikademo.com" = null
  }
  name         = each.key
  inventory_id = awx_inventory.ondrejsika.id
  enabled      = true
}

# https://registry.terraform.io/providers/denouche/awx/latest/docs/resources/credential_machine
resource "awx_credential_machine" "default" {
  organization_id     = data.awx_organization.default.id
  name                = "tf-default"
  ssh_key_data        = <<EOF
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQEAruIo95FaY4j+QxWH9G7E8yjPAsBbHyGDe56TDh4JqzuCFk9iGr4R
JAlzKY4affv2wCkwpBMaa7lBlQcBO/ftn/F/Di15joWtzVk0/Kr8ZbhSq3PCJfCjoNKXsL
Hy6Y0rYej3UY1ic1C0Nv3+6nfcX+cCt6B/huwYav14M+2JExABe3flTF2qDjU8hXFSj1L+
ie+5xPk0xnJq8sYxlz1CKuyG/jwU7mMLAlRemFB+AD0+H14dXFqqohKzoNn5lh0Ig63iTb
09aVqmu6SucHSAwLKSKzy8tjyVP00oxoTPgTA7KahU2qIEm7E42YKYlxG+ppRaIY3xonqa
NeSUV4FT+QAAA7hY/UWjWP1FowAAAAdzc2gtcnNhAAABAQCu4ij3kVpjiP5DFYf0bsTzKM
8CwFsfIYN7npMOHgmrO4IWT2IavhEkCXMpjhp9+/bAKTCkExpruUGVBwE79+2f8X8OLXmO
ha3NWTT8qvxluFKrc8Il8KOg0pewsfLpjSth6PdRjWJzULQ2/f7qd9xf5wK3oH+G7Bhq/X
gz7YkTEAF7d+VMXaoONTyFcVKPUv6J77nE+TTGcmryxjGXPUIq7Ib+PBTuYwsCVF6YUH4A
PT4fXh1cWqqiErOg2fmWHQiDreJNvT1pWqa7pK5wdIDAspIrPLy2PJU/TSjGhM+BMDspqF
TaogSbsTjZgpiXEb6mlFohjfGiepo15JRXgVP5AAAAAwEAAQAAAQAsDcKeIppvamoKghj+
ZQzt6ADFw6jwnaOed2K58q0i2lm5vwOKkwiEWHEPLcHUrK0K2RVsr3c/Xap8nQgdkCXm3Z
HRA3mUgm42xVsIrxXnldgVYpKstgKyF3qowxra5HniLypl+8SqIdFT7QXTEKCN9AaGNUMK
vNylzvYBtruJ9lqR9jIvVLcutmwEsadNB2R322ZMvQ7SDEMxaEeYEBUdn2JnSkwedNWYSh
8+tVZr/LrdLdEx1tEBXZA/PpRfHD4xqPmVrPxn9WVy0rzEHPnQyT1s0s61uzJ/f7hEXaEF
khyPqcIE81bI6AKfYZ/4aJi8OnCnnv/KrJkKtgGSNZ4RAAAAgFl+ERK3MUr0HDqVwJ7WhF
g+72/SVQAcv7opG9r/Qkud3Umn78atK+5AqyKGsYkRL1vCPS4T8uTcIG686SJ6LVFqTVAi
CMY75du9vIiUj2pKdhRejsUECbALiS7fCMmh92OxJ2rVyBb9U4+ZbWeOlYYnqhZ7vS2VHA
r5pZAdr0mYAAAAgQDaRHzJr1ew4ZayL2D+30OgqCb8kAC79vpNysWMY6uwfQmgmbOBtEUe
yArkoWcQmqDjVeMIaj6rDkEA2Hi9cY+eM1bLdecPXhHN22GqyznVVBAFKpnO31/YH9QDJ4
v74CPx/FJbIJhKQjtJti/g0UsZh/PTyRCMYyNBZo56P7VZ3QAAAIEAzR2xbuwzucLC4HFs
NEK2Kh3j35VG8U+xWGmWqDRVXorxJnS2LIeunWu2E7dLWZ7vyG+vvJwEGt3K8YaaZgf6w4
Z8qHzFwcrvUhqcTuLfTifA3PQ6PC+voFDzo1EhRxLFoqOB5TdDtiiqDzcbFwOflNcfetqw
e9CSIx72Y+bG9s0AAAAAAQID
-----END OPENSSH PRIVATE KEY-----
EOF
  ssh_public_key_data = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCu4ij3kVpjiP5DFYf0bsTzKM8CwFsfIYN7npMOHgmrO4IWT2IavhEkCXMpjhp9+/bAKTCkExpruUGVBwE79+2f8X8OLXmOha3NWTT8qvxluFKrc8Il8KOg0pewsfLpjSth6PdRjWJzULQ2/f7qd9xf5wK3oH+G7Bhq/Xgz7YkTEAF7d+VMXaoONTyFcVKPUv6J77nE+TTGcmryxjGXPUIq7Ib+PBTuYwsCVF6YUH4APT4fXh1cWqqiErOg2fmWHQiDreJNvT1pWqa7pK5wdIDAspIrPLy2PJU/TSjGhM+BMDspqFTaogSbsTjZgpiXEb6mlFohjfGiepo15JRXgVP5
EOF
}

# https://registry.terraform.io/providers/denouche/awx/latest/docs/resources/project
resource "awx_project" "example-1" {
  name                 = "tf-example-1"
  scm_type             = "git"
  scm_url              = "https://gitlab.sikalabs.com/demo/awx-example-1.git"
  scm_branch           = "main"
  scm_update_on_launch = true
  organization_id      = data.awx_organization.default.id
}

# https://registry.terraform.io/providers/denouche/awx/latest/docs/resources/job_template
resource "awx_job_template" "docker" {
  name           = "docker-example"
  job_type       = "run"
  inventory_id   = awx_inventory.ondrejsika.id
  project_id     = awx_project.example-1.id
  playbook       = "playbooks/docker.yml"
  become_enabled = true
}

# https://registry.terraform.io/providers/denouche/awx/latest/docs/resources/job_template_credential
resource "awx_job_template_credential" "docker" {
  job_template_id = awx_job_template.docker.id
  credential_id   = awx_credential_machine.default.id
}

# https://registry.terraform.io/providers/denouche/awx/latest/docs/resources/schedule
resource "awx_schedule" "docker" {
  name                    = "docker"
  rrule                   = "DTSTART;TZID=Europe/Prague:20220101T000000 RRULE:INTERVAL=1;FREQ=MINUTELY"
  unified_job_template_id = awx_job_template.docker.id
  inventory               = awx_inventory.ondrejsika.id
}

terraform {
  required_providers {
    awx = {
      source  = "denouche/awx"
      version = "0.15.6"
    }
  }
}

variable "awx_hostname" {}
variable "awx_username" {}
variable "awx_password" {}

provider "awx" {
  hostname = var.awx_hostname
  username = var.awx_username
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
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
NhAAAAAwEAAQAAAYEApWpYVG2Cyp6OxDy/M7D4+6Wm0zBqMmPysvPBitvEj1b8RMvN75b+
nypS2JvHU5uKVgbaidIz5Js4BhbGr2ldQbl99Nqimvr/0r/spAtpPcwdE1f9r5KJ/FZGaE
dk5csadDUOFewh/VdTVEMTXWIW0D3gcV8Cu24L8Ax14AyrYH7DLeCI9a/5svvuQq92R7Q0
2G+etMKSCIIImerfzbAI8nqT3PmW2ZA867otgOU+4NTl7XauJxtVwwn3zd7IS/oY49wAI4
DbOnVZv8wCiChsDYDk8H7Syb+OyZHEHvdNRtHjNdE7OQ6SCUD1v10yVEo+uQcI4WO2P92D
HZ8R64HE2zSmnBaYG3aRXwidYIXRpsPgOKaeQzQe2IBHg0Sd0CFrrnon90l9s3houApt/Z
AlMkuc4iYHj078xgrKRb6eKMeV5vaYWrcjew7AjVr0SOsNXI3GRUZ91JughXF5uUo7PMIG
nzVZvPAcyUZEBQltOGzuagI+MdR7mWIQTXVqjr4LAAAFkDmtAbA5rQGwAAAAB3NzaC1yc2
EAAAGBAKVqWFRtgsqejsQ8vzOw+PulptMwajJj8rLzwYrbxI9W/ETLze+W/p8qUtibx1Ob
ilYG2onSM+SbOAYWxq9pXUG5ffTaopr6/9K/7KQLaT3MHRNX/a+SifxWRmhHZOXLGnQ1Dh
XsIf1XU1RDE11iFtA94HFfArtuC/AMdeAMq2B+wy3giPWv+bL77kKvdke0NNhvnrTCkgiC
CJnq382wCPJ6k9z5ltmQPOu6LYDlPuDU5e12ricbVcMJ983eyEv6GOPcACOA2zp1Wb/MAo
gobA2A5PB+0sm/jsmRxB73TUbR4zXROzkOkglA9b9dMlRKPrkHCOFjtj/dgx2fEeuBxNs0
ppwWmBt2kV8InWCF0abD4DimnkM0HtiAR4NEndAha656J/dJfbN4aLgKbf2QJTJLnOImB4
9O/MYKykW+nijHleb2mFq3I3sOwI1a9EjrDVyNxkVGfdSboIVxeblKOzzCBp81WbzwHMlG
RAUJbThs7moCPjHUe5liEE11ao6+CwAAAAMBAAEAAAGAQaRE7yQSDgQD1Z3hpkqpU3t2C0
KgMeT1z8vpVwhFJTi4nThfPZ+m5VSvUaPn4qbLq73GhYCz9Rkfj1MEf2GJj2ZjtIH6mxPV
5zUgXCznE43nT+DQHBdDyK4X/JOwV3xUwB65uztcdaNsvvhrO9iMAxE6+uJgPC68cAMR19
pPO9ix7Ye38f9mUH+nGjF095lsiyMoUMURnGy1qxbIv2AG/OpluQAWu7mAY28bVZYjcKcr
oyNAkuZHD0HqY3jv9S6GhHeCcEB5KtC8aCUjmuPzinfefCUwW5YIX78BPabpAN4YqgcI6V
o/la3LmKDT3r+17NhHUdBbM+PnnIXie3+RCLJ/cneOpzVYcuGN6EEMCY3FIqdMu8ESk7o/
DB0jLkjWk9XKKxf/gS1mCUJ1U/ufPWa3cTwgSvlB3ikvA05iO5M9x5Q+SJbzqIAdo770qX
ImRuH4X3iqq+9rdwz1N8tOBkaCOTSrFOh24olHJ8KyIVlqxdYFhzjqrfWihRYvT5H5AAAA
wFClZMLJ2jjkl8c24c1kdVWJt19FGD86G1B8HNbqmpTUU56vh48IYtO3lkGBCkgdLa0vw8
SAakVVm1awcLxgDslaFAJ6sLjpIWIBEwFZ+KQEfnntvkUMxBhVFD9RSMFysWY9/jy0Pb8H
Fft36xmOKcykfJh0hhK7Kgev+hzuX7P6sVkUb5r3pr9Phw6MYiVK4/6LeblY1YZALN3IMn
WOYky4Xyme5Of8xfhlG9zImDbqCkr8q3P1KFkAMhzlJHkT+wAAAMEA2c1zBiHWrRgV51IW
iLTNlplGYIAIoMgLu1qPn6ueCXDGaLzRcQi1zwuzUKifSZTJBi7U28ksOPO660BC900NMl
4nytfPWhbekQjDiUd4q7WwTeJer/Eqsjw6UXSEoWjdvq4h8qr8VOsGPmvuQZAJxuj3IsP5
jS0oWUnNE7eg15px4C4wEnarZqVi/zFOqRfoOXWC9FmsKwr8W6quF8fbTOmq9eALbig2Bf
jwiwrd7gCczMkuHOtZ8omMg+jyQHyXAAAAwQDCbOby6sCFWke+q8qgyoDcZafz+pxwbUUp
aNYNXY3LMZe5vX7kT8GNXLqvtSuAjzOGbbv4OD3lGYcljJmv3KwAkVpqm2QE7gdv2KV3JF
GIeBYulYR1pPPOkmDmcv7gYtkxicHLOtqKOBGkwiLx9ob1o0WHHy6/MN9JteJEw/MwQ8wG
/8nLKwmNa4URib69sRvkyvWbbh8xl2tkHWVb/UNJXddE5ql+BjkBX6NWJVMT2u3WgRgP9w
B9fXeuumLPVK0AAAAVb25kcmVqQHNpa2EtbWFjLmxvY2FsAQIDBAUG
-----END OPENSSH PRIVATE KEY-----
EOF
  ssh_public_key_data = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClalhUbYLKno7EPL8zsPj7pabTMGoyY/Ky88GK28SPVvxEy83vlv6fKlLYm8dTm4pWBtqJ0jPkmzgGFsavaV1BuX302qKa+v/Sv+ykC2k9zB0TV/2vkon8VkZoR2Tlyxp0NQ4V7CH9V1NUQxNdYhbQPeBxXwK7bgvwDHXgDKtgfsMt4Ij1r/my++5Cr3ZHtDTYb560wpIIggiZ6t/NsAjyepPc+ZbZkDzrui2A5T7g1OXtdq4nG1XDCffN3shL+hjj3AAjgNs6dVm/zAKIKGwNgOTwftLJv47JkcQe901G0eM10Ts5DpIJQPW/XTJUSj65BwjhY7Y/3YMdnxHrgcTbNKacFpgbdpFfCJ1ghdGmw+A4pp5DNB7YgEeDRJ3QIWuueif3SX2zeGi4Cm39kCUyS5ziJgePTvzGCspFvp4ox5Xm9phatyN7DsCNWvRI6w1cjcZFRn3Um6CFcXm5Sjs8wgafNVm88BzJRkQFCW04bO5qAj4x1HuZYhBNdWqOvgs=
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

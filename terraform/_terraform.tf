terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

variable "digitalocean_token" {}
variable "cloudflare_api_token" {}

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

terraform {
  cloud {
    organization = "STUDENT-9VxF"

    workspaces {
      name = "day1"
    }
  }
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.22.0"
    }
  }
}
provider "bigip" {
  address  = "https://${var.address}:${var.port}"
  username = var.username
  password = var.password
}

resource "bigip_ltm_monitor" "monitor" {
  name   = "/Common/terraform_monitor"
  parent = "/Common/http"
}
resource "bigip_ltm_pool" "pool" {
  name                   = "/Common/Axiom_Environment_APP1_Pool"
  load_balancing_mode    = "round-robin"
  minimum_active_members = 1
  monitors               = [bigip_ltm_monitor.monitor.name]

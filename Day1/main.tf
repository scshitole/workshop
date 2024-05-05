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
  name     = "/Common/terraform_monitor"
  parent   = "/Common/http"
  send     = "GET /some/path\r\n"
  timeout  = "999"
  interval = "999"
}

resource "bigip_ltm_pool" "pool" {
  name                = "/Common/terraform-pool"
  load_balancing_mode = "round-robin"
  nodes               = ["10.0.0.171:80"]
  monitors            = ["/Common/terraform_monitor"]
  allow_snat          = "yes"
  allow_nat           = "yes"
}

resource "bigip_ltm_virtual_server" "http" {
  pool                       = "/Common/terraform-pool"
  name                       = "/Common/terraform_vs_http"
  destination                = "10.0.1.100"
  port                       = 8080
  source_address_translation = "automap"
  depends_on                 = ["bigip_ltm_pool.pool"]
}

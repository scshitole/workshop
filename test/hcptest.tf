terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.28.0"
    }
  }
}

provider "tfe" {
  hostname = "app.terraform.io"
}

resource "random_string" "pre" {
  count  = 30
  length = 4
  special = false
}

resource "tfe_organization" "org" {
  count       = 30
  name        = "F5-WORKSHOP-${count.index}"
  email = "s.shitole@f5.com"
}

resource "tfe_workspace" "myworkspace" {
  count        = 30
  name         = "STUDENT-${random_string.pre[count.index].result}"
  organization = tfe_organization.org[count.index].name
  tag_names    = ["workshop"]
}

output "Your_Workshop_HCP_Org" {
  value = tfe_organization.org[*].name
}

output "Your_Workspace_configured" {
  value = tfe_workspace.myworkspace[*].name
}

output "prefixes" {
  value = random_string.pre[*].result
}


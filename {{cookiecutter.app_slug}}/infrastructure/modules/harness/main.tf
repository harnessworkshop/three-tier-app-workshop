terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9.0"
    }
    harness = {
      source  = "harness/harness"
      version = "0.35.4"
    }
  }
}

locals {
  # Replace hyphens with underscores for the connector identifier
  connector_identifier = replace(var.cluster_name, "-", "_")
  # Replace hyphens with underscores and prepend underscore for delegate name
  delegate_name = "_${replace(var.delegate_name, "-", "_")}"
}

module "harness-delegate" {
  source  = "harness/harness-delegate/kubernetes"
  version = "0.2.0"

  account_id       = var.account_id
  delegate_token   = var.delegate_token
  delegate_name    = var.delegate_name
  namespace        = "harness-delegate-ng"
  manager_endpoint = var.manager_endpoint
  delegate_image   = var.delegate_image
  replicas         = 1
  upgrader_enabled = false

  # Additional optional values to pass to the helm chart
  values = yamlencode({
    initScript: ""
  })
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

resource "harness_platform_connector_kubernetes" "inheritFromDelegate" {
  identifier = "${var.cluster_name}_connector"
  name       = "${var.cluster_name} K8s Connector"
  org_id     = "training"

  inherit_from_delegate {
    delegate_selectors = ["${var.delegate_name}"]
  }
}
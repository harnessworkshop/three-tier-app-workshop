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

# Add these input variables to track dependencies
variable "eks_cluster_id" {
  description = "EKS cluster ID to track dependency"
  type        = string
}

variable "rds_instance_id" {
  description = "RDS instance ID to track dependency"
  type        = string
}

variable "rds_endpoint" {
  description = "RDS database endpoint"
  type        = string
}

variable "db_name" {
  description = "RDS database name"
  type        = string
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

  depends_on = [var.eks_cluster_id]
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_ca_cert)
    token                  = var.cluster_token
  }
}

resource "harness_platform_connector_kubernetes" "inheritFromDelegate" {
  identifier = "${var.cluster_name}_connector"
  name       = "${var.cluster_name} K8s Connector"
  org_id     = "training"

  inherit_from_delegate {
    delegate_selectors = ["${var.delegate_name}"]
  }

  depends_on = [module.harness-delegate, var.rds_instance_id]
}

resource "harness_platform_pipeline" "pipeline" {
  identifier = "three_tier_app_blueprint_template"
  org_id     = "training"
  project_id = var.harness_project_name
  name       = "three_tier_app_blueprint_template"
  yaml = <<-EOT
    pipeline:
      name: three_tier_app_blueprint_template
      identifier: three_tier_app_blueprint_template
      tags: {}
      template:
        templateRef: org.three_tier_app_blueprint_template
        versionLabel: "1"
        templateInputs:
          stages:
            - stage:
                identifier: backend_deploy
                type: Deployment
                spec:
                  environment:
                    infrastructureDefinitions:
                      - identifier: dev
                        inputs:
                          identifier: dev
                          type: KubernetesDirect
                          spec:
                            connectorRef: "org.${var.cluster_name}_connector"
                  deploymentType: Kubernetes
                  services:
                    values:
                      - serviceRef: org.three_tier_app
                        serviceInputs:
                          serviceDefinition:
                            type: Kubernetes
                            spec:
                              manifests:
                                - manifest:
                                    identifier: k8_three_tier_app
                                    type: K8sManifest
                                    spec:
                                      store:
                                        type: Github
                                        spec:
                                          repoName: "${var.github_repo_name}"
          properties:
            ci:
              codebase:
                repoName: "${var.github_repo_name}"
                build:
                  type: branch
                  spec:
                    branch: main
          variables:
            - name: namespace
              type: String
              value: "${var.namespace}"
      projectIdentifier: "${var.harness_project_name}"
      orgIdentifier: training
  EOT
}

resource "harness_platform_triggers" "github_trigger" {
  identifier = "${var.github_repo_name}trigger"
  org_id     = "training"
  project_id = var.harness_project_name
  name       = "${var.github_repo_name}trigger"
  target_id  = "three_tier_app_blueprint_template"
  yaml       = <<-EOT
  trigger:
    name: "${var.github_repo_name}trigger"
    identifier: "${var.github_repo_name}trigger"
    enabled: true
    description: ""
    tags: {}
    projectIdentifier: "${var.harness_project_name}"
    orgIdentifier: training
    pipelineIdentifier: "three_tier_app_blueprint_template"
    source:
      type: Webhook
      spec:
        type: Github
        spec:
          type: Push
          spec:
            connectorRef: org.harness_workshop
            autoAbortPreviousExecutions: false
            payloadConditions:
            - key: targetBranch
              operator: Equals
              value: main
            headerConditions: []
            repoName: "${var.github_repo_name}"
            actions: []
    inputYaml: |
      pipeline: {}\n
    EOT

  depends_on = [harness_platform_pipeline.pipeline]
}

resource "harness_platform_variables" "db_host" {
  identifier = "${var.namespace}_db_rds_host"
  name       = "${var.namespace}_db_rds_host"
  org_id     = "training"
  type       = "String"
  spec {
    value_type  = "FIXED"
    fixed_value = var.rds_endpoint
  }
}

resource "harness_platform_variables" "db_name" {
  identifier = "${var.namespace}_db_rds_name"
  name       = "${var.namespace}_db_rds_name"
  org_id     = "training"
  type       = "String"
  spec {
    value_type  = "FIXED"
    fixed_value = var.db_name
  }
}
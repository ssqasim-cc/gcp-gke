provider "google" {
  project = var.project_id
  region  = var.region
}

resource "kubernetes_config_map" "ambassador_config" {
  metadata {
    name = "ambassador-config"
  }

  data = {
    "ambassador.yaml" = "${file(var.ambassador_config_path)}"
  }
}

resource "kubernetes_deployment" "ambassador_deployment" {
  metadata {
    name = "ambassador"
  }

  spec {
    selector {
      match_labels = {
        app = "ambassador"
      }
    }

    template {
      metadata {
        labels = {
          app = "ambassador"
        }
      }

      spec {
        container {
          name  = "ambassador"
          image = "docker.io/datawire/ambassador:1.11.2"

          volume_mount {
            name       = "ambassador-config"
            mount_path = "/etc/ambassador/ambassador.yaml"
            sub_path   = "ambassador.yaml"
            read_only  = true
          }

          port {
            name           = "http"
            container_port = 8080
          }

          port {
            name           = "https"
            container_port = 8443
          }
        }

        volume {
          name = "ambassador-config"

          config_map {
            name = kubernetes_config_map.ambassador_config.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ambassador_service" {
  metadata {
    name = "ambassador"
  }

  spec {
    selector = {
      app = kubernetes_deployment.ambassador_deployment.metadata[0].name
    }

    port {
      name        = "http"
      port        = 80
      target_port = "http"
    }

    port {
      name        = "https"
      port        = 443
      target_port = "https"
    }

    type = "LoadBalancer"
  }
}

output "ambassador_endpoint" {
  value = kubernetes_service.ambassador_service.status[0].load_balancer.ingress[0].ip
}

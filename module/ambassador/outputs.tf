output "ambassador_endpoint" {
  value = kubernetes_service.ambassador_service.status[0].load_balancer.ingress[0].ip
}

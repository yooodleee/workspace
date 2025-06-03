provider "kubernetes" {
  host = var.k8s_host
  token = var.k8s_token
  cluster_ca_certificate = base64decode(var.k8s_ca_cert)
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "terraform-example-namespace"

    annotations = {
      "example.com/created-by" = "terraform"
    }
  }
}

resource "kubernetes_secret" "example" {
  metadata {
    name      = "terraform-example"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  data = {
    password = base64encode("P4ssw0rd")
  }

  type = "Opaque"
}

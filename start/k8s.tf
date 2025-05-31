resource "kubernetes_namespace" "example" {
  metadata {
    name = "terraform-example-namespace"

    annotations = {
      name = "example-annotation"
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

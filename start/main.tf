terraform {
  required_version = ">= 1.0.0"
  required_providers {
    local = {
      source = "hashicorp/local"
      version = ">= 2.0.0"
    }
  }
  cloud {
    hostname = "app.terraform.io"
    organization = "yooodleee-org"
    workspaces {
      name = "my-app-prod"
    }
  }
  # backend "local" {
  #   path = "state/terraform.tfstate"
  # }
}

resource "local_file" "abc" {
  content  = "123!"
  filename = "${path.module}/abc.txt"
}

# resource "aws_instance" "web" {
#   ami = "ami-a1b2c3d4"
#   instance_type = "t3.micro"
# }

resource "local_file" "def" {
  depends_on = [ local_file.abc ]
  content = "456!"
  filename = "${path.module}/def.txt"
}
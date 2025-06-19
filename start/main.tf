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

  lifecycle {
    # create_before_destroy = true
    # prevent_destroy = true
    ignore_changes = [ 
      content
     ]
  }
}

data "local_file" "abc" {
  filename = local_file.abc.filename
}

# resource "aws_instance" "web" {
#   ami = "ami-a1b2c3d4"
#   instance_type = "t3.micro"
# }

resource "local_file" "def" {
  depends_on = [ local_file.abc ]
  content = data.local_file.abc.content
  filename = "${path.module}/def.txt"
}

resource "local_file" "maybe" {
  count = var.file_create ? 1: 0
  content = var.content
  filename = "maybe.txt"
}

variable "file_create" {
  type = bool
  default = true
}

variable "content" {
  description = "If a file is created, check whether its contents are empty."
  default = "default content"
  type = string

  validation {
    condition = var.file_create == true ? length(var.content) > 0 : true
    error_message = "The file content cannot be empty."
  }
}
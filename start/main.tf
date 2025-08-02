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
}

variable "file_create" {
  type = bool
  default = true
}

variable "content" {
  description = "If a file is created, check whether its contents are empty."
  type = string
  default = "default content"

  validation {
    condition = var.file_create == true ? length(var.content) > 0 : true
    error_message = "The file content cannot be empty."
  }
}

resource "local_file" "abc" {
  content  = var.my_password
  filename = "${path.module}/abc.txt"

  lifecycle {
    ignore_changes = [content]
  }
}

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
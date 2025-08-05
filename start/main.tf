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

variable "my_var" {
  default = "var2"
}

variable "prefix" {
  default = "hello"
}

variable "names" {
  default = {
    a = "content a"
    c = "content c"
  }
}

locals {
  name = "terraform"
}

resource "local_file" "abc" {
  for_each = toset(["a", "b", "c"])
  content = "abc"
  filename = "${path.module}/abc-${each.key}.txt"

  lifecycle {
    ignore_changes = [content]
  }
}

resource "local_file" "def" {
  for_each = local_file.abc
  depends_on = [ local_file.abc ]
  content = each.value.content
  filename = "${path.module}/def-${each.key}.txt"
}

resource "local_file" "ghi" {
  content = var.my_var
  filename = "${path.module}/ghi.txt"
}

resource "local_file" "maybe" {
  count = var.file_create ? 1: 0
  content = var.content
  filename = "maybe.txt"
}
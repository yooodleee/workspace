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
  type = list(string)
  default = ["a", "b"]
}

locals {
  name = "terraform"
}

resource "local_file" "abc" {
  content = jsonencode([for s in var.names: upper(s)]) # ["A", "B", "C"]
  filename = "${path.module}/abc.txt"

  lifecycle {
    ignore_changes = [content]
  }
}

resource "local_file" "def" {
  depends_on = [ local_file.abc ]
  content = jsonencode([for s in var.names: upper(s)]) # ["A", "B", "C"]
  filename = "${path.module}/def.txt"
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

output "A_upper_value" {
  value = [for v in var.names: upper(v)]
}

output "B_index_and_value" {
  value = [for i, v in var.names: "${i} is ${v}"]
}

output "C_make_object" {
  value = {for v in var.names: v => upper(v)}
}

output "D_with_filter" {
  value = [for v in var.names: upper(v) if v != "a"]
}
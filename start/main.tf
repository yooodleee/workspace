resource "local_file" "abc" {
content = "abc!"
filename = "${path.module}/abc.txt"
}

resource "local_file" "def" {
content = "def!"
filename = "#{path.module}/def.txt"
}
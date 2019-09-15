locals {
  ssh = {
    key = "~/.ssh/id_rsa",
    authorized_keys = [
      "~/.ssh/authorized_keys",
      "~/.ssh/id_rsa.pub",
    ]
  }
}


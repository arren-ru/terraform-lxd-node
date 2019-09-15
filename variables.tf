variable "name" {
  type = string
}

variable "from" {
  type = string
  default = "images:archlinux"
}

variable "profiles" {
  type = list(object({ name = string }))
  default = []
}

variable "volumes" {
  type = object({ pool = object({ name = string }), mounts = map(string) })
  default = {
    pool = {
      name = ""
    }
    mounts = {}
  }
}

variable "files" {
  type = map(string)
  default = {}
}

variable "exec" {
  type = list(string)
  default = []
}


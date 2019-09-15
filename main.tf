resource "lxd_volume" "volume" {
  for_each = { for k, v in var.volumes.mounts : k => v if substr(k, 0, 1) != "/" }
  pool     = var.volumes.pool.name
  name     = format("%s_%s", var.name, basename(each.key))
}

resource "lxd_container" "node" {
  name     = var.name
  image    = var.from
  profiles = var.profiles[*].name

  dynamic "device" {
    for_each = { for k, v in var.volumes.mounts : k => v if v != null }
    content {
      type       = "disk"
      name       = format("disk-%s", basename(device.key))
      properties = {
        path   = device.value
        source = substr(device.key, 0, 1) != "/" ? lxd_volume.volume[device.key].name : device.key
        pool   = substr(device.key, 0, 1) != "/" ? lxd_volume.volume[device.key].pool : null
      }
    }
  }

  dynamic "file" {
    for_each = merge({
      "/root/.ssh/authorized_keys" = join("\n", [for path in local.ssh.authorized_keys : chomp(file(path))])
    }, var.files)

    content {
      target_file        = file.key
      content            = file.value
      create_directories = true
      mode               = "0644"
      uid                = 0
      gid                = 0
    }
  }

  connection {
    host        = lxd_container.node.ip_address
    private_key = file(local.ssh.key)
    timeout     = "10s"
  }

  provisioner "remote-exec" {
    inline = var.exec
  }
}


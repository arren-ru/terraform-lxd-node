# Terraform LXD Node module

Module is useful for shot declaration of LXD nodes.

`node.tower.tf`
```tf
module "node_tower" {
  source = "github.com/arren-ru/terraform-lxd-node"

  # Name of the resulting container
  name = "tower"

  # Image to build from
  from = "node/tower"

  # Profiles to attach to container (could be useful when you need add some capability or override devices)
  # i.e. make macvlan adapter to have static MAC to get reserved IP address form DHCP
  profiles = [
    lxd_profile.default,
  ]

  # Volumes to mount to container
  volumes = {
    pool = lxd_storage_pool.default     # pool needed to create volumes
    mounts = {
      "vault"        = "/var/lib/vault" # will create volume 'tower_vault' and mount to '/var/lib/vault'
      "/mnt/vault"   = "/mnt"           # will mount '/mnt/vault' from host to container '/mnt'
    }
  }

  # Files will be pushed before container start
  # Also files directive silently adds public keys from '~/.ssh/id_rsa.pub' and '~/.ssh/authorized_keys'
  # means that who have access to the host should have access to the containers as well
  files = {
    "/etc/vault.hcl" = templatefile("templates/vault.hcl", var.secrets)
  }

  # Execute provision commands via SSH using key '~/.ssh/id_rsa' after container started
  # basically, your image must have enabled sshd service for that
  exec = [
    "uptime",
  ]
}
```


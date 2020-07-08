variable public_key_path {
  description = "Path to the public key used for ssh access"
}
variable subnet_id {
  description = "Subnet"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default = "reddit-app"
}
variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}
variable puma_service {
  # Описание переменной
  description = "Path to puma.service unit-file"
}
variable deploy_script {
  # Описание переменной
  description = "Path to deploy.sh"
}

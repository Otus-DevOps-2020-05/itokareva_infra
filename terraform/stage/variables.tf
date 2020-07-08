variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  # Описание переменной
  description = "Path to the private key used for ssh access"
}
variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet"
}
variable service_account_key_file {
  description = "key .json"
}
variable account_id {
  description = "service account id"
}
variable counter {
  description = "instance array counter"
}
variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app"
}
variable db_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-db"
}
variable puma_service {
  # Описание переменной
  description = "Path to puma.service unit-file"
}
variable deploy_script {
  # Описание переменной
  description = "Path to deploy.sh"
}

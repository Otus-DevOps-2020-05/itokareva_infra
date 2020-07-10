resource "yandex_compute_instance" "app" {
  name = "reddit-app"

  labels = {
    tags = "reddit-app"
  }
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = var.app_disk_image
    }
  }

  network_interface {
#    subnet_id = yandex_vpc_subnet.app-subnet.id
    subnet_id = var.subnet_id
    nat = true
  }

  metadata = {
  ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }
}
resource "null_resource" "deploy_reddit" {
#  %{ if var.do_deploy == true ~}

count = "${var.do_deploy == true ? 1 : 0}"

  connection {
    type  = "ssh"
    host  = yandex_compute_instance.app.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "../modules/app/puma.service"
    destination = "/tmp/puma.service"
#    on_failure = continue
  }

  provisioner "remote-exec" {
    inline = ["export DATABASE_URL=${yandex_compute_instance.app.network_interface.0.ip_address}"]
#    on_failure = continue
  }

  provisioner "remote-exec" {
    script = "../modules/app/deploy.sh"
#    on_failure = continue
  }

#%{ endif ~}

}

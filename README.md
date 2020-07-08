# itokareva_infra
itokareva Infra repository
#Домашняя работа 5
bastion_IP = 130.193.50.9
someinternalhost_IP = 10.130.0.15
# Домашняя работа 6
testapp_IP = 84.201.175.66
testapp_port = 9292
# Самостоятельная работа
# install_ruby.sh install_mongodb.sh deploy.sh
# Дополнительное задание
# create_ycvm.sh metadata.yaml http://84.201.159.22:9292/

# Домашняя работа 7
# packer/ubuntu16.json - конфигурационный файл для создания образа ВМ с предустановленными ruby и mongodb
# packer/immutable.json - 'bake' образ ВМ: все зависимости приложения и сам код приложения
# packer/variables.json - переменные для обоих шаблонов (git ignore)
# config-scripts/create-reddit-vm.sh - скрипт создания ВМ из образа (с предустановленными ruby и mongodb)

# Домашняя работа 8

# terraform/main.tf - основной конфигурационный файл для развертывания VM с предустановленным приложением PUMA
# terraform/main_arr.tf - конфигурационный файл для развертывания коллекции VM с предустановленным приложенем Puma
# lb.tf - конфигурационный файл для создания целеой группы VM для балансировки и самого балансировщика

# Домашняя работа 9

# packer/app.json - конфигурационный файл для создания образа ВМ с предустановленными ruby
# packer/db.json - конфигурационный файл для создания образа ВМ с предустановленными mongodb
# terraform/modules/app  - каталог модуля app
#                   main.tf - основной конфигурационный файл модуля app
#                   puma.service - файл для заброски в приложение, используется provisioner "file"
#                   deploy.sh - скрипт для выполнения на вм app, устанавливающий приложение reddit и поднимающий сервис puma, используется в
#                   provisioner "remote-exec"
# terraform/modules/db - каталог модуля db
#                   main.tf - основной конфигурационный файл модуля db
# terraform/modules/vpc - каталог модуля vpc. Этот модуль создает сеть и подсеть

# Каталоги для развертывания stage и prod площадок с использованием модулей:
# terraform/prod
# terraform/stage
# main.tf - в каждом каталоге - основной конфигурационный файл вызывающий модули app, db, vpc (vpc - в двнном случае загружается, но не используется в
# модулях app и db, там настройки ip передаются через переменную. vpc - в данном случае, заглушка для trevis, чтобы пройти тест)
# state - находится в object storage в yandex облаке.
# backend.tf - конфигурация state.
# sudo /usr/local/bin/terraform init -backend-config=backend.tf

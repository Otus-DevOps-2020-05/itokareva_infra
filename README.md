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

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

# Домашняя работа 10

Знакомство с Ansible

1) Установлен ansible 2.9.10, Python 2.7.17

2) Тестируем playbook:

a) репозиторий reddit был установлен на appserver, поэтому changed=0

ansible-playbook clone.yml

PLAY [Clone] ********************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [appserver]

TASK [Clone repo] ***************************************************************************************************************************************************************************
ok: [appserver]

PLAY RECAP **********************************************************************************************************************************************************************************
appserver                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ansible app -m shell -a 'ls -la ~/reddit warn=no'
appserver | CHANGED | rc=0 >>
total 56
drwxrwxr-x 5 ubuntu ubuntu 4096 Jul 12 11:39 .
drwxr-xr-x 6 ubuntu ubuntu 4096 Jul 12 11:39 ..
-rw-rw-r-- 1 ubuntu ubuntu 4285 Jul 12 11:39 app.rb
-rw-rw-r-- 1 ubuntu ubuntu  433 Jul 12 11:39 Capfile
drwxrwxr-x 3 ubuntu ubuntu 4096 Jul 12 11:39 config
-rw-rw-r-- 1 ubuntu ubuntu   41 Jul 12 11:39 config.ru
-rw-rw-r-- 1 ubuntu ubuntu  337 Jul 12 11:39 Gemfile
-rw-rw-r-- 1 ubuntu ubuntu 1256 Jul 12 11:39 Gemfile.lock
drwxrwxr-x 8 ubuntu ubuntu 4096 Jul 12 11:40 .git
-rw-rw-r-- 1 ubuntu ubuntu    5 Jul 12 11:39 .gitignore
-rw-rw-r-- 1 ubuntu ubuntu  560 Jul 12 11:39 helpers.rb
-rw-rw-r-- 1 ubuntu ubuntu  582 Jul 12 11:39 README.md
drwxrwxr-x 2 ubuntu ubuntu 4096 Jul 12 11:39 views

б) удалим репозиторий reddit на appserver и повторим запуск playbook

ansible app -m command -a 'rm -rf ~/reddit warn=no'
appserver | CHANGED | rc=0 >>

ansible app -m shell -a 'ls -la ~/reddit warn=no'
appserver | FAILED | rc=2 >>
ls: cannot access '/home/ubuntu/reddit': No such file or directorynon-zero return code

ansible-playbook clone.yml

PLAY [Clone] ********************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************
ok: [appserver]

TASK [Clone repo] ***************************************************************************************************************************************************************************
changed: [appserver]

PLAY RECAP **********************************************************************************************************************************************************************************
appserver                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

После того, как каталог ~/reddit удалили => changed=1, потому что каталог скачали (т.е. произошло изменение)

3) создан inventoty типа shell, который запускается "на лету" в bash скрипте, который запускает terraform output в "хитром формате",
для чего был изменен файл terraform/prod/output.tf:

### The Ansible inventory file
output "inventory" {
value = <<INVENTORY
{ "_meta": {
        "hostvars": { }
    },
  "app": {
    "hosts": ["${module.app.external_ip_address_app}"]
  },
  "db": {
    "hosts": ["${module.db.external_ip_address_db}"]
  }
}
    INVENTORY
}

inventory.sh прописан в ansible.cfg, поэтому можно вызвать ansible без ключа -i.

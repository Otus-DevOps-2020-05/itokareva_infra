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

ansible all -m ping
84.201.175.228 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
130.193.37.30 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

4) Вариант со статическим inventory
ansible all -i 1.py -m ping
84.201.175.228 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
130.193.37.30 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"

# Домашняя работа 11

Deploy и управление конфигурацией с Ansible.

1) конфигурация db, app и deploy приложения: один playbook, один сценарий
- reddit_app_one_play.yml
2) конфигурация db, app и deploy приложения: один playbook, несколько сценариев
- reddit_app_multiple_play.yml
3) конфигурация db, app и deploy приложения: несколько плейбуков
- созданы db.yml, app.yml, deploy.yml
- создан главный плейбук site.yml, который включает в себя остальные
4) Изменили провиженинг в parcker:
- packer_db.yml - добавляет репозиторий MongoDB
- packer_app.yml - устанавливает Ruby и Bundler
Теперь эти плейбуки выболняют те же действия, что раньше выполняли провиженеры в packer/db.json, packer/app.json.
Команды shell и command не использовались, только модули ansible.
5) Заменены секции Provision в packer/db.json, packer/app.json.
6) Созданы новые db и app образы.
7) Из новых образов созданы ВМ с поднятыми на них bd и app.
8) На новые ВМ применена конфигурация site.yml c использованием динамического inventory.
Backend - работает, в БД сообщения сохраняет.

Задание со (*)

Динамический инвентори подробно описан в ДР №10, но чтобы работал шаблон без ручной вставки внутреннего
ip-адреса, статическое значение переменной было заменено на динамическую ее подстановку из terraform output.
Для этого было выполнено следующее:

1)добавдена новая переменная private_ip в terraform/modules/db/outputs.tf
2) изменен шаблон terraform/prod/outputs.tf на следующий:

#output "external_ip_address_app" {
#  value = module.app.external_ip_address_app
#}
#output "external_ip_address_db" {
#  value = module.db.external_ip_address_db
#}
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
    "hosts": ["${module.db.external_ip_address_db}"],
    "vars": {
        "private_ip": "${module.db.private_ip_address_db}"
    }
  }
}
    INVENTORY
}

3) в шаблон templates/db_config.j2 добавлен вызов переменной из inventory:

DATABASE_URL={{ hostvars[groups['db'][0]]['private_ip'] }}

4) команда ansible для накатки конфигурации выглядит так:
ansible-playbook -i inventory.sh site.yml

# Домашняя работа 12

Ansible: работа с ролми и окружениями

1) создана роль базы данных ansible/roles/db
2) создана роль приложения ansible/roles/app
3) удалеы вызовы тасков и хендлеров из ansible/app.yml, добавлен вызов роли app
4) удалеы вызовы тасков и хендлеров из ansible/db.yml, добавлен вызов роли db
5) приложение с вызовом ролей работает правильно
6) созданы окружения stge и prod: ansible/environments/stage, ansible/environments/prod
7) в папки  environments перенесены описания переменных stage/group_vars/app, stage/group_vars/db
8) удалены описания переменных из самого плейбука
9) приложение с настроенными окружениями работает правильно
10) добавлен вызов роли jdauphant.nginx из Community в плейбук app.yml
11) добавлен  вызов роли jdauphant.nginx в плейбук app.yml
12) приложение теперь работает на 80 порту
13) добавлен  плейбук для создания пользователей - файл ansible/playbooks/users.yml
14) создан файл ключа ~/.ansible/vault.key
15) создан файл с данными пользователей для каждого окружения:
    -  ansible/environments/stage/credentials.yml
    -  ansible/environments/prod/credentials.yml
16) зашифрованы credentials.yml  файлы используя vault.key
17) после вызова плейбука site.yml пользователе созданы на серверах db, app и к ним можно подключиться по ssh

Задание со (*)

Скрипты для динамического inventory: inventory.sh  добавлены в ansible/environments/stage, ansible/environments/prod.
В ansible.cfg добавлено:
[defaults]
inventory = ./environments/stage/inventory.sh

# Домашняя работа 13

Разработка и тестирование Ansible ролей и плейбуков

1) Установлен Vagrant и VirtualBox на локальной машине(linux). 
Попытка использовать Nested virtualisation внутри ВМ поднятой в VirtualBox не была успешной. Процесс установки сваливался по timeout и сама ВМ падала.
Но на ВМ созданной внутри Hyper-v машины создались нормально.
Остановилась на машине c "голым" linux (не ВМ)
2) Доработаны роли Ansible и выполнен провижининг.
3) Приложение установлено иработает на порту 9292
4) создано и активировано виртуальное окружение: source venv/bin/activate  
5) Установлены фреймворк для тестирования Ansible-кода TestInfra и инструмент тетирования molecule. 
6) Создан тест в roles/db/molecule/default/tests/test_default.py:

def test_socket_listening(host):
  socket = host.socket('tcp://0.0.0.0:27017')
  assert socket.is_listening
   
Изменен verifier в файле roles/db/molecule/default/molecule.yml (по умолчанию Ansible):
 
verifier:
  name: testinfra
в файле roles/db/molecule/default/molecule.yml (по умолчанию Ansible)
7) Пройден весь цикл тестирования для роли db.
molecule create
molecule converge
molecule verify -- запускает тест test_default.py

(venv) [itokareva@otus db]$ molecule verify
--> Test matrix

└── default
    └── verify

--> Scenario: 'default'
--> Action: 'verify'
--> Executing Testinfra tests found in /Otus_12/itokareva_infra/ansible/roles/db/molecule/default/tests/...
    ============================= test session starts ==============================
    platform linux -- Python 3.6.8, pytest-5.4.3, py-1.9.0, pluggy-0.13.1
    rootdir: /Otus_12/itokareva_infra/ansible/roles/db/molecule/default
    plugins: testinfra-5.2.2
collected 1 item

    tests/test_default.py .                                                  [100%]

    ============================== 1 passed in 2.01s ===============================
Verifier completed successfully.

8) Переписаны плейбуки packer_db.yml, packer_app.yml с использованием ролей db,app. Приложение сохранило свою работоспособность


Задание со (*)

Для настройки проксирования добавлет параметр в ansible.extra_vars в Vagrantfile:

        "nginx_sites" => {
          "default" => [
            "listen 80",
            "server_name 'reddit'",
            "location / { proxy_pass http://127.0.0.1:9292; }"


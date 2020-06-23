#!/bin/bash
wget -qO - http://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse"
sudo apt-get update
sudo apt-get install -y mongodb-org
if [ $? -eq 0 ]
then 
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod
else
echo "Failure: mongodb is not installed"
exit 1
fi


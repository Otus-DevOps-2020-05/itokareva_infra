#!/bin/bash
sudo apt install git --assume-yes
git clone -b monolith https://github.com/express42/reddit.git
date
echo $?
if [ $? -eq 0 ]
then
  echo "Success: reddit is cloned."
  cd reddit && bundle install
if [ $? -eq 0 ]
then
      puma -d
      ps aux | grep puma >&1
      exit 0
else
    echo "Failure: bundle is not installed. Script failed" >&2
    exit 1
fi
else
  echo "Failure: reddit is not cloned. Script failed" >&2
  exit 1
fi




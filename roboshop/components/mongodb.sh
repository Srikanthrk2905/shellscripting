#!/bin/bash

StatCheck() {
if [ $1 -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
  exit 2
fi
}

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

print() {
  echo -e "\e[36m $1 \e[0m"
}

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
StatCheck $?


USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ];then
  echo you should be root user to run this command
  exit 1
fi

yum install -y mongodb-org >>$LOG_FILE
StatCheck $?

systemctl enable mongod
StatCheck $?

systemctl start mongod
StatCheck $?

curl -f s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip">>$LOG_FILE
StatCheck $?


cd /tmp
unzip mongodb.zip
StatCheck $?


cd mongodb-main

mongo < catalogue.js
StatCheck $?


mongo < users.js
StatCheck $?

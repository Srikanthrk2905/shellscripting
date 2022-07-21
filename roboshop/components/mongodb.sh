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
StatCheck
print "$1"

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ];then
  echo you should be root user to run this command
  exit 1
fi

yum install -y mongodb-org >>$LOG_FILE
StatCheck
print "$1"
curl -f s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip">>$LOG_FILE
StatCheck
print "$1"

unzip mongodb.zip
StatCheck
print "$1"
cd mongodb-main
StatCheck
print "$1"
mongo < catalogue.js
StatCheck
print "$1"
mongo < users.js
StatCheck
print "$1"
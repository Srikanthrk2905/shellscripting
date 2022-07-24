#!/bin/bash

StatCheck() {
if [ $1 -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
  exit 2
fi
}
print() {
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ];then
  echo you should be root user to run this command
  exit 1
fi
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

print "setup yum repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
StatCheck $?

print "install mongodb"
yum install -y mongodb-org >>$LOG_FILE
StatCheck $?

print "listen to mongodb ip address change"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatCheck $?

print "Start Mongodb"
systemctl enable mongod && systemctl start mongod
StatCheck $?



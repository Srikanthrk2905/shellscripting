#!/bin/bash

source components/common.sh

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



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

print "download schema"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>LOG_FILE
StatCheck $?

print "extract schema"
cd /tmp && unzip mongodb.zip &>>LOG_FILE

print "load schema"
cd mongodb-main &>>LOG_FILE && mongo < catalogue.js &>>LOG_FILE && mongo < users.js &>>LOG_FILE
StatCheck $?
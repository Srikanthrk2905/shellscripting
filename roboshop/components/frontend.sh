#!/bin/bash

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ];then
  echo you should be root user to run this command
  exit 1
fi

echo "\[36m Installing Nginx\e[0m"

yum install nginx -y
if [ $? -eq 0 ]; then
  echo "\[32m Installing Nginx\e[0m"success
else
  echo "\[31m Installing Nginx\e[0m"success
  exit 2
fi

curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi

rm -rf /usr/share/nginx/html/*

if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi

cd /usr/share/nginx/html/
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi

unzip /tmp/frontend.zip
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi
mv frontend-main/* .
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi
mv static/* .
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi
rm -rf frontend-main README.md
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi
mv localhost.conf /etc/nginx/default.d/roboshop.conf
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi

systemctl restart nginx
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi
systemctl enable nginx
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi
systemctl start nginx
if [ $? -eq 0 ]; then
  echo success
else
  echo failure
  exit 1
fi

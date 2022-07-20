#!/bin/bash
StatCheck_() {
if [ $1 -eq 0 ]; then
  echo -e "\e[32m SUCCESS \e[0m"
else
  echo -e "\e[31m FAILURE \e[0m"
  exit 2
fi
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ];then
  echo you should be root user to run this command
  exit 1
fi

echo -e "\e[36m Installing Nginx \e[0m"
yum install nginx -y
StatCheck $1
echo -e "\e[36m download Nginx \e[0m"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
StatCheck $1
echo -e "\e[36m Clean old and download new Nginx Arcive \e[0m"
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
StatCheck $1
echo -e "\e[36m restart Nginx \e[0m"
systemctl restart nginx
StatCheck $1
echo -e "\e[36m Enabling Nginx \e[0m"
systemctl enable nginx
StatCheck $1
echo -e "\e[36m Starting Nginx \e[0m"
systemctl start nginx
StatCheck $1

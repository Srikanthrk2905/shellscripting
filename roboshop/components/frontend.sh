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

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ];then
  echo you should be root user to run this command
  exit 1
fi

print "Installing Nginx"
yum install nginx -y >>$LOG_FILE
StatCheck $?

print "download Nginx"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >>$LOG_FILE
StatCheck $?

print "Clean old Nginx"
rm -rf /usr/share/nginx/html/* >>$LOG_FILE
StatCheck $?

cd /usr/share/nginx/html/

print "extracting nginx"
unzip /tmp/frontend.zip >>$LOG_FILE && mv frontend-main/* . >>$LOG_FILE && mv static/* . >>$LOG_FILE
StatCheck $?

print "Update Roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf >>$LOG_FILE
StatCheck $?

print "restart Nginx"
systemctl restart nginx
StatCheck $?
print "Enabling Nginx"
systemctl enable nginx
StatCheck $?
print "Starting Nginx"
systemctl start nginx
StatCheck $?

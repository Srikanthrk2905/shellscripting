source components/common.sh

print "install nodejs"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
StatCheck $

print "add user"
useradd roboshop
StatCheck $

print "change usr"
usr roboshop
StatCheck $

print "run commands"
$ curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
$ cd /home/roboshop
$ unzip /tmp/catalogue.zip
$ mv catalogue-main catalogue
$ cd /home/roboshop/catalogue
$ npm install

print "listen to mongodb ip address change"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
StatCheck $?
#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME/$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR: Please run the script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
    else
        echo -e "$2 ... $R SUCCESS $N"
    fi    
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting up NPM Source"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing nodejs"

useradd roboshop &>>$LOGFILE

VALIDATE $? "adding roboshop user"

mkdir /app &>>$LOGFILE

VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "downlading catalogue.zip"

cd /app &>>$LOGFILE

VALIDATE $? "change to app directory"

npm install &>>$LOGFILE

VALIDATE $? "Install npm"

cp catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "copying catalogue service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "reloading service"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "enabling service"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "starting service"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copying repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "installing repo"

mongo --host mongodb.kautomation.online </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "loading  shema"
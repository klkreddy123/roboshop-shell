#!/bin/bash

DATE=$(date +%F)
LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$0-$DATE.log
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

if [ $USERID -ne 0 ];
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ];
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting up NPM Source"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Installing NodeJS"

useradd roboshop &>>$LOGFILE

VALIDATE $? "Add roboshop user"

mkdir /app &>>$LOGFILE

VALIDATE $? "create directory app"

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>$LOGFILE

VALIDATE $? "Download user zip"

cd /app &>>$LOGFILE

VALIDATE $? "Move to app directory"

unzip /tmp/user.zip &>>$LOGFILE

VALIDATE $? "Unzip user to app directory"

cd /app  &>>$LOGFILE

VALIDATE $? "Move to app directory"

npm install  &>>$LOGFILE

VALIDATE $? "Installing npm"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "reloading daemon"

systemctl enable user &>>$LOGFILE

VALIDATE $? "Enablinig user"

systemctl start user &>>$LOGFILE

VALIDATE $? "Starting user"

cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copying of mongo repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "installing of mongo repo"

mongo --host mongodb.kautomation.online </app/schema/user.js &>>$LOGFILE

VALIDATE $? "loading user data into mongodb" 

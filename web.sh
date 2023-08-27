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

yum install nginx -y &>>$LOGFILE

VALIDATE $? "Installing nginx"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "enable nginx"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "removing default html pages"

curl -o /tmp/web.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$LOGFILE

VALIDATE $? "Copying roboshop artifacts"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "Navigate to html folder"

unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $? "unzipping web files"

cp /root/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE

VALIDATE $? "copying nginx config files"

systemctl restart nginx &>>$LOGFILE

VALIDATE $? "restating nginx"





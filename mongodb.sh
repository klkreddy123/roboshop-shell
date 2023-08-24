USERID=$(id -u)
LOGSDIR=/tmp
DATE=$(date +%F)
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log
RED="\e[31m"
NOCOLOR="\e[0m"
GREEN="\e[32m"

VALIDATE(){

if [ $1 -ne 0 ]
then
    echo -e "$2 is $RED failure $NOCOLOR"
    exit 1
else
    echo -e "$2 is $GREEN success $NOCOLOR"
fi

}

if [ $USERID -ne 0 ]
then
    echo -e "$RED Failure: Logged in user is not root user $NOCOLOR"
    exit 1
else
    echo -e "$GREEN Success: Logged in user is root user $NOCOLOR"
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied MongoDB repo in to yum.repos.d"

yum install mongodb-org -y

VALIDATE $? "Installation of MongoDB"

systemctl enable mongod

VALIDATE $? "Enabling of MongoDB"

systemctl start mongod

VALIDATE $? "starting MongoDB"

sed -i 's/127.0.0.0/0.0.0.0/' /etc/mongod.conf

VALIDATE $? "Editing MongoDB conf"

systemctl restart mongod

VALIDATE $? "Restarting MongoDB"
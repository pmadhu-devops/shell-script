#!/bin/bash

#variable set up
USERiD=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

# color messages

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Asking db password

echo "Enter your database password:"
read -s mysql_root_password


#validate function

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}



 # condition to check root user or not
if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi


#installing mysql

dnf install mysql-server -y &>>$LOGFILE 
validate $? "Installing mysql server..........."

#enabling mysql

systemctl enable mysqld &>>$LOGFILE 
validate $? "Enabling mysql server.........."

#starting mysql

systemctl start mysqld &>>$LOGFILE 
validate $? "starting mysql server........."


#Root Password Setup

mysql -h -uroot 13.220.84.36 -p${mysql_root_password} -e 'show databases;' &>>LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi
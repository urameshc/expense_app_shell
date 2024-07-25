#!/bin/bash

source ./common.sh

echo "Please enter DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySQL"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL"

#mysql_secure_installation --set-root-pass ExpenseApp@1
#VALIDATE $? "Setting up root password"

#Below code will be useful for idempotent nature
mysql -h db.malleswari.shop -uroot -p${mysql_root_password} -e 'show databases;' &>>$LOGFILE
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
    VALIDATE $? "MySQL Root password Setup"
else
    echo -e "MySQL Root password is already setup...$Y SKIPPING $N"
fi




#!/bin/bash
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update -y
sudo apt-get -y install postgresql -y
wget https://github.com/utkarsh17naik/operations-task-utkarsh/blob/master/db/rates.sql
sleep 30
psql --set ON_ERROR_STOP=on -U $0 -h $1 -d $2 -1 -f rates.sql --password $3
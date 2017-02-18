#!/bin/bash

echo "Checking for database..."
if ! mysql -u root -p -e 'use BucketList'; then
	echo "Initializing MySQL DB"
	mysql -u root -p < init.sql
fi

if [ ! -d "env" ]; then
	echo "Setting up virtualenv"
	virtualenv -p python3 env
	source env/bin/activate
	pip install flask
	pip install flask-mysql
else
	source env/bin/activate
fi

echo "Starting server"
python3 app.py

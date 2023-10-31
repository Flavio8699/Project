#!/bin/bash

# MySQL database details
db_user="root"
db_password="12345678"
db_name="e4l"

# Check if the database exists
if mysql -u "$db_user" --password="$db_password" -e "USE $db_name" >/dev/null 2>&1; then
    # Delete if it exists
    mysql -u "$db_user" --password="$db_password" -e "DROP DATABASE $db_name"
fi

# Create the database
mysql -u "$db_user" --password="$db_password" -e "CREATE DATABASE $db_name"

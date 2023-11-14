#!/bin/bash

# MySQL database details
db_user="root"
db_password="12345678"
db_name="e4l"

# Update database
mysql -u "$db_user" --password="$db_password" -e "USE e4l; UPDATE question SET details_file = REPLACE(details_file, 'http://localhost:8080', 'https://192.168.33.97:8080')"
mysql -u "$db_user" --password="$db_password" -e "USE e4l; UPDATE possible_answer SET image = REPLACE(image, 'http://localhost:8080', 'https://192.168.33.97:8080')"

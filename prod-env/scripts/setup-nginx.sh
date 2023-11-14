#!/bin/bash

# Check if nginx ssl folder exists
if [ -d /etc/nginx/ssl ]; then
    # Delete if exists
    sudo rm -rf /etc/nginx/ssl
fi

# Create nginx ssl folder
sudo mkdir /etc/nginx/ssl

# Create nginx configuration file
conf=$(cat <<'EOF'
server {
    listen       443 ssl;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    location /staticnews {
        root   /home/vagrant/frontend/news;
        index  index.html index.htm;

        # disable cache
        add_header Last-Modified $date_gmt;
        add_header Cache-Control 'no-store, no-cache, must-revalidate, proxy-revalidate, max-age=0';
        if_modified_since off;
        expires off;
        etag off;

        try_files $uri $uri/ =404;
    }

    location /e4lapi {
        proxy_pass https://192.168.33.97:8080/e4lapi;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location / {
        root   /home/vagrant/frontend/html;
        index  index.html index.htm;

	    try_files $uri $uri/ /index.html;
    }
}
EOF
)
echo "$conf" | sudo tee /etc/nginx/conf.d/default.conf > /dev/null

# Check if default config exists
if [ -e /etc/nginx/sites-enabled/default ]; then
  # If it exists, remove it
  sudo rm /etc/nginx/sites-enabled/default
fi

# Create ssl certificate for nginx
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=LU/ST=Luxembourg/L=Belval/O=UniLU/CN=e4l"

# Restart nginx
sudo service nginx restart
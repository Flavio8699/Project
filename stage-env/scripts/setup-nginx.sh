#!/bin/bash

# Create nginx configuration file
conf=$(cat <<'EOF'
server {
    listen       80;

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

# Restart nginx
sudo service nginx restart
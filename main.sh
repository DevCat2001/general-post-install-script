#!/bin/bash

# Update the system
dnf update -y

# Install useful packages
dnf install -y neofetch sl nyancat cmatrix hollywood fortune-mod cowsay lolcat figlet

# Install nginx web server
dnf install -y nginx

# Start and enable the nginx service
systemctl start nginx
systemctl enable nginx

# Create a directory for the web root
mkdir -p /var/www/html

# Add a default index.html file
echo "Welcome to my server" > /var/www/html/index.html

# Configure nginx to use the new web root directory
sed -i 's#root /usr/share/nginx/html;#root /var/www/html;#g' /etc/nginx/nginx.conf

# Restart nginx to apply the changes
systemctl restart nginx

# Create a folder for the websites
mkdir -p /var/www/websites

# Install some example websites
# Wordpress website 1
curl -o /var/www/websites/wp1.zip https://wordpress.org/latest.zip
unzip /var/www/websites/wp1.zip -d /var/www/websites/wp1

# Wordpress website 2
curl -o /var/www/websites/wp2.zip https://wordpress.org/latest.zip
unzip /var/www/websites/wp2.zip -d /var/www/websites/wp2

# Django website 1
pip install --user Django==3.2
django-admin startproject mysite /var/www/websites/django1

# Add the virtual host for each website
# Wordpress website 1
echo "server {
    listen 80;
    server_name wp1.example.com;
    root /var/www/websites/wp1;
    index index.php;
    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}" > /etc/nginx/conf.d/wp1.conf

# Wordpress website 2
echo "server {
    listen 80;
    server_name wp2.example.com;
    root /var/www/websites/wp2;
    index index.php;
    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }
    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/var/run/php-fpm/php-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}" > /etc/nginx/conf.d/wp2.conf

#!/bin/bash

openssl req -x509 -newkey rsa:4096 -nodes -sha256 -keyout ft_server.key -out ft_server.crt -days 365 -subj "/C=KR/ST=SEOUL/L=SEOUL/O=42/OU=gon/CN=localhost"
mkdir etc/nginx/ssl
mv ft_server.key etc/nginx/ssl/
mv ft_server.crt etc/nginx/ssl/
chmod 600 /etc/nginx/ssl/*

cp -rp /tmp/default /etc/nginx/sites-available

wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
rm -rf latest.tar.gz
mv wordpress/ /var/www/html/
chown www-data:www-data /var/www/html/wordpress
cp -rp ./tmp/wp-config.php /var/www/html/wordpress

service mysql start
echo "CREATE DATABASE wordpress;" | mysql -uroot
echo "CREATE USER 'gpaeng'@'localhost' IDENTIFIED BY 'gpaeng';" | mysql -uroot
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'gpaeng'@'localhost' WITH GRANT OPTION;" | mysql -uroot

wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
rm -rf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
cp -rp /tmp/config.inc.php /var/www/html/phpmyadmin/
chmod 755 /var/www/html/phpmyadmin/config.inc.php

service nginx start
service mysql restart
service php7.3-fpm start 

bash
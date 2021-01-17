#!/bin/bash

#ssl 개인키 및 인증서 
openssl req -x509 -newkey rsa:4096 -nodes -sha256 -keyout ft_server.key -out ft_server.crt -days 365 -subj "/C=KR/ST=SEOUL/L=SEOUL/O=42/OU=gon/CN=localhost"
mkdir etc/nginx/ssl
mv ft_server.key etc/nginx/ssl/
mv ft_server.crt etc/nginx/ssl/
chmod 600 /etc/nginx/ssl/*

#nginx ssl설정(https로 리다이렉션 설정)
cp -rp /tmp/default /etc/nginx/sites-available

#wordpress 설치 및 설정
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
rm -rf latest.tar.gz
mv wordpress/ /var/www/html/
chown www-data:www-data /var/www/html/wordpress
cp -rp ./tmp/wp-config.php /var/www/html/wordpress

#sql 아직 안함
service mysql start
https://escane.tistory.com/138 - 사이트
https://cnpnote.tistory.com/entry/SQL-%EC%89%98-%EB%B3%80%EC%88%98%EB%A1%9C-MySQL%EC%9D%98-%EC%BF%BC%EB%A6%AC-%EA%B2%B0%EA%B3%BC%EB%A5%BC-%EC%A0%80%EC%9E%A5

#phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
rm -rf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
cp -rp /tmp/confit-inc.php /var/www/html/phpmyadmin


service nginx start
service mysql restart
service php7.3-fpm start 

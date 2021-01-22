FROM	debian:buster

LABEL	maintainer="gpaeng@student.42seoul.kr"

RUN		apt-get update
RUN		apt-get upgrade
RUN		apt-get -y install nginx mariadb-server php-mysql php-mbstring openssl vim wget php7.3-fpm

COPY	./srcs/default ./tmp
COPY	./srcs/wp-config.php ./tmp
COPY	./srcs/config.inc.php ./tmp 
COPY	./srcs/container.sh ./

WORKDIR /

CMD		bash container.sh
FROM	debian:buster

LABEL	maintainer="gpaeng@student.42seoul.kr"

RUN		apt-get update
RUN		apt-get upgrade
RUN		apt-get -y install nginx mariadb-server php-mysql php-mbstring openssl vim wget php7.3-fpm

# HostOS의 파일, 디렉토리를 docker container안 경로로 복사
COPY	./srcs/default ./tmp
COPY	./srcs/wp-config.php ./tmp
COPY	./srcs/config.inc.php ./tmp 
COPY	./srcs/run.sh ./

EXPOSE 80
EXPOSE 443
# 해당 컨테이너가 80, 443 port를 사용할 예정
# 실제로 포트를 열기 위해서는 run 명령어에서 -p 옵션을 사용해야 한다.

CMD		bash run.sh
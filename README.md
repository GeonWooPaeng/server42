# ft_server

 <br/>

![ft_server img](https://user-images.githubusercontent.com/53526987/104583012-f2513b80-56a3-11eb-9fd6-0ffd33c11eb5.PNG)

출처 : https://stitchcoding.tistory.com/2 (유사)



<br/>



# 1. Docker (도커)



<br/>



- 컨테이너 방식으로 프로세스를 독립적으로 관리하고 계층화된 파일 시스템에 기반하여 효율적으로 이미지(프로세스 실행 환경)을 구축한다.
- 도커의 환경설정은 dockerfile에 저장 -> 이 파일을 이용해서 이미지 빌드 -> 이미지를 실행한 것(컨테이너) -> 컨테이너 내에서 변경한 내역들(os 설정, 응용 설정)은 컨테이너가 종료되면 모두 사라진다.
- vm : 가상화된 하드웨어 위에 os가 올라가는 형태(host와 분리)
- container: os 가상화하고 커널을 host와 공유



<br/>



+

가상화 : 물리적인 하드웨어장치를 논리적인 객체로 추상화 하는 것



<br/>



## 의미



<br/>

- os가 옮겨 지는 것이아니라(하드웨어X) 그냥 os 환경과 dockerfile에 명시되어 있는 .sh가 실행되는 것이다.(/bin/bash)

- 서버와 내 컴퓨터가 다른 OS인 것을 해결

  => 새로운 서비스 만들때 마다 새로운 서버, 설정이 필요 X

  => 하나의 같은 서버에서 각기 다른 환경의 컨테이너 설정 가능



<br/>



## 역할



<br/>



### 1. 원하는 개발 환경을 파일에 저장가능

=> 어느 곳에서든 해당 환경 시뮬레이션을 하게 해준다.



### 2. 어떤 환경이든 모듈식 관리 가능

=> 컨테이너를 독립적으로 존재, 관리하기 때문



<br/>



## 기본 사용



<br/>



- $docker start [container 이름] : container 시작
- $docker restart [container 이름]: container 재시작
- $docker stop [container 이름] : container 종료
- $docker attach [container 이름] : 시작되어 있는 container 연결

- docker 터미널 내에서 종료: exit, ctrl + d
- docker cp [container 이름]:[container 내부 경로] [host 파일 경로(copy 할 장소)]



<br/>



## Docker Image



<br/>



- 프로세스 실행 환경 
- 컨테이너 실행에 필요한 파일과 설정 값



<br/>



## Docker File



<br/>



- 패키지를 설치하고 동작하기 위한 파일 (Makefile)

=> docker image를 생성하는 파일



<br/>



#### <예시>



<br/>



```shell
#작업을 시작할 베이스 이미지 <이미지 이름>:<태그>
FROM debian:buster

#이미지의 정보
LABEL maintainer="gpaeng@student.42seoul.kr"

# app 디렉토리 생성
# 도커 이미지가 생성되기 전에 수행할 shell 명령어
RUN apt-get update && apt-get upgrade


#Docker 이미지 내부에서 RUN, CMD, ENTRYPOINT의 명령이 실행될 디렉터리를 설정합니다.
WORKDIR /app


# 현재 디렉터리에 있는 파일들을 이미지 내부 /app 디렉터리에 추가함
ADD     . /app


# 디렉토리의 내용을 컨테이너에 저장하지 않고 호스트에 저장하도록 설정
# docker run 명령에서 -v 옵션 사용
VOLUME ["/data", "/mnt/c/Users"]


# 호스트와 연결할 포트 번호
#docekr run 명령에서 -p옵션 사용
EXPOSE 80

      
# 컨테이너가 시작되었을 때 실행할 실행 파일, shell scripts
# => 생성된 컨테이너를 실행할 명령어 지정
CMD ["/app/log.backup.sh"]

```

#### 주의

- 컨테이너에 담을 파일들은 Dockerfile 하위 디렉토리에 있어야 한다.
- ADD시 절대 경로는 사용 X



<br/>



### Docker File로 Image 생성



<br/>



- $docker build -t [image 이름]
- DockerFile 경로에서만 입력해야 한다.



<br/>



### Docker에서 호스트 포트 / 컨테이너 포트



<br/>



### 포트 포워딩 설정(포트 맵핑)



<br/>



- 도커 컨테이너는 사설 IP 주소를 사용하므로 컨테이너 외부(인터넷 망)에서 내부로 접속 불가능 한 것을 극복하기 위해 만들어 진 것
- NAT가 동작하는 라우터/게이트웨이의 특정 포트 번호로 유입되는 트래픽을 NAT 내부에서 동작하는 시스템의  특정 포트로 전달해주는 기법



<br/>



```shell
docker run -it -p 80:5000 
#80 - container port
#5000 - host port
```

=> 외부에서 호스트 80번 port로 접속하면 컨테이너의 5000번 port로 접속한다.

=> -i : interactive 모드로 표준입력과 표준출력을 키보드와 화면을 통해 가능하게 한다.

=> -t: 텍스트 기반의 터미널(TTY)을 애뮬레이션(복제) 해주는 옵션





<br/>



# 2. Debian Buster



<br/>



- 안정성을 중시하는 리눅스 배포판으로 OS 중 하나



<br/>



# 3. Nginx



<br/>



- 웹서버(http를 통해 웹 브라우저에서 요청하는 html 문서나 오브젝트(이미지 파일 등)을 전송해주는 서비스 프로그램)
- Apache 보다 동작이 단순
- 전달 역할만 해서 동시접속에 특화



<br/>



## 역할



<br/>



#### 1. 정적 파일 처리

- HTML, CSS, JS, Image 같은 정보를 웹 브라우저(chrome, firefox 등)에 전송



#### 2. 리버스 프록시(reverse proxy)

- 클라이언트가 가짜 서버에 요청(request)하면 프록시 서버(Nginx)가 reverse 서버(응용 프로그램 서버)로 부터 데이터를 가져오는 것
- => 요청(request)에 버퍼링이 있어 요청을 배분하기 위함



<br/>



![proxy](https://user-images.githubusercontent.com/53526987/104586327-abb21000-56a8-11eb-81ea-af89139ea5fe.png)

출처: https://whatisthenext.tistory.com/123



<br/>



#### +

- server(서버): 정보를 제공하는 쪽

- client(클라이언트): 정보 요청하는 쪽

- web server: 서버쪽에서 정보를 제공하는 software

- http: web server와 web client가 서로 정보를 주고 받기 위한 protocol(약속) 

  => HTML 문서와 같은 리소스들을 가져올 수 있도록 해주는 프로토콜

- proxy(프록시): 서버와 클라이언트사이의 중계기(대리 통신을 하기 위한 것)



<br/>



# 4. phpMyAdmin



<br/>



- 웹 기반(php 기반)으로 데이터 베이스를 처리하는 프로그램(database 아이드 비밀번호 사용)
- 데이터베이스 client 



<br/>



## PHP-fpm



<br/>



- Nginx를 php와 연동시켜주는 것 (<https://yumserv.tistory.com/146>)

- PHP FastCGI Process Manger
- CGI보다 빠른 버전



<br/>



## CGI



<br/>



- 웹서버와 외부 프로그램을 연결해주는 표준화된 프로토콜

- 웹 서버에서 요청을 받아 외부 프로그램에서 해당 파일을 html로 변환하는 단계를 거치는 것
- 하나의 요청(request)에 하나의 프로세스 생성



<br/>



#### - FastCGI

- CGI 개선
- 요청(request)가 있을 때마다 만들어진 프로세스가 새로운 요청처리 (프로세스 생성 & 제거 X)



<br/>



# 5. MYSQL



<br/>



- 관계형 데이터베이스



<br/>



# 6. WordPress



<br/>



- phpmyadmin(database)의 내용을 가지고 웹으로 표현(데이터베이스 + html)

- CMS(Contents Management System - 콘텐츠를 관리하는 시스템) 중 하나 
- 웹사이트의 다양한 리소스 및 컨텐츠, 데이터를 쉽게 관리 가능



<br/>



# 7. SSL Protocol



<br/>



- 서버 와 클라이언트 간의 인증에 사용 (암호화 키 송수신)

- 사이트의 보안을 강화하는 작업 (http -> https)



<br/>



## 대칭키



<br/>



- 암호키 = 복호화키 = 비밀키 (키 1개)
- 장점: 비대칭키에 비해서 연산이 빠르다
- 단점: 키 분배가 불안전하며 키가 노출될 경우 누구나 해독 가능



<br/>



![암호화](https://user-images.githubusercontent.com/53526987/104687420-807bff00-5742-11eb-85ba-4c42d5e5c196.PNG)



<br/>



## 비대칭키



<br/>



- 암호화 키 = Public key = 공개 키
- 복호화 키 = Private key = 사설 키, 개인 키
- 장점: 키 분배가 비교적 안전하다.
- 단점: 대칭키에 비해서 연산이 느리다, 연산 부하가 높다.



<br/>



# 8. Autoindex



<br/>



- 가상 호스트 설정 항목(server {...}내의 블럭)에서 root로 설정한 디렉토리 내의 파일을 목록화하여 파일을 다운로드 할 수 있는 디렉토리 리스팅 기능(단순 파일 제공하는 용도일 때 별도의 html파일 구성 X 이용가능)을 제공하는 것
- => 파일이 아닌 디렉토리를 가리키는 url 요청을 받으면 요청한 url에 대응되는 이름의 파일(디렉토리 안에 있다.)의 콘텐츠를 반환한다.

ex)



```shell
root /var/www/html; #root설정 디렉토리

index index.html index.htm #파일 목록화
```



- Autoindex 꺼져 있거나 목록화된 파일 없으면 웹서버는 자동으로 해당 디렉토리 파일들을 크기, 변경일, 해당 파일에 대한 링크와 함께 열거한 html 파일을 반환한다.



<br/>


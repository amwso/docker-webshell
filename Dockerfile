FROM ubuntu:14.04
MAINTAINER HJay <trixism@qq.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN \
 cp /root/.bashrc /root/.profile / ; \
 echo 'HISTFILE=/dev/null' >> /.bashrc ; \
 HISTSIZE=0 ; \
 sed -i "s/archive.ubuntu.com/cn.archive.ubuntu.com/g" /etc/apt/sources.list ; \
 echo 'deb http://cn.archive.ubuntu.com/ubuntu/ trusty multiverse' >> /etc/apt/sources.list ; \
 echo 'deb-src http://cn.archive.ubuntu.com/ubuntu/ trusty multiverse' >> /etc/apt/sources.list ; \
 apt-get update ; \
 apt-get -y upgrade ; \
 cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime ; \
 sed -i 's/UTC=yes/UTC=no/' /etc/default/rcS

RUN \
 apt-get -y install nginx-extras \
 php5-cli php5-curl php5-fpm php5-json php5-mcrypt php5-mysql php5-sqlite php5-xmlrpc php5-xsl php5-gd \
 curl wget git unzip pwgen anacron \
 supervisor \
 mysql-client ; \
 apt-get clean ; \
 php5enmod mcrypt

COPY ./sbin /root/sbin
COPY ./template /root/template

RUN mv /etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf.default ; \
 cp /root/template/conf/supervisord.conf /etc/supervisor/supervisord.conf ; \
 cp /root/template/conf/supervisor_service.conf /etc/supervisor/conf.d/ ; \
 mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.default ; \
 cp -rf /root/template/conf/nginx/* /etc/nginx/ ; \
 cp /root/template/conf/php-fpm.conf /etc/php5/fpm/php-fpm.conf

# webshell
RUN \
 mkdir -p /root/thirdparty ; \
 curl -sSL https://github.com/b374k/b374k/archive/v3.2.3.tar.gz | tar -zxf - -C /root/thirdparty/ ; \
 true


EXPOSE 80

CMD ["/bin/bash","/root/sbin/init.sh"]

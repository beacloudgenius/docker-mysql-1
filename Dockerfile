FROM ubuntu:14.04
  
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    TERM=xterm
RUN locale-gen en_US en_US.UTF-8
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc
RUN apt-get update

# Runit
RUN apt-get install -y runit 
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

# Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc

#Nginx
RUN apt-get install -y nginx

#MySQL
RUN wget http://dev.mysql.com/get/mysql-apt-config_0.7.2-1_all.deb && \
    dpkg -i *.deb && \
    apt-get update
RUN apt-get install -y mysql-server && \
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf

#PHP-FPM
RUN apt-get install -y php5-fpm php5-mysql
RUN sed -i "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|" /etc/php5/fpm/php.ini

#SQL Buddy
RUN mkdir -p /var/www && \
    cd /var/www && \
    wget https://github.com/calvinlough/sqlbuddy/raw/gh-pages/sqlbuddy.zip && \
    unzip sqlbuddy.zip && \
    rm sqlbuddy.zip 

#Adminer
RUN mkdir -p /var/www/adminer && \
    cd /var/www/adminer && \
    wget https://www.adminer.org/static/download/4.2.4/adminer-4.2.4-mysql-en.php -O index.php

#phpAdmin
RUN mkdir -p /var/www && \
    cd /var/www && \
    wget https://files.phpmyadmin.net/phpMyAdmin/4.6.0/phpMyAdmin-4.6.0-all-languages.zip && \
    unzip phpMyAdmin*.zip && \
    rm phpMyAdmin*.zip && \
    mv phpMyAdmin* phpmyadmin

#memcached plugin
RUN apt-get install -y libevent-dev

#data
COPY mysql.ddl /
#COPY data.sql /
RUN mysqld_safe & mysqladmin --wait=5 ping && \
    mysql < /usr/share/mysql/innodb_memcached_config.sql && \
    mysql < mysql.ddl && \
#    mysql -u root < data.sql && \
    mysqladmin shutdown

#configuration
COPY index.html /var/www/
COPY config.inc.php /var/www/phpmyadmin/
COPY nginx.conf /etc/nginx/

# Add runit services
COPY sv /etc/service 
ARG BUILD_INFO
LABEL BUILD_INFO=$BUILD_INFO

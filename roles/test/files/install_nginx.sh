#!/bin/bash
# yum -y install zlib zlib-devel openssl openssl-devel pcre-devel
groupadd -r nginx
useradd -s /sbin/nologin -g nginx -r nginx
cd /tmp
tar zxf nginx-1.10.3.tar.gz;cd nginx-1.10.3
./configure \
--prefix=/home/waming/nginx \
--user=nginx \
--group=nginx \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-pcre \

make && make install

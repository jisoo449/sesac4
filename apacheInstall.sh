#!/bin/bash

	[ $(rpm -qa httpd) != '' ] && {
		rpm -e --nodeps httpd
	}

	yum -y install httpd

	
	[ ! -e /usr/bin/wget ] && {
		yum -y install wget
	} 

	[ ! -e /usr/bin/gcc ] && {
		yum -y install gcc
	}

wget https://downloads.apache.org//apr/apr-1.7.0.tar.gz
tar zxvf apr-1.7.0.tar.gz
./apr-1.7.0/configure
make
make install




wget https://downloads.apache.org//apr/apr-util-1.6.1.tar.gz
tar zxvf apr-util-1.6.1.tar.gz
./apr-util-1.6.1/configure --with-apr=/usr/local/apr
make
make install




wget https://downloads.apache.org//httpd/httpd-2.4.46.tar.bz2
rpm -e httpd --nodeps

tar jxvf httpd-2.4.46.tar.bz2
./httpd-2.4.46/configure 

path=$(find / -iname *httpd* | egrep *.tar.bz2)
directory=${path//'/http*',''}

tar jxvf $path -C $directory











#!/bin/bash



#
#remove_install "gcc"
#
#remove_install "gcc-c++"
#



# 멀티라인 주석 : v로 드래그;  :norm i#
#          해제 :  ""   ""     :norm 1x


list=("gcc" "gcc-c++" "httpd-tools" "httpd-manual" "httpd" "curl")
echo -e "httpd 패키지설치에 필요한 패키지 리스트 : \n\n\t""${list[*]}"
echo -e "패키지 리스트 를 설치 하시겠습니까?( y | n ) : "
read line
[ $line == 'y' ] || [ $line == 'yes' ] && {
	for package in ${list[*]};do
		echo -e "$PATH" | egrep "base_run_sh" && {
			remove_install.sh $package
		}
	done
}


systemctl status firewalld && {
	echo -e "방화벽에 80/tcp 포트를 허용하시겠습니까? ( y | n ) : "
	read line
	if [ "${line}" -eq "y" -o "${line}" -eq "yes" ]; then
		firewall-cmd --add-port=80/tcp --permanent
		firewall-cmd --reload	
		firewall-cmd --list-ports
	fi

}

systemctl status iptables && {
	echo -e "방화벽에 80 포트를 허용 하시겠습니까? ( y | n ) : "
	read line
	if [ "${line}" -eq "y" -o "${line}" -eq "yes" ]; then
		iptables -A INPUT -p tcp --dport 80 -j ACCEPT
		iptables-save > ./cur_iptables_saved
		iptables-restore < ./cur_iptables_saved
		systemctl restart iptables
	fi
}

#echo -e "apachectl is same systemctl and service"
#apachectl start 

systemctl start httpd
systemctl enable httpd
systemctl -l status httpd


echo -e "\n\n\n\nhttpd 패키지 스크립트 파일 리스트 :: \n\n"
rpm -qc httpd

cat /etc/httpd/conf/httpd.conf | egrep "[^#].+(ServerRoot|DocumentRoot|DirectoryIndex|Listen|Port|ServerAdmin|ServerName).+" --color

#echo -e "hello!! "$(httpd -v) > /var/www/html/index.html

echo -e "https 를 설치하시겠습니까? ( y | n ) : "
read line
if [ "${line}" == 'y' -o "${line}" == 'yes' ];then
	./https_install.sh

fi



#
#	echo -e "my ip :: \n\t"
#	curl bot.whatismyipaddress.com
#	echo -e "\n"
#
#	curl http://ipecho.net/plain
#	echo -e "\n"
#
#	curl ipv4.icanhazip.com
#
#httpd.apache.org


























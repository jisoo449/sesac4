#!/bin/bash
echo -e $PATH | egrep base_run_sh && {
	systemctl_base.sh 'mariadb'
#	yum info mariadb-server && {
	
#	yum -y install mariadb-server;
#		systemctl start mariadb
#		systemctl enable mariadb;
#		systemctl status mariadb;

parm="";password="";

rpm -qa | egrep -oxi '.*mariadb-server.*' && {
	if [ -e $(which mysql_secure_installation) ];then
		echo -e "mysql_secure_installation 을 설정하시겠습니까?  ( y | n ) : "
		read line
		if [ "${line}" = 'y' ] || [ "${line}" = 'yes' ]; then
			[ -e /var/log/mariadb/mariadb.log.rpmsave ] && {
				echo -e "/var/log/mariadb/mariadb.log.rpmsave 가 존재합니다.\n 기존에 mariadb_server를 설치 했다가 지운 경우 로그에 기록이 남아"\
					"이전 설정이 db 에 남아있어 재설치를 했어도 \n"\
					"설정이 적용되어있을 수 있습니다.\n 비밀번호 적용되어 있는 경우 \nmysql -u root -p비밀번호;\nuse mysql; \nupdate user set user=\"\" where user='root';\n 로 초기화 시켜줘야 합니다."
					rm -rf /var/log/mariadb/mariadb.log.rpmsave					
#"/var/log/mariadb/mariadb.log.rpmsave 을 지우시겠습니까? ( y | n ) : "
#read line
#if [ "$line" == 'y' ] || [ "$line" == 'yes' ]; then
#rm -rf /var/log/mariadb/mariadb.log.rpmsave;
#fi

			}
			echo -e "mysql root 계정의 비밀번호를 입력해주세요. <설정을 한 적이 없을 시 엔터 입력.> : "
			read line;
			if [ "${line}" == "" ];then
				parm+="\n"
			else
				parm+="${line}\n"
			fi
			
			echo -e "mysql root 계정 비밀번호를 설정<변경> 하시겠습니까? ( y | n ) : "
			read line;
			if [ "${line}" = 'y' ] || [ "${line}" = 'yes' ]; then
				parm+="y\n"
				
				while true;do
					echo -e "설정할 mysql root 비밀번호 입력 : "
					read password;
			
					echo -e "비밀번호 재입력 : "
					read re_password;

					if [ $password == $re_password ]; then
						parm+="${password}\n${re_password}\n"
						break;
					else
						echo -e "비밀번호가 서로 다릅니다. 다시 입력해주세요."
						continue;
					fi

				done
			else
				parm+="n\n"
			fi

				
			echo -e "anonymous 게정을 삭제하시겠습니까? ( y | n ) : "
			read line
			if [ "${line}" == 'y' ] || [ "${line}" == 'yes' ]; then
				parm+="y\n"
			else
				parm+="n\n"
			fi


			echo -e "외부에서 root 계정의 로그인을 허용하시겠습니까? ( y | n )"
			read line
			if [ "${line}" == 'y' ] || [ "${line}" == 'yes' ]; then
				parm+="y\n"
			else
				parm+="n\n"
			fi

			echo -e "test 데이터베이스를 삭제하시겠습니까? ( y | n ) : "
			read line
			if [ "${line}" == 'y' ] || [ "${line}" == 'yes' ]; then
				parm+="y\n"
			else
				parm+="n\n"
			fi			


			echo -e "privileges 테이블을 재시작하시겠습니까? ( y | n ) : "
			read line
			if [ "${line}" == 'y' ] || [ "${line}" == 'yes' ]; then
				parm+="y\n"
			else
				parm+="n\n"
			fi		

			echo $parm

			echo -e "${parm}" | mysql_secure_installation  
			
			echo -e "<< mysql 계정이 정상적으로 등록되었습니다. >>";
			echo -e "use mysql;select * from user;" | mysql -u root -h localhost -p${password} | egrep -i 'root'
			
		fi

	else
		echo -e "mysql_secure_installation 을 찾지 못했습니다.";


	fi
}

#}
#	systemctl restart network
}




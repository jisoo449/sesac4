#!/bin/bash
source /etc/profile
#echo -e 'yum -y install wget'
#yum -y install wget

echo "아파치 톰캣 다운로드 버전 입력 (9.0.83): "
read APACHE_TOMCAT_VERSION
if [ -z $APACHE_TOMCAT_VERSION ];then
	APACHE_TOMCAT_VERSION="9.0.83"
fi

APACHE_TOMCAT_VERSION_1=${APACHE_TOMCAT_VERSION//\.[0-9]+\.[0-9]+$//}
APACHE_TOMCAT_VERSION_2=${APACHE_TOMCAT_VERSION//\.[0-9]+$//}
APACHE_TOMCAT_VERSION_3=${APACHE_TOMCAT_VERSION//^[0-9]+\.[0-9]+\.//}



APACHE_TOMCAT_DOWNLOAD_URL="https://downloads.apache.org/tomcat/tomcat-${APACHE_TOMCAT_VERSION_1}/v${APACHE_TOMCAT_VERSION}/bin/apache-tomcat-${APACHE_TOMCAT_VERSION}-deployer.tar.gz"


wget "${APACHE_TOMCAT_DOWNLOAD_URL}" && {

#echo -e 'tar zxvf ./apache-tomcat*.tar.gz' | more
	APACHE_TOMCAT_DIR="./apache_tomcat_dir"
	APACHE_TAR_GZ='apache*.tar.gz' 
	if [ -e ${APACHE_TAR_GZ} ]; then
		tar zxvfp ${APACHE_TAR_GZ}
		
		if [ -e $APACHE_TOMCAT_DIR ];then
			rm -rf $APACHE_TOMCAT_DIR	
		fi
		
		mkdir $APACHE_TOMCAT_DIR -m 770
		mv apache-* $APACHE_TOMCAT_DIR
		
	else
		echo -e "${APACHE_TAR_GZ} 가 존재하지 않습니다."
	fi


	[ -d "${APACHE_TOMCAT_DIR}" ] && {
		echo -e "mv ${APACHE_TOMCAT_DIR} /usr/local/lib"
		mv "${APACHE_TOMCAT_DIR}" /usr/local/lib/
		APACHE_TOMCAT_DIR='/usr/local/lib/'"${APACHE_TOMCAT_DIR}"

			[ -d "${APACHE_TOMCAT_DIR}" ] && {
				#echo -e 'vi /etc/profile'
				echo -e "\n"'CATALINA_HOME='"${APACHE_TOMCAT_DIR}" >> /etc/profile
				echo -e "\n"'CLASSPATH=$CLASSPATH:$CATALINA_HOME/lib/servlet-api.jar' >> /etc/profile
				echo -e "\n"'PATH=$PATH:$CATALINA_HOME/bin' >> /etc/profile


				PROFILE_CONTENT=$(cat /etc/profile)
				PROFILE_CONTENT=${PROFILE_CONTENT//'export JAVA_HOME PATH CLASSPATH'/''}
				echo -e "${PROFILE_CONTENT}" > /etc/PROFILE_CONTENT

				echo -e "\n"'export JAVA_HOME CATALINA_HOME CLASSPATH PATH'"\n" >> /etc/profile

#echo -e 'source /etc/profile'
				source /etc/profile
				
#echo -e 'echo $JAVA_HOME   $CATALINA_HOME   $CLASSPATH   $PATH'
				echo "$JAVA_HOME   $CATALINA_HOME    $CLASSPATH    $PATH"
			
				SERVER_XML="${APACHE_TOMCAT_DIR}"'/conf/server.xml'
				[ -f "${SERVER_XML}" ] && {
					#URIset
					SERVER_XML_CONTENT=$(cat "${SERVER_XML}")
					URI_ENCODING=${SERVER_XML_CONTENT/'redirectPort="8443" />'/'redirectPort="8443" URIEncoding="UTF-8" />'}
					echo -e "${URI_ENCODING}" > "${SERVER_XML}"
				}
			}

		#/usr/local/apache-tomcat-9.0.40/conf/server.xml
		#redirectPort="8443 URIEncoding="UTF-8" />

#echo -e 'startup.sh'
#startup.sh
	}
}

#!/bin/bash
source /etc/profile

echo "java jdk 다운로드 버전 입력 (1.8.0) : "
read JAVA_JDK_VERSION

if [ -z $JAVA_JDK_VERSION ];then
	JAVA_JDK_VERSION="1.8.0"
fi

list=("java-${JAVA_JDK_VERSION}-openjdk" "java-${JAVA_JDK_VERSION}-openjdk-devel")

for package in list;do
	echo -e "${PATH}" | egrep 'base_run_sh' && remove_install.sh "${package}"
done

java -version 




readlink=$(readlink -f /usr/bin/java)
readlink=${readlink//'/jre/bin/java'/''}

echo -e "\n"'JAVA_HOME='"${readlink}\n" >> /etc/profile
echo -e "\n"'PATH='"$PATH"':'"$JAVA_HOME"'/bin'"\n" >> /etc/profile
echo -e "\n"'CLASSPATH='"$JAVA_HOME"'/jre/lib:'"$JAVA_HOME"'/lib/tools.jar'"\n" >> /etc/profile
echo -e "\n"'export JAVA_HOME PATH CLASSPATH'"\n" >> /etc/profile
source /etc/profile
echo -e " JAVA_HOME: ${JAVA_HOME}\nPATH: ${PATH}\nCLASSPATH: ${CLASSPATH}\n"




#!/bin/bash

#~ make this script executable by using chmod +x setup_hadoop.sh

#~ feel free to change and adjust to your liking. 
#~ The author is not responsible for the damage that has been
#~ inflicted due to any misconfiguration or other mishaps
#~ in short if it breaks you are on your own.. Sorry about that

#title           :setup_hadoop.sh
#description     :This script helps to configure hadoop 
#date            :20180112
#usage		 	 :bash setup_hadoop.sh or ./setup_hadoop.sh
#notes           :Install Vim and Emacs to use this script.
#==============================================================================
me=`basename "$0"`

#~ #XML CONFIG FILE LIST
ENV_JAVA_HOME="hadoop-env.sh"
CORE_SITE_XML="core-site.xml"
HDFS_SITE_XML="hdfs-site.xml"
YARN_SITE_XML="yarn-site.xml"
MAPRED_SITE_XML_TEMPLATE="mapred-site.xml.template"
MAPRED_SITE_XML="mapred-site.xml"
#~ #XML CONFIG FILE LIST

#~ #XML CONFIL CONTENTS 
#~ WARNING EDITING THIS FILE MIGHT RENDER THE APPLICATION INTO AN UNSTABLE STATE OR WORSE
CORE_SITE_INFO="<property>\n<name>fs.default.name</name>\n<value>hdfs://localhost:9000</value>\n</property>"
HDFS_SITE_INFO="<property>\n<name>dfs.replication</name>\n<value>1</value>\n</property>\n<property>\n<name>dfs.name.dir</name>\n<value>file:///hadoop/hadoopinfra/hdfs/namenode</value>\n</property>\n<property>\n<name>dfs.data.dir</name>\n<value>file:///hadoop/hadoopinfra/hdfs/datanode</value>\n</property>"
YARN_SITE_INFO="<property>\n<name>yarn.nodemanager.aux-service</name>\n<value>mapreduce_shuffle</value>\n</property>"
MAPRED_SITE_INFO="<property>\n<name>mapreduce.framework.name</name>\n<value>yarn</value>\n</property>"
#~ #XML CONFIG CONTENTS

#~ #STRING MATCHERS
#~ DO NOT EDIT THESE MATCH STRINGS. 
XML_CONFIGURATION_MATCH_STRING="<configuration>"
JAVA_HOME_MATCH_STRING="\${JAVA_HOME}"
#~ #STRING MATHCERS


#Install ssh if not found
if (dpkg -l figlet >/dev/null) ; then echo "Already installed"; else sudo apt-get update; sudo apt-get install figlet; fi
clear;


function createUser(){
USERNAME="hadoop";
PASSWORD="hadoop";

sudo adduser "$USERNAME";
sudo usermod -aG sudo $USERNAME;
}
function installJava(){
	sudo apt-add-repository ppa:webupd8team/java;
	sudo apt-get update;
	sudo apt install oracle-java8-installer;
	java -version;
	DEF_JAVA_PATH="\"$(dirname $(dirname $(readlink -f $(which javac))))\""
	clear;
	}
function unzipHadoop(){
	destination=/home/$USER/hadoop/;
	echo "cop and paste the hadoop compressed file to decompress"
	read custom;
	echo "Where do u want to save the decompressed files?[default: $destination]]"
	read destination;
	[[ -z "$destination" ]] && destination=/home/$USER/hadoop/ || $destination ;
	tar zxf "${custom#*//}" --directory $destination;
	
	}
	HADOOP_HOME="";
	XML_PATH=$HADOOP_HOME/etc/hadoop;
	DEF_JAVA_PATH=""
function setBashRC(){
	echo "copy and paste hadoop folder"
	read HADOOP_HOME;
	HADOOP_HOME="${HADOOP_HOME#*//}";
	echo "	
	#HADOOP ENVIRONMENT VARIABLES
	export HADOOP_HOME=$HADOOP_HOME
	export HADOOP_MAPRED_HOME=\$HADOOP_HOME
	export HADOOP_COMMON_HOME=\$HADOOP_HOME
	export HADOOP_HDFS_HOME=\$HADOOP_HOME
	export YARN_HOME=\$HADOOP_HOME
	export HADOOP_COMMON_LIB_NATIVE=\$HADOOP_HOME/lib/native
	export PATH=\$PATH:\$HADOOP_HOME/sbin:\$HADOOP_HOME/bin
	export HADOOP_INSTALL=\$HADOOP_HOME" >> ~/.bashrc
	

	
	setJavaHome $JAVA_HOME_MATCH_STRING $ENV_JAVA_HOME
	
	setXMLValues $XML_CONFIGURATION_MATCH_STRING $CORE_SITE_INFO $CORE_SITE_XML
	setXMLValues $XML_CONFIGURATION_MATCH_STRING $HDFS_SITE_INFO $HDFS_SITE_XML
	setXMLValues $XML_CONFIGURATION_MATCH_STRING $YARN_SITE_INFO $YARN_SITE_XML
	
	cp $HADOOP_HOME$XML_PATH/$MAPRED_SITE_XML_TEMPLATE $HADOOP_HOME$XML_PATH/$MAPRED_SITE_XML
	setXMLValues $XML_CONFIGURATION_MATCH_STRING $MAPRED_SITE_INFO $MAPRED_SITE_XML
		. ~/.bashrc 
	}
	
function sshConfig(){
	ssh-keygen -t rsa
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
	chmod 0600 ~/.ssh/authorized_keys
	echo "Done"
	
	}
	
function setXMLValues(){
	#~ 
	matchString=$1
	replaceString=$2
	sed  -i "/$matchString/a ${replaceString}" $HADOOP_HOME/etc/hadoop/$3
	
	}
	
function setJavaHome(){
	
	matchString=$1
	replaceString="\"$(dirname $(dirname $(readlink -f $(which javac))))\""
	sed -i "s@${matchString}@${replaceString}@g" $HADOOP_HOME/etc/hadoop/$2
	}	
	
function setJavaHome(){
	
	matchString=$1
	replaceString="\"$(dirname $(dirname $(readlink -f $(which javac))))\""
	sed -i "s@${matchString}@${replaceString}@g" $HADOOP_HOME/etc/hadoop/$2
	}	
function formateNameNode(){
	hdfs namenode -format
	}
function startHadoopServices(){
	exec $HADOOP_HOME/sbin/start-dfs.sh
	exec $HADOOP_HOME/sbin/start-yarn.sh
	
	}
function stopHadoopServices(){
	exec $HADOOP_HOME/sbin/stop-dfs.sh
	exec $HADOOP_HOME/sbin/stop-yarn.sh
	
	}
function main()
{			
	
			while :
			do
				clear
				echo "Default Path: /home/$USER/hadoop"
				echo "1. Create User"
				echo "2. Configure SSH"
				echo "3. Install Oracle Java"
				echo "4. Unzip Hadoop"
				echo "5. Set Hadoop Environment"
				echo "6. Format Namenode"
				echo "7. Start Hadoop Services"
				echo "8. Stop Hadoop Services"
				echo "9. Exit"
				echo -n "Please enter option [1 - 9]"
				read opt
				case $opt in
				
				1) echo "createUser";
				createUser
				;;
				2) echo "Config SSH";
				sshConfig
				;;
				3) echo "installJava";
				installJava
				;;
				4) echo "unzipHadoop";
				unzipHadoop
				;;
				5) echo "setBashRC";
				setBashRC
				;;
				6) echo "Format Namenode";
				formateNameNode
				;;
				7) echo "Strart Hadoop Services";
				startHadoopServices
				;;
				8) echo "Stop Hadoop Services";
				stopHadoopServices
				;;
		
                9) echo "Good bye";
                 . ~/.bashrc
                exit
                ;;
				 *) echo "$opt is an invaild option. Please select option between 1-9 only";
				 echo "Press [enter] key to continue. . .";
				 read enterKey;;
				 esac
			done;

}
main; 

	




#set the base image
FROM ubuntu

#set the labels
LABEL name="liferay7.0 GA5" description="Liferay 7GA5 with MySql and Elastic Search"

#provide maintainer information
MAINTAINER Sunit Chatterjee <chatterjeesunit@yahoo.com>

ENV TOOL_HOME=/home/user/Tools
ENV LIFERAY_HOME=$TOOL_HOME/liferay-ce-portal-7.0-ga5
ENV JAVA_HOME=$TOOL_HOME/jdk1.8.0_171
ENV JDK_HOME=$JAVA_HOME
ENV JRE_HOME=$JAVA_HOME
ENV ELASTIC_HOME=$TOOL_HOME/elasticsearch-2.4.6
ENV PATH=$PATH:$JAVA_HOME/bin:$TOOL_HOME

#Update Ubuntu and install mysql-server
#Create a user with username as "user" and password as "welcome"
RUN \
	mkdir -p $TOOL_HOME/scripts \
	&& apt-get update \
	&& apt-get install -y sudo unzip curl vim wget mysql-server \
	&& useradd -d /home/user -ms /bin/bash -g root -G sudo -p welcome user \
    && echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


#Change user (don't work as root)
USER user

#Change working directory to Tools folder
WORKDIR $TOOL_HOME

#Download Elastic Search / JDK 1.8 / Liferay 7ga5
#This is run as single RUN COMMAND to preserve the size of docker image
RUN \
	sudo chown -R user:root $TOOL_HOME \
	&& wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.4.6/elasticsearch-2.4.6.tar.gz \
	&& wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz \
	&& wget https://excellmedia.dl.sourceforge.net/project/lportal/Liferay%20Portal/7.0.4%20GA5/liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip \
	&& tar -xvf jdk-8u171-linux-x64.tar.gz \
	&& unzip liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip \
	&& tar -xvf elasticsearch-2.4.6.tar.gz \
	&& rm -f liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip \
	&& rm -f jdk-8u171-linux-x64.tar.gz \
	&& rm -f elasticsearch-2.4.6.tar.gz


#download the plugins
RUN \
	mkdir -p $TOOL_HOME/elastic-plugins \
	&& cd $TOOL_HOME/elastic-plugins \
	&& wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/analysis-icu/2.4.6/analysis-icu-2.4.6.zip \
	&& wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/analysis-kuromoji/2.4.6/analysis-kuromoji-2.4.6.zip \
	&& wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/analysis-smartcn/2.4.6/analysis-smartcn-2.4.6.zip \
	&& wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/analysis-stempel/2.4.6/analysis-stempel-2.4.6.zip \
	&& cd $ELASTIC_HOME/bin/ \
	&& ./plugin install file:///$TOOL_HOME/elastic-plugins/analysis-icu-2.4.6.zip \
	&& ./plugin install file:///$TOOL_HOME/elastic-plugins/analysis-kuromoji-2.4.6.zip \
	&& ./plugin install file:///$TOOL_HOME/elastic-plugins/analysis-smartcn-2.4.6.zip \
	&& ./plugin install file:///$TOOL_HOME/elastic-plugins/analysis-stempel-2.4.6.zip

#Copy start script to Tools folder
COPY start $TOOL_HOME/

#Copy Default Liferay config and properties
COPY liferay-configs/com.liferay.portal.search.elasticsearch.configuration.ElasticsearchConfiguration.config $LIFERAY_HOME/osgi/configs/
COPY liferay-configs/portal-ext.properties $LIFERAY_HOME/
COPY liferay-configs/portal-setup-wizard.properties $LIFERAY_HOME/

RUN sudo chmod +x start

#Copy scripts
COPY scripts $TOOL_HOME/scripts

#Update MySql Configurations
#Execute MySql init script - to update root user password and to create a 'testdb' schema
RUN \
	sudo chmod 664 /etc/mysql/mysql.conf.d/mysqld.cnf \
	&& sudo sed -i s/bind-address/#bind-address/g /etc/mysql/mysql.conf.d/mysqld.cnf \
	&& sudo echo lower-case-table-names=1 >> /etc/mysql/mysql.conf.d/mysqld.cnf \
	&& sudo service mysql start \ 
	&& sleep 10 \
	&& sudo mysql < $TOOL_HOME/scripts/mysql-init.sql \
	&& sudo service mysql stop


#Setup liferay for the first time, so that the default sample data and tables gets created
RUN \ 
	sed -i 's/Xmx1024m/Xms2048m -Xmx2048m/g' $LIFERAY_HOME/tomcat-8.0.32/bin/setenv.sh \
	&& sh $TOOL_HOME/scripts/liferay-first-startup.sh
	

ENTRYPOINT ["start"]

#Expose port 8080 of tomcat, port 3306 of mysql and port 9200, 9300 of elastic search
EXPOSE 8080 3306 9200 9300

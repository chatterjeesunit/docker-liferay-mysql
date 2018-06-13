#set the base image
FROM ubuntu:18.04

#set the labels
LABEL name="liferay7.0GA5 Application" description="Liferay application, along with MySql and Elastic Search"

#provide maintainer information
MAINTAINER Sunit Chatterjee <chatterjeesunit@yahoo.com>

#Expose port 8080 of tomcat, port 3306 of mysql and port 9200, 9300 of elastic search
EXPOSE 8080 3306 9200 9300


#Install pre-requisites
RUN \
	apt-get update && \
	apt-get -y install sudo unzip curl wget mysql-server


RUN \
	useradd -d /home/user -ms /bin/bash -g root -G sudo -p welcome user && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER user
WORKDIR /home/user


#create tool directory where we will copy all applications
RUN mkdir -p /home/user/Tools

WORKDIR /home/user/Tools

#Download Elastic Search / JDK 1.8 and Liferay
#This is run as single RUN COMMAND to preserve the size of docker image
RUN \
	wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.4.6/elasticsearch-2.4.6.tar.gz && \
	wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz && \
	wget https://excellmedia.dl.sourceforge.net/project/lportal/Liferay%20Portal/7.0.4%20GA5/liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip && \
	tar -xvf jdk-8u171-linux-x64.tar.gz && \
	rm -rf jdk-8u171-linux-x64.tar.gz && \
	unzip liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip && \
	rm -rf liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip && \
	tar -xvf elasticsearch-2.4.6.tar.gz


ENV TOOL_HOME=/home/user/Tools
ENV LIFERAY_HOME=$TOOL_HOME/liferay-ce-portal-7.0-ga5
ENV JAVA_HOME=$TOOL_HOME/jdk1.8.0_171
ENV JDK_HOME=$JAVA_HOME
ENV JRE_HOME=$JAVA_HOME
ENV ELASTIC_HOME=$TOOL_HOME/elasticsearch-2.4.6
ENV PATH=$PATH:$JAVA_HOME/bin:$TOOL_HOME

#Copy start script to Tools folder
COPY start /home/user/Tools/

RUN sudo chmod +x start

ENTRYPOINT ["start"]

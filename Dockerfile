#set the base image
FROM ubuntu

#set the labels
LABEL name="liferay7.0GA5 Application" description="Liferay application, along with MySql and Elastic Search"

#provide maintainer information
MAINTAINER Sunit Chatterjee <chatterjeesunit@yahoo.com>

#Expose port 8080 of tomcat, port 3306 of mysql and port 9200, 9300 of elastic search
EXPOSE 8080 3306 9200 9300


#Install pre-requisites
RUN apt-get update
RUN apt-get -y install apt-utils
RUN apt-get -y install unzip
#RUN apt-get -y install mysql-server

#create tool directory where we will copy all applications
RUN mkdir -p /opt/Tools

#Copy JDK 1.8
COPY jdk-8u91-linux-x64.tar.gz /opt/Tools

#Copy Liferay 7.0 GA5
COPY liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip /opt/Tools

#Copy elastic search
COPY elasticsearch-2.4.6.zip /opt/Tools

COPY start.sh /opt/Tools/


WORKDIR /opt/Tools

RUN chmod +x start.sh
RUN tar -xvf jdk-8u91-linux-x64.tar.gz
RUN rm -rf jdk-8u91-linux-x64.tar.gz
RUN unzip liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip
RUN rm -rf liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip
RUN unzip elasticsearch-2.4.6.zip


ENV TOOL_HOME=/opt/Tools
ENV LIFERAY_HOME=$TOOL_HOME/liferay-ce-portal-7.0-ga5
ENV JAVA_HOME=$TOOL_HOME/jdk1.8.0_91
ENV JDK_HOME=$JAVA_HOME
ENV JRE_HOME=$JAVA_HOME
ENV ELASTIC_HOME=$TOOL_HOME/elasticsearch-2.4.6
ENV PATH=$PATH:$JAVA_HOME/bin


ENTRYPOINT ["sh start.sh"]


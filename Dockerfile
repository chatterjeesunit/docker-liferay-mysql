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
RUN apt-get -y install apt-utils unzip curl wget

#create tool directory where we will copy all applications
RUN mkdir -p /opt/Tools

WORKDIR /opt/Tools


#Download Elastic Search 2.4.6
RUN wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.4.6/elasticsearch-2.4.6.tar.gz

#Download JDK 1.8
RUN wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz

#Download Liferay 7.0 GA5
RUN wget https://excellmedia.dl.sourceforge.net/project/lportal/Liferay%20Portal/7.0.4%20GA5/liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip


#RUN apt-get -y install mysql-server


COPY start /opt/Tools/


RUN chmod +x start
RUN tar -xvf jdk-8u171-linux-x64.tar.gz
RUN rm -rf jdk-8u171-linux-x64.tar.gz
RUN unzip liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip
RUN rm -rf liferay-ce-portal-tomcat-7.0-ga5-20171018150113838.zip
RUN unzip elasticsearch-2.4.6.zip


ENV TOOL_HOME=/opt/Tools
ENV LIFERAY_HOME=$TOOL_HOME/liferay-ce-portal-7.0-ga5
ENV JAVA_HOME=$TOOL_HOME/jdk1.8.0_171
ENV JDK_HOME=$JAVA_HOME
ENV JRE_HOME=$JAVA_HOME
ENV ELASTIC_HOME=$TOOL_HOME/elasticsearch-2.4.6
ENV PATH=$PATH:$JAVA_HOME/bin


ENTRYPOINT ["/opt/Tools/start"]


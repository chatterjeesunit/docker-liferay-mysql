#!/bin/sh

# This scripts starts the liferay server for first time.
# It waits till the first time startup creates the tables, loads sample data, etc
# Then it terminates the server
# Advantage of running this script during image build, is that the image is prepopulated with all data/tables, etc

rm -f $LIFERAY_HOME/tomcat-8.0.32/logs/catalina.out

#Remove the tomcat log tail script from the server startup script
sed -i s/tail/#tail/g $TOOL_HOME/start

#Start the appserver, elastic search server and mysql
cd $TOOL_HOME
./start

echo "will now wait for startup to complete"
while [ 0 = "$st1" ]; do st1=`grep -c "org.apache.catalina.startup.Catalina.start Server startup" $LIFERAY_HOME/tomcat-8.0.32/logs/catalina.out` && echo "waiting for startup"; done

echo $(tail -f $LIFERAY_HOME/tomcat-8.0.32/logs/catalina.out | grep -m 1 "org.apache.catalina.startup.Catalina.start Server startup")

echo "Will Shutdown the liferay server now" && \

#Shut down appserver, elastic search server and mysql
ps aux | grep tomcat | grep -v grep | awk '{print $2}' | xargs kill -9
ps aux | grep elasticsearch | grep -v grep | awk '{print $2}' | xargs kill -9
sudo service mysql stop

echo "Shutdown of server complete"

#Add the tomcat log tail command to back to the server startup script
sed -i s/#tail/tail/g $TOOL_HOME/start

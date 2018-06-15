# Docker Build File for creating Image for Liferay application


Involves following application
 - Liferay Community 7.0 GA5
 - MySQL Server 5.7.19
 - Elastic Search 2.4.6
 
 Work in Progress

docker build -t liferay:7.0-GA5 .


run -d --name liferay-app liferay:7.0-GA5

docker exec -it focused_ardinghelli tail -f /home/user/Tools/liferay-ce-portal-7.0-ga5/tomcat-8.0.32/logs/catalina.out


Following is the link to the Docker Hub Image - https://hub.docker.com/r/chatterjeesunit/liferay/


This docker file is for creating an Image of Liferay 7 application.
This image is a full setup and ready to run image of **Liferay Community 7.0 GA5** application with following component
 * Liferay 7 GA5 Community Application server
 * MySQL Server
 * Remote Elastic Search Server

#### How to build the Image
`docker build -t liferay:7.0-GA5 .`

>We have build this image for easy liferay setup on Develop/QA machines or for quick setup of Liferay demo environments. This **should not** be used for any UAT/Production environments, as ideally in Production environments all three servers should not reside in same image (as it is not a scalable model)

Details about the application
---------------------------------------
+ Fully Configured. No additional configuration required
+ Default tables and sample data is pre-loaded.
+ Following ports have been exposed to connect from host machine
  + 3306 - MySQL Server
  + 8080 - Liferay Application
  + 9200 - Elastic Search
  + 9300 - Elastic Search
+ User Information
  + Username: _user_
  + Password: _welcome_
+ MySql Server Login Credential
  + User: _root_
  + Password: _root_
  + Database: _testdb_


How to Use this Image
--------------------------------
> First you need to build the Image from the given _DockerFiler_

> All the commands given below assume that _liferay_ is the name of the container.

#### Create a new container
`docker run -d --name liferay liferay:7.0-GA5 `

where _liferay:7.0-GA5_ is the image name and version

#### Stopping the container
`docker stop liferay`

#### Starting the container
`docker start liferay`

#### Finding IP Address of the docker container
`docker inspect --format '{{ .NetworkSettings.IPAddress }}' liferay`

#### Accessing server URL from host machine
+ Use this URL: http://<docker IP Address>:8080 
e.g http://172.17.0.2:8080
+ Login Credentials
  + Username: test@liferay.com
  + Password: test

#### Printing application server logs
`docker exec -it liferay tail -f /home/user/Tools/liferay-ce-portal-7.0-ga5/tomcat-8.0.32/logs/catalina.out`

#### Get access to bash shell of the container
`docker exec -it liferay bash`

#### Connect to MySql Server inside the container
`mysql -h <Docker IP Address> -u root -p`

e.g `mysql -h 172.17.0.2 -u root -p`





Deploying custom OSGI Jars / Config / Properties to Liferay container
---------------------------------------------------------------------------------------------
> All the commands given below assume that _liferay_ is the name of the container.

#### Deploying a single OSGI Jar to Liferay container

+ Make sure your liferay container is running
+ Run below command

`docker cp *.jar liferay:/home/user/Tools/liferay-ce-portal-7.0-ga5/`

#### Deploying OSGI Jars (zip file option)
+ Create a zip file containing all OSGI Jars.
  + Name of zip file should be : *osgi_jars.zip*
  + Make sure the zip file only has files and no folder structure within it
+ Run following command to copy the zip file to container's liferay base folder

`docker cp osgi_jars.zip liferay:/home/user/Tools/liferay-ce-portal-7.0-ga5/`

+ Restart docker container
+ When you start it, the startup script automatically unzips the OSGI jar files in the deploy folder for automatic deployment


#### Deploying custom property files
+ There are scenarios where we want to modify the default properties. e.g _portal-ext.properties_

+ Copy the property file to the docker container with below command

`docker cp portal-ext.properties liferay:/home/user/Tools/liferay-ce-portal-7.0-ga5/`

+ Restart the docker container

#### Deploying multiple custom property / config files (zip file option)
+ There could be a scenario to deploy multiple property/ configuration files. e.g
  + Portal Properties
  + OSGI Config files
+ Create a zip file of all properties and config files
  + Name of file should be : _config.zip_
  + Keep base folder structure in zip file, relative to liferay base folder
+ Sample zip file content would be like

  |_ portal-ext.properties

  |_ portal-setup-wizard.properties

  |_ osgi

     |_configs

       |_com.liferay.portal.bundle.blacklist.internal.BundleBlacklistConfiguration

       |_com.liferay.portal.search.elasticsearch.configuration.ElasticsearchConfiguration.config

  |_ tomcat-8.0.32

     |_ ROOT

       |_ WEB-INF

         |_ classes
         
            |_ log4j.properties                

+ Copy this zip file to container's base liferay folder

`docker cp config.zip liferay:/home/user/Tools/liferay-ce-portal-7.0-ga5/`

+ Restart docker container
+ When you start it, the startup script automatically unzips and deploys the config files


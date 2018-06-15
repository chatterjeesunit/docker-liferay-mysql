
This docker file is for creating an Image of Liferay 7 application.

This image is a full setup and ready to run image of **Liferay Community 7.0 GA5** application with following component
 * Liferay 7 GA5 Community Application server
 * MySQL Server
 * Remote Elastic Search Server

#### How to build the Image
`docker build -t liferay:7.0-GA5 .`

>We have build this image for easy liferay setup on Develop/QA machines or for quick setup of Liferay demo environments. This **should not** be used for any UAT/Production environments, as ideally in Production environments all three servers should not reside in same image (as it is not a scalable model)


More details about how to run this image (after building) is at - https://hub.docker.com/r/chatterjeesunit/liferay/

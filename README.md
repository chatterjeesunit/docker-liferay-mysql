
This docker file is for creating an Image of Liferay 7 application.

This image is a full setup and ready to run image of **Liferay Community 7.0 GA5** application with following component
 * Liferay 7 GA5 Community Application server
 * MySQL Server
 * Remote Elastic Search Server

>We have build this image for easy liferay setup on Develop/QA machines or for quick setup of Liferay demo environments. This **should not** be used for any UAT/Production environments, as ideally in Production environments all three servers should not reside in same image (as it is not a scalable model)

You can find more details about how this image is build, and how to run this image from the following blog - https://dev-journal.in/2018/06/17/docker-how-to-build-image-liferay-7/

The corresponding docker image for this is at - https://hub.docker.com/r/chatterjeesunit/liferay/

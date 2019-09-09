-- set password of root user to "root"
-- change auth plugin from 'auth_socket' to 'mysql_native_password'
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
-- By Default Root user only has access to localhost.
-- We are grant him permission on all databases from any hosts
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'root';
-- Flush the privileges
FLUSH PRIVILEGES;
-- create a database
CREATE SCHEMA `testdb` DEFAULT CHARACTER SET utf8 ;

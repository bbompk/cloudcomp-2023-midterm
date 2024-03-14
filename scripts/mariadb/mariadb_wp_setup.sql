CREATE USER 'wordpress-user'@'localhost' IDENTIFIED BY 'admin';
CREATE DATABASE `wordpress-db`;
GRANT ALL PRIVILEGES ON `wordpress-db`.* TO 'wordpress-user'@'localhost';
CREATE USER 'wordpress-user'@'%' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON `wordpress-db`.* TO 'wordpress-user'@'%';
FLUSH PRIVILEGES;

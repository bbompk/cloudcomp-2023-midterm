#!/bin/bash

# install php8.1 and apache2
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
sudo apt update
sudo apt install -y apache2
DEBIAN_FRONTEND=noninteractive sudo apt install -y php8.1
DEBIAN_FRONTEND=noninteractive sudo apt install -y php8.1-curl php8.1-gd php8.1-mbstring php8.1-xml php8.1-xmlrpc php8.1-soap php8.1-intl php8.1-zip php8.1-mysql libapache2-mod-php
sudo systemctl enable php8.1-fpm
suso systemctl start php8.1-fpm
suso systemctl restart apache2
sudo python3 edit_apache2_dir.py
sudo systemctl restart apache2

# download wordpress
sudo python3 apache2_allow_override.py
sudo a2enmod rewrite
sudo systemctl restart apache2
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
touch /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
sudo cp -a /tmp/wordpress/. /var/www/html
sudo chown -R www-data:www-data /var/www/html
sudo find /var/www/html/ -type d -exec chmod 750 {} \;
sudo find /var/www/html/ -type f -exec chmod 640 {} \;
sudo python3 ~/scripts/wp_config_edit.py $DB_HOST


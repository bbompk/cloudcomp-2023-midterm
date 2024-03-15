#!/bin/bash
git clone https://github.com/bbompk/cloudcomp-2023-midterm.git
cd cloudcomp-2023-midterm/scripts/wordpress
export DB_HOST=
export WP_PUBLIC_IP=
export WP_ADMIN_USER=admin
export WP_ADMIN_PASS=admin

# install php8.1 and apache2
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
sudo apt update
DEBIAN_FRONTEND=noninteractive sudo apt install -y php8.1
DEBIAN_FRONTEND=noninteractive sudo apt install -y php8.1-curl php8.1-gd php8.1-mbstring php8.1-xml php8.1-xmlrpc php8.1-soap php8.1-intl php8.1-zip php8.1-mysql libapache2-mod-php
sudo systemctl enable php8.1-fpm
suso systemctl start php8.1-fpm

# install nginx
sudo systemctl stop apache2
sudo systemctl disable apache2
DEBIAN_FRONTEND=noninteractive sudo apt install -y nginx
sudo cp ../../nginx/nginx.conf /etc/nginx/sites-available/default
sudo nginx -t
sudo systemctl restart nginx

# download wordpress
cp wp_config_edit.py /tmp/wp_config_edit.py
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
sudo python3 wp_config_edit.py $DB_HOST
sudo systemctl restart nginx

# install wordpress with wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
sudo wp core install --path=/var/www/html --allow-root --url=$WP_PUBLIC_IP --title="CloudComp" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email="example@example.com" --skip-email
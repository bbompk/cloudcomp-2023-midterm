#!/bin/bash
git clone https://github.com/bbompk/cloudcomp-2023-midterm.git
cd cloudcomp-2023-midterm/scripts/wordpress
export DB_HOST=
export DB_NAME=wordpress-db
export DB_USER=wordpress-user
export DB_PASS=admin
export WP_PUBLIC_IP=
export WP_ADMIN_USER=admin
export WP_ADMIN_PASS=admin
export IAM_S3_ACCESS_KEY=
export IAM_S3_SECRET_KEY=
export BUCKET_NAME=
export REGION=

# install php8.1 and apache2
sudo sed -i "/#\$nrconf{restart} = 'i';/s/.*/\$nrconf{restart} = 'a';/" /etc/needrestart/needrestart.conf
sudo apt update
sudo apt install -y apache2
DEBIAN_FRONTEND=noninteractive sudo apt install -y php8.1
DEBIAN_FRONTEND=noninteractive sudo apt install -y php8.1-curl php8.1-gd php8.1-mbstring php8.1-xml php8.1-xmlrpc php8.1-soap php8.1-intl php8.1-zip php8.1-mysql libapache2-mod-php
sudo systemctl enable php8.1-fpm
sudo systemctl start php8.1-fpm
sudo systemctl restart apache2
sudo python3 edit_apache2_dir.py
sudo systemctl restart apache2

# download wordpress
sudo python3 apache2_allow_override.py
sudo a2enmod rewrite
sudo systemctl restart apache2
cp wp_config_edit.py /tmp/wp_config_edit.py
cp inject_wpo_const.py /tmp/inject_wpo_const.py
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzf latest.tar.gz
touch /tmp/wordpress/.htaccess
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade
sudo cp -a /tmp/wordpress/. /var/www/html
sudo chown -R www-data:www-data /var/www/html
sudo find /var/www/html/ -type d -exec chmod 750 {} \;
sudo find /var/www/html/ -type f -exec chmod 640 {} \;
sudo python3 wp_config_edit.py $DB_HOST $DB_NAME $DB_USER $DB_PASS
sudo python3 inject_wpo_const.py $IAM_S3_ACCESS_KEY $IAM_S3_SECRET_KEY $BUCKET_NAME $REGION
sudo systemctl restart apache2
ping -c 5 -W 45 $DB_HOST
ping -c 5 -W 45 $DB_HOST

# install wordpress with wp-cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
sudo wp core install --path=/var/www/html --allow-root --url=$WP_PUBLIC_IP --title="CloudCompMidterm" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email="example@example.com" --skip-email
sudo wp plugin install amazon-s3-and-cloudfront --path=/var/www/html --allow-root --activate
sudo systemctl restart apache2

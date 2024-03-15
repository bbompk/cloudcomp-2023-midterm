resource "aws_instance" "db" {
    ami = var.ami
    instance_type = "t2.micro"
    availability_zone = var.availability_zone
    
    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.db_to_nat.id
    }

    user_data = <<-EOF
                #!/bin/bash
                git clone https://github.com/bbompk/cloudcomp-2023-midterm.git
                cd cloudcomp-2023-midterm/scripts/mariadb
                export DB_NAME=${var.database_name}
                export DB_USER=${var.database_user}
                export DB_PASS=${var.database_pass}
                echo "$DB_NAME $DB_USER $DB_PASS"

                sudo apt update
                sudo apt install -y mariadb-server
                sudo systemctl start mariadb
                sudo systemctl enable mariadb
                python3 gen_setup_sql.py $DB_NAME $DB_USER $DB_PASS
                sudo mysql -u root < mariadb_wp_setup.sql
                sudo python3 mariadb_binding_addr.py
                sudo systemctl restart mariadb
                EOF

    tags = {
        Name = "cc-midterm-db"
    }

}

resource "aws_network_interface_attachment" "db_from_wp" {
    device_index = 1
    instance_id = aws_instance.db.id
    network_interface_id = aws_network_interface.db_from_wp.id
}

resource "aws_instance" "wp_server" {
    depends_on = [ aws_instance.db, aws_network_interface_attachment.db_from_wp, aws_iam_access_key.s3_user ]

    ami = var.ami
    instance_type = "t2.micro"
    availability_zone = var.availability_zone

    network_interface {
        device_index = 0
        network_interface_id = aws_network_interface.wp_internet.id
    }

    user_data = <<-EOF
                #!/bin/bash
                git clone https://github.com/bbompk/cloudcomp-2023-midterm.git
                cd cloudcomp-2023-midterm/scripts/wordpress
                export DB_HOST=${aws_instance.db.private_ip}
                export DB_NAME=${var.database_name}
                export DB_USER=${var.database_user}
                export DB_PASS=${var.database_pass}
                export WP_PUBLIC_IP=${aws_eip.wp_server.public_ip}
                export WP_ADMIN_USER=${var.admin_user}
                export WP_ADMIN_PASS=${var.admin_pass}
                export IAM_S3_ACCESS_KEY=${aws_iam_access_key.s3_user.id}
                export IAM_S3_SECRET_KEY=${aws_iam_access_key.s3_user.secret}
                export BUCKET_NAME=${var.bucket_name}
                export REGION=${var.region}

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
                cp wp_config_edit.py /tmp/wp_config_edit.py
                cp inject_wpo_const.py /tmp/inject_wpo_const.py
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
                sudo python3 wp_config_edit.py $DB_HOST $DB_NAME $DB_USER $DB_PASS
                sudo python3 inject_wpo_const.py $IAM_S3_ACCESS_KEY $IAM_S3_SECRET_KEY $BUCKET_NAME $REGION
                sudo systemctl restart apache2

                # install wordpress with wp-cli
                curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
                chmod +x wp-cli.phar
                sudo mv wp-cli.phar /usr/local/bin/wp
                sudo wp core install --path=/var/www/html --allow-root --url=$WP_PUBLIC_IP --title="CloudCompMidterm" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email="example@example.com" --skip-email
                sudo wp plugin install amazon-s3-and-cloudfront --path=/var/www/html --allow-root --activate
                sudo systemctl restart apache2
                EOF
    tags = {
        Name = "cc-midterm-wp"
    }
}

resource "aws_network_interface_attachment" "wp_to_db" {
    device_index = 1
    instance_id = aws_instance.wp_server.id
    network_interface_id = aws_network_interface.wp_to_db.id
}
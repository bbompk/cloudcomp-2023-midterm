#!/bin/bash
sudo apt update;
sudo apt install -y mariadb-server;
sudo systemctl start mariadb;
sudo systemctl enable mariadb;
sudo mysql -u root < mariadb_wp_setup.sql
sudo python3 mariadb_binding_addr.py
sudo systemctl restart mariadb
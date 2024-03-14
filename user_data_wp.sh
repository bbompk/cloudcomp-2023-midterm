#!/bin/bash
git clone https://github.com/bbompk/cloudcomp-2023-midterm.git
cd cloudcomp-2023-midterm/scripts/wordpress
export DB_HOST=10.0.0.22
export WP_PUBLIC_IP=
export WP_ADMIN_USER=admin
export WP_ADMIN_PASS=admin
sudo bash setup.sh

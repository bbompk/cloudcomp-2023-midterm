#!/bin/bash
git clone https://github.com/bbompk/cloudcomp-2023-midterm.git
cd cloudcomp-2023-midterm/scripts/wordpress
export DB_HOST=10.0.0.22
sudo bash setup.sh

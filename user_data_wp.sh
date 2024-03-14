sudo apt update
sudo apt install -y unzip
wget 'https://docs.google.com/uc?export=download&id=1xIt1mbxJE4r0skHAhwxxW_5OiMTOF9gL' -O scripts.zip
unzip scripts.zip
cd scripts/wordpress
sudo bash setup.sh

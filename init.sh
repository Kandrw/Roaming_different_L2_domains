




sudo apt update
sudo apt install iw
sudo apt install isc-dhcp-server
sudo apt install bridge-utils
sudo apt install arping
sudo apt install iputils-arping
sudo apt install libnl-3-dev
sudo apt install libnl-genl-3-dev

sudo ldconfig

git clone git://w1.fi/srv/git/hostap.git
cd hostap

git checkout hostap_2_11

cd hostapd
cp defconfig .config


#sed -i 's/^#CONFIG_DRIVER_NL80211=y/CONFIG_DRIVER_NL80211=y/g' .config

# enable 802.11n and 802.11ac
#sed -i 's/^#CONFIG_IEEE80211N=y/CONFIG_IEEE80211N=y/g' .config
sed -i 's/^#CONFIG_IEEE80211AC=y/CONFIG_IEEE80211AC=y/g' .config

# enable automatic channel selection
sed -i 's/^#CONFIG_ACS=y/CONFIG_ACS=y/g' .config

sed -i 's/^#CONFIG_IEEE80211R=y/CONFIG_IEEE80211R=y/g' .config

#   Build
make



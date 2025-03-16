


WLAN1=wlx90de807a7513
WLAN2=wlx90de8083b88b

WAN1=tap0

ADDR_WAN1=10.0.1.1


sudo modprobe tap
sudo ip tuntap add dev tap0 mode tap


# Запретить трафик от wlx90de807a7513 к wlx90de8083b88b
sudo iptables -A FORWARD -i wlx90de807a7513 -o wlx90de8083b88b -j REJECT

# Запретить трафик от wlx90de8083b88b к wlx90de807a7513
sudo iptables -A FORWARD -i wlx90de8083b88b -o wlx90de807a7513 -j REJECT

# Разрешаем пересылку трафика от eth0 к tap0
sudo iptables -A FORWARD -i wlx90de807a7513 -o tap0 -j ACCEPT
# Разрешаем пересылку трафика от tap0 к eth1
sudo iptables -A FORWARD -i tap0 -o wlx90de8083b88b -j ACCEPT
# Разрешаем обратный трафик
sudo iptables -A FORWARD -i wlx90de8083b88b -o tap0 -j ACCEPT
sudo iptables -A FORWARD -i tap0 -o wlx90de807a7513 -j ACCEPT


sudo ip addr add 10.0.1.1/24 dev tap0
sudo ip link set tap0 up



#удалить
#sudo ip tuntap del dev tap0


# проверить
#sudo iptables -L -v


#sudo iptables -A FORWARD -j LOG --log-prefix "IPTables-FORWARD: "



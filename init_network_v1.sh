


WLAN1=wlx90de807a7513
WLAN2=wlx90de8083b88b

WAN1=virt1

ADDR_WAN1=10.0.1.1

sudo modprobe dummy

sudo ip link add name virt1 type dummy

# Запретить трафик от wlx90de807a7513 к wlx90de8083b88b
sudo iptables -A FORWARD -i wlx90de807a7513 -o wlx90de8083b88b -j REJECT

# Запретить трафик от wlx90de8083b88b к wlx90de807a7513
sudo iptables -A FORWARD -i wlx90de8083b88b -o wlx90de807a7513 -j REJECT

# Разрешаем пересылку трафика от eth0 к virt1
sudo iptables -A FORWARD -i wlx90de807a7513 -o virt1 -j ACCEPT
# Разрешаем пересылку трафика от virt1 к eth1
sudo iptables -A FORWARD -i virt1 -o wlx90de8083b88b -j ACCEPT
# Разрешаем обратный трафик
sudo iptables -A FORWARD -i wlx90de8083b88b -o virt1 -j ACCEPT
sudo iptables -A FORWARD -i virt1 -o wlx90de807a7513 -j ACCEPT


sudo ip addr add 10.0.1.1/24 dev virt1
sudo ip link set virt1 up

# проверить
#sudo iptables -L -v


#sudo iptables -A FORWARD -j LOG --log-prefix "IPTables-FORWARD: "






CON=$1




if [ "$CON" == "up" ]; then



    # Создание пространств имен
    ip netns add ns1
    ip netns add ns2


    # Создание veth пар
    ip link add veth0_ns1 type veth peer name veth1_ns1
    ip link add veth0_ns2 type veth peer name veth1_ns2



    ip link set veth0_ns1 netns ns1
    ip link set veth0_ns2 netns ns2



    #ip addr add 192.168.100.11/24 dev veth1_ns1
    #ip addr add 192.168.100.21/24 dev veth1_ns2

    #ip netns exec ns1 ip addr add 192.168.100.10/24 dev veth0_ns1
    #ip netns exec ns2 ip addr add 192.168.100.20/24 dev veth0_ns2

    ip link set veth1_ns1 up
    ip link set veth1_ns2 up

    ip netns exec ns1 ip link set veth0_ns1 up
    ip netns exec ns2 ip link set veth0_ns2 up


    ip netns exec ns1 ip link add name br0_ns1 type bridge
    ip netns exec ns2 ip link add name br0_ns2 type bridge

    ip link add name br0 type bridge


    ip netns exec ns1 ip link set veth0_ns1 master br0_ns1
    ip netns exec ns2 ip link set veth0_ns2 master br0_ns2


    ip link set veth1_ns1 master br0
    ip link set veth1_ns2 master br0


    ip netns exec ns1 ip addr add 192.168.100.10/24 dev br0_ns1
    ip netns exec ns1 ip link set br0_ns1 up
    
    ip netns exec ns2 ip addr add 192.168.100.20/24 dev br0_ns2
    ip netns exec ns2 ip link set br0_ns2 up

    ip addr add 192.168.100.30/24 dev br0
    ip link set br0 up



elif [ "$CON" == "down" ]; then

    ip link set veth1_ns1 down
    ip link set veth1_ns2 down
    ip link set br0 down

    ip link delete veth1_ns1
    ip link delete veth1_ns2
    ip link delete br0

    
    ip netns delete ns1
    ip netns delete ns2
else 
    echo Unknown command: $1
fi


#ip netns exec ns2 ip route add 192.168.100.0/24 via 192.168.200.1


#

if [ 1 == 0 ]; then


    sudo ip link add name virt2 type dummy
    sudo ip addr add 192.168.100.30/24 dev virt2
    ip link set virt2 up

    sudo iptables -A FORWARD -i veth1_ns1 -o virt2 -j ACCEPT
    sudo iptables -A FORWARD -i virt2 -o veth1_ns2 -j ACCEPT


fi









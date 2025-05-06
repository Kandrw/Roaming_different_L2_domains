


CON=$1
#   different_networks or one_network 
# TYPE=one_network
TYPE=test3

echo 1 > /proc/sys/net/ipv4/conf/all/forwarding

if [ "$TYPE" == "one_network" ]; then
    if [ "$CON" == "up" ]; then

        ip netns add ns1
        ip netns add ns2

        ip link add veth0_ns1 type veth peer name veth1_ns1
        ip link add veth0_ns2 type veth peer name veth1_ns2

        ip link set veth0_ns1 netns ns1
        ip link set veth0_ns2 netns ns2

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

        ip netns exec ns1 ip addr add 10.0.1.10/24 dev br0_ns1
        ip netns exec ns1 ip link set br0_ns1 up
        
        ip netns exec ns2 ip addr add 10.0.1.20/24 dev br0_ns2
        ip netns exec ns2 ip link set br0_ns2 up

        ip addr add 10.0.1.1/24 dev br0
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

fi

#   TEST COMPLETE
if [ "$TYPE" == "test1" ]; then
    if [ "$CON" == "up" ]; then

        ip netns add ns1

        ip link add veth0_ns1 type veth peer name veth1_ns1


        ip link set veth0_ns1 netns ns1


        ip link set veth1_ns1 up

        ip netns exec ns1 ip link set veth0_ns1 up


        ip netns exec ns1 ip addr add 10.0.20.1/24 dev veth0_ns1

        ip addr add 10.0.10.1/24 dev veth1_ns1


        ip netns exec ns1 ip route add 10.0.10.0/24 dev veth0_ns1
        ip route add 10.0.20.0/24 dev veth1_ns1

    elif [ "$CON" == "down" ]; then

        ip link set veth1_ns1 down
        # ip link set veth1_ns2 down
        # ip link set br0 down

        ip link delete veth1_ns1
        # ip link delete veth1_ns2
        # ip link delete br0

        ip netns delete ns1
        # ip netns delete ns2

    else 
        echo Unknown command: $1
    fi

fi





#   TEST COMPLETE
if [ "$TYPE" == "test2" ]; then
    if [ "$CON" == "up" ]; then

        ip netns add ns1
        ip netns add ns2

        ip link add veth0_ns1 type veth peer name veth1_ns1

        ip link set veth0_ns1 netns ns1
        ip link set veth1_ns1 netns ns2


        ip netns exec ns1 ip link set veth0_ns1 up
        ip netns exec ns2 ip link set veth1_ns1 up


        ip netns exec ns1 ip addr add 10.0.10.1/24 dev veth0_ns1
        ip netns exec ns2 ip addr add 10.0.20.2/24 dev veth1_ns1

        ip netns exec ns1 ip route add 10.0.20.0/24 dev veth0_ns1
        ip netns exec ns2 ip route add 10.0.10.0/24 dev veth1_ns1
        
        ip netns exec ns1 ping 10.0.20.2
    elif [ "$CON" == "down" ]; then


        ip netns delete ns1
        ip netns delete ns2

    else 
        echo Unknown command: $1
    fi

fi

#   TEST COMPLETE
if [ "$TYPE" == "test3" ]; then
    if [ "$CON" == "up" ]; then

        ip netns add ns1
        ip netns add ns2

        ip link add veth0_ns1 type veth peer name veth1_ns1
        ip link add veth0_ns2 type veth peer name veth1_ns2

        ip link set veth0_ns1 netns ns1
        ip link set veth0_ns2 netns ns2

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

        ip netns exec ns1 ip addr add 10.0.10.10/24 dev br0_ns1
        ip netns exec ns1 ip link set br0_ns1 up
        
        ip netns exec ns2 ip addr add 10.0.20.20/24 dev br0_ns2
        ip netns exec ns2 ip link set br0_ns2 up

        ip addr add 10.0.30.1/24 dev br0
        ip link set br0 up


        ip netns exec ns1 ip route add 10.0.30.0/24 dev br0_ns1

        ip route add 10.0.10.0/24 dev br0


        ip netns exec ns2 ip route add 10.0.30.0/24 dev br0_ns2
        ip route add 10.0.20.0/24 dev br0


        ip netns exec ns1 ip route add default via 10.0.30.1
        ip netns exec ns2 ip route add default via 10.0.30.1


        # ip netns exec ns1 ip route add 10.0.30.0/24 dev veth0_ns1
        # ip route add 10.0.10.0/24 dev veth1_ns1



        # ip netns exec ns2 ip route add 10.0.10.0/24 dev veth1_ns1

        

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

fi









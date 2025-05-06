









CON=$1

TYPE=test2



if [ "$TYPE" == "test1" ]; then
    if [ "$CON" == "up" ]; then

        ip link add name br1 type bridge
        ip link add name br2 type bridge
        ip link add name br_root type bridge
        

        ip addr add 10.0.10.1/24 dev br1
        ip addr add 10.0.20.1/24 dev br2
        ip addr add 10.0.30.1/24 dev br_root

        ip link set br1 up
        ip link set br2 up
        ip link set br_root up


        ip link add veth0_br1 type veth peer name veth1_br1
        ip link add veth0_br2 type veth peer name veth1_br2

        ip link set veth1_br1 up
        ip link set veth0_br1 up
        ip link set veth0_br2 up
        ip link set veth1_br2 up
        

        ip link set veth0_br1 master br1
        ip link set veth0_br2 master br2

        ip link set veth1_br1 master br_root
        ip link set veth1_br2 master br_root


        # ip route add 10.0.30.0/24 dev br_root
        # ip route add 10.0.30.1 via 10.0.10.1
        

    elif [ "$CON" == "down" ]; then

        ip link del name br1 type bridge
        ip link del name br2 type bridge
        ip link del name br_root type bridge


    else 
        echo Unknown command: $1
    fi

fi

if [ "$TYPE" == "test2" ]; then
    if [ "$CON" == "up" ]; then

       
        ip netns add ns1
        ip netns add ns2

        ip link add veth0_ns1 type veth peer name veth1_ns1
        ip link add veth0_ns2 type veth peer name veth1_ns2

        ip link set veth0_ns1 netns ns1
        ip link set veth0_ns2 netns ns2

        ip link set veth1_ns1 up
        ip link set veth1_ns2 up

        ip link set veth0_ns1 up
        ip link set veth0_ns2 up

        ip link add name br0_ns1 type bridge
        ip link add name br0_ns2 type bridge
        ip link add name br0 type bridge

        ip link set veth0_ns1 master br0_ns1
        ip link set veth0_ns2 master br0_ns2

        ip link set veth1_ns1 master br0
        ip link set veth1_ns2 master br0

        ip addr add 10.0.10.10/24 dev br0_ns1
        ip link set br0_ns1 up
        
        ip addr add 10.0.20.20/24 dev br0_ns2
        ip link set br0_ns2 up

        ip addr add 10.0.30.1/24 dev br0
        ip link set br0 up

        #   routes
        ip route add 10.0.30.0/24 dev br0_ns1
        ip route add default via 10.0.30.1
        ip route add 10.0.10.0/24 dev br0

        ip route add 10.0.30.0/24 dev br0_ns2
        ip route add default via 10.0.30.1
        ip route add 10.0.20.0/24 dev br0


    elif [ "$CON" == "down" ]; then

        echo off


    else 
        echo Unknown command: $1
    fi

fi






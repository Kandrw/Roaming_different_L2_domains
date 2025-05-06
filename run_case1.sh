


CFG1=./config/hostapd/hostapd_iface1_r.conf 
CFG2=./config/hostapd/hostapd_iface2_r.conf


IFACE1=wlx90de807a7513
IFACE2=wlx90de8083b88b

PHY1=phy$(iw dev | grep -B 1 $IFACE1 | grep -oP 'phy#\K\d+')
PHY2=phy$(iw dev | grep -B 1 $IFACE2 | grep -oP 'phy#\K\d+')


NET1=10.0.1.11
NET2=10.0.1.12

PATH_HOSTAPD=./hostap/hostapd


echo $IFACE1 - $PHY1
echo $IFACE2 - $PHY2



start_hostapd() {
    PID_FILE=/run/hostapd.$1.pid
    LOG_FILE=/home/andrey/hostapd_$1.log
    echo $PID_FILE $LOG_FILE $2 $4
    # sudo ip addr add $3/24 dev $1
    # ip netns exec $4 $PATH_HOSTAPD/hostapd -dd -P $PID_FILE -B $2 -t -f $LOG_FILE
    $PATH_HOSTAPD/hostapd -dd -P $PID_FILE -B $2 -t -f $LOG_FILE

    
}


init_network() {
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

    # ip link set $IFACE1 netns ns1
    # ip link set $IFACE2 netns ns2
    # ip netns exec ns1 ip link set $IFACE1 up
    # ip netns exec ns2 ip link set $IFACE2 up
}

deinit_network() {
    ip link set veth1_ns1 down
    ip link set veth1_ns2 down
    ip link set br0 down
    # ip netns exec ns1 ip link set $IFACE1 down
    # ip netns exec ns2 ip link set $IFACE2 down
    # ip link set $IFACE1 netns 1
    # ip link set $IFACE2 netns 1

    ip link delete veth1_ns1
    ip link delete veth1_ns2
    ip link delete br0

    ip netns delete ns1
    ip netns delete ns2
}



while getopts "psudi:" OPTION; do
    case $OPTION in
    s)
        # ip link set $IFACE1 netns ns1
        # ip link set $IFACE2 netns ns2
        if [ "$PHY1" != "phy" ]; then
            iw phy $PHY1 set netns name ns1
            echo iw phy $PHY1 set netns name ns1
            ip netns exec ns1 ip link set $IFACE1 up

        else
            echo $IFACE1: "already initialized or missing"
        fi
        if [ "$PHY2" != "phy" ]; then
            iw phy $PHY2 set netns name ns2
            echo iw phy $PHY2 set netns name ns2
            ip netns exec ns2 ip link set $IFACE2 up
        else
            echo $IFACE2: "already initialized or missing"
        fi

        # iw phy $PHY1 set netns name ns1
        # iw phy $PHY2 set netns name ns2

        # ip netns exec ns1 ip link set $IFACE1 master br0_ns1
        # ip netns exec ns2 ip link set $IFACE2 master br0_ns2

    ;;
    u)
        
        start_hostapd $IFACE1 $CFG1 $NET1 ns1
        # start_hostapd $IFACE2 $CFG2 $NET2 ns2
        


        sudo ps -aux | grep hostapd | grep -v grep
    ;;
    p)
        sudo mkdir -p /var/db
        sudo touch /var/db/dhcpd.leases
        sudo ./dhcp/server/dhcpd -cf ./config/dhcp/dhcpd.conf -pf /var/run/dhcpd.pid wlx90de807a7513
        # echo ./dhcp/server/dhcpd -cf ./config/dhcp/dhcpd.conf -pf /var/run/dhcpd.pid br0
         
        sudo ps -aux | grep dhcp | grep -v grep

    ;;
	d)

        echo ${OPTARG}
        sudo killall dhcpd
        sudo killall hostapd
        sudo ps -aux | grep hostapd | grep -v grep

    ;;
    i)
        if [ "$OPTARG" == "up" ]; then
            init_network

        elif [ "$OPTARG" == "down" ]; then
            deinit_network
        else 
            echo Unknown command: $1
        fi

    ;;
	*)
		echo "Incorrect option"
	;;
	esac
done

if [[ $OPTIND == 1 ]]; then
    echo "Создание разных сетей и запуск hostapd"
    echo "Commands:"
    echo "h - start hostapd"
    echo "d - stop hostapd"
    echo "i - arguments: up - init network, down - deinit network"
    echo "s - move wdev to network namespace"
fi














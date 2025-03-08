


IFACE=wlx90de807a7513



while getopts "id" OPTION; do
    case $OPTION in
    i)
        ip addr add 10.0.1.1/24 dev $IFACE
        systemctl start isc-dhcp-server

    ;;
	d)
        systemctl disable isc-dhcp-server
        systemctl stop isc-dhcp-server
        
    ;;
	*)
		echo "Incorrect option"
	;;
	esac
done











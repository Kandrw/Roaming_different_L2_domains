








PATH_HOSTAPD=../hostapd-2.11/hostapd


#PID_FILE=/run/hostapd.($1).pid



start_hostapd() {
    PID_FILE=/run/hostapd.$1.pid
    LOG_FILE=/home/andrey/hostapd_$1.log
    echo $PID_FILE $LOG_FILE $2
    ip addr add $3/24 dev $1
    sudo $PATH_HOSTAPD/hostapd -dd -P $PID_FILE -B $2 -f $LOG_FILE
}



while getopts "ud" OPTION; do
    case $OPTION in
    u)
        #sudo $PATH_SERVICE/$SERVICE -dd -P $PID_FILE -B $CONFIG_STARTUP -f /home/andrey/hostapd.log
        start_hostapd wlx90de807a7513 ./config/hostapd/hostapd_iface1.conf 10.0.1.1
        start_hostapd wlx90de8083b88b ./config/hostapd/hostapd_iface2.conf 10.0.2.1
        ps | grep hostapd | grep -v grep
        systemctl restart isc-dhcp-server
    ;;
	d)

        echo ${OPTARG}
        systemctl stop isc-dhcp-server
        sudo killall hostapd
        ps | grep hostapd | grep -v grep

    ;;
	*)
		echo "Incorrect option"
	;;
	esac
done

if [[ $OPTIND == 1 ]]; then

    echo "Commands:"
    echo "u - start hostapd"
    echo "d - stop hostapd"
fi















IFACE1=wlx90de807a7513
IFACE2=wlx90de8083b88b

CFG1=./config/hostapd/hostapd_iface1_r.conf 
CFG2=./config/hostapd/hostapd_iface2_r.conf

NET1=10.0.1.11
NET2=10.0.1.12


PATH_HOSTAPD=./hostap/hostapd


#PID_FILE=/run/hostapd.($1).pid



start_hostapd() {
    PID_FILE=/run/hostapd.$1.pid
    LOG_FILE=/home/andrey/hostapd_$1.log
    echo $PID_FILE $LOG_FILE $2
    sudo ip addr add $3/24 dev $1
    sudo $PATH_HOSTAPD/hostapd -dd -P $PID_FILE -B $2 -f $LOG_FILE
}

echo "User: " $USER

while getopts "ud" OPTION; do
    case $OPTION in
    u)
        
        #sudo $PATH_SERVICE/$SERVICE -dd -P $PID_FILE -B $CONFIG_STARTUP -f /home/andrey/hostapd.log
        start_hostapd $IFACE1 $CFG1 $NET1
        start_hostapd $IFACE2 $CFG2 $NET2
        sudo ps -aux | grep hostapd | grep -v grep
        sudo systemctl restart isc-dhcp-server
    ;;
	d)

        echo ${OPTARG}
        sudo systemctl disable isc-dhcp-server
        sudo systemctl stop isc-dhcp-server
        sudo killall hostapd
        sudo ps -aux | grep hostapd | grep -v grep

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













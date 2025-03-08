







PATH_SERVICE=./hostapd-2.11/hostapd
SERVICE=hostapd
CONFIG_STARTUP=./config/hostapd_v3.conf
PID_FILE=/run/hostapd.wlx90de807a7513.pid

while getopts "ud" OPTION; do
    case $OPTION in
    u)
        sudo $PATH_SERVICE/$SERVICE -dd -P $PID_FILE -B $CONFIG_STARTUP -f /home/andrey/hostapd.log
        
    ;;
	d)
        echo ${OPTARG}
        sudo killall $SERVICE
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









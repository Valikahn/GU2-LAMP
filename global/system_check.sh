###################################################
##												 ##
##  SYSTEM CHECK								 ##
##												 ##
###################################################


###--------------------  QUICK VERSION CHECK  --------------------###
##
echo "Script Version:  $SCRIPTVERSION.$BUILD"
echo -n "STARTING"; sleep 1
echo -ne "\rSTARTING...PLEASE WAIT."; sleep 2
echo -ne "\rSTARTING...PLEASE WAIT.."; sleep 3
echo -ne "\rSTARTING...PLEASE WAIT..."; sleep 4
echo -ne "\rSTARTING...PLEASE WAIT...."; sleep 5
echo -e "\rDONE                                           "

echo
sleep 2

###--------------------  SUDO/ROOT CHECK  --------------------###
##
if [ "$(id -u)" -ne 0 ]; then 
	echo -n "SUDO PERMISSION CHECK..."; 	sleep 5
	echo -e "\rSUDO PERMISSION CHECK... ${RED}[  ACCESS DENIED  ]${NORMAL}"; sleep 3
	echo
	echo "Error 126: Command cannot execute."
	echo "This error code is used when a command is found but is not executable.  Execute as root/sudo!"
	exit 126
else
	echo -n "SUDO PERMISSION CHECK..."; 	sleep 5
	echo -e "\rSUDO PERMISSION CHECK... ${GREEN}[  ACCESS GRANTED  ]${NORMAL}"; sleep 3
    clear
fi

###--------------------  COLLECTING SYSTEM DATA  --------------------###
##
clear
echo -n "DATA COLLECTION..."
sleep 3


if [ -f /etc/os-release ]; then
    . /etc/os-release
    ## DEB
    if [[ "$ID" == "ubuntu" ]]; then
        VERSION_NUMBER=$(echo "$VERSION" | grep -oP '^\d+\.\d+')
        DISTRO=$NAME
        echo -e "\rDATA COLLECTION... ${GREEN}[  OK!  ]${NORMAL}"
        sleep 3
    ## RHEL
    elif [[ "$ID" == "rhel" || "$ID" == "centos" ]]; then
        VERSION_NUMBER=$(echo "$VERSION_ID" | grep -oP '^\d+')
        DISTRO=$NAME
        echo -e "\rDATA COLLECTION... ${GREEN}[  OK!  ]${NORMAL}"
        sleep 3
    ## WTF
    else
        echo "Unsupported distribution."
        echo -e "\rDATA COLLECTION... ${BOLD}${RED}[  FAILED!  ]${NORMAL}"
	    sleep 3
        exit 1
    fi

# DEB FALLBACK
elif [ -f /etc/lsb-release ]; then
    . /etc/lsb-release
    DISTRO=$DISTRIB_ID
    echo -e "\rDATA COLLECTION... ${GREEN}[  OK!  ]${NORMAL}"
    sleep 3
else
    echo -e "\rDATA COLLECTION... ${BOLD}${RED}[  FAILED!  ]${NORMAL}"
	sleep 3
	echo "ERROR: RHEL or DEBIAN release files could not be found! [OPERATING SYSTEM DETECTION]"
	exit 1
fi

###--------------------  NETWORK MANAGER (NMCLI) CHECK  --------------------###
##
if command -v nmcli >/dev/null 2>&1; then
    NMCLI_DEV_SHOW
else
	BUILT_IN_IPA
fi

###--------------------  PASSWORD COLLECTION  --------------------###
##
PSWD=$(PASSGEN)
MYSQL_ROOT_PASSWORD=$(PASSGEN)

###--------------------  ENS LINK UP OR DOWN  --------------------###
##
if ! ip link show "$ENS" > /dev/null 2>&1; then
    echo "Interface $ENS does not exist."
    exit 1
fi

STATE=$(cat /sys/class/net/$ENS/operstate)

if [ "$STATE" = "down" ]; then
    echo "Interface $ENS is not connected. Attempting to bring it up..."

    ip link set "$ENS" up
    COUNTDOWN 5

    NEW_STATE=$(cat /sys/class/net/$ENS/operstate)
    
    if [ "$NEW_STATE" = "up" ]; then
        echo "Interface $ENS successfully brought up."
    else
        echo "Failed to bring up interface $ENS."
        exit 1
    fi
else
    echo "Interface $ENS is already connected."
fi

###--------------------  CHECK FOR STATIC IP ADDRESS  --------------------###
##
IFACE=$(ip link show | awk -F': ' '/^[0-9]+: [^lo]/ {print $2; exit}')
IP_DATA=$(ip -4 addr show dev $IFACE | grep 'inet ' | awk '{ print $2 }' | cut -d'/' -f1)

if [ -n "$IP_DATA" ]; then
    IP_ADDRESS=$IP_DATA
    if grep -q "iface $IFACE inet static" /etc/network/interfaces 2>/dev/null || \
       grep -q "addresses:" /etc/netplan/* 2>/dev/null; then
        clear
        echo "Static IP is configured for interface $IFACE"
        STATIC_SET=1
        COUNTDOWN 5
    else
        clear
        echo "Interface $IFACE is likely using DHCP (Dynamic IP)"
        echo "A static IP address is preferable when installing a LAMP server, for several reasons!"
        echo
        echo "Please note!  If connected using SSH, by continuing this could disrupt your connection and the installation will fail."
        echo
        echo -e "${RED}[  WARNING  ]${NORMAL} Continue at your own risk!"
        echo

        while true; 
        do
            read -rp "Would you like to configure a static IP address? (y/n)" CONF_STATIC_IP
            case "$CONF_STATIC_IP" in
                y|Y)
                    echo
                    echo "Redirecting to static IP configuration..."
                    COUNTDOWN 5
                    break
                    ;;
                n|N)
                    echo
                    echo "Proceeding without a static IP address... Redirecting..."
                    STATIC_IP_CONFIG=1
                    COUNTDOWN 5
                    break
                    ;;
                *)
                    echo "Please enter y/Y or n/N."
                    ;;
            esac
        done
    fi

    if [ "$STATIC_SET" -eq 1 ]; then
        :
    else
        if [[ "$DISTRO" == "Ubuntu" ]]; then
            source ./deb/deb_static_ip.sh

        elif [[ "$DISTRO" == "RedHat" ]] || [[ "$DISTRO" == "CentOS" ]]; then
            source ./rpm/conf/rpm_static_ip.sh

        else
            echo
            echo "Oops - unsupported or unrecognized distribution: $DISTRO"
            exit 1
        fi
    fi

else
    clear
    echo "No IP address is assigned to interface $IFACE"
    echo "Script cannot continue until the adapter is online with an IP Address assigned."
    exit 1
fi
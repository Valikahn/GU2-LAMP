###################################################
##												 ##
##  STATIC IP ADDRESS							 ##
##												 ##
###################################################


clear

while true; 
do
    if [ "$STATIC_IP_CONFIG" != "1" ]; then
        ###--------------------  IP ADDRESS ENTRY / CHECK RECALL FUNCTION  --------------------###
        ##

        while true; do
            read -p "Please enter the static IP address you wish to set: " STATIC_IP
            if VALID_IP_ADDRESS $STATIC_IP; then
                break
            else
                echo "Invalid IP address format: $STATIC_IP"
            fi
        done
    fi

    while true; 
    do
        read -p "Please enter your default gateway: " GATEWAY
        if VALID_IP_ADDRESS $GATEWAY; then
            break
        else
            echo "Invalid IP address format: $GATEWAY"
        fi
    done

    while true; 
    do
        read -p "Please enter DNS servers (comma-separated, e.g., 8.8.8.8,8.8.4.4): " DNS
        IFS=',' read -ra DNS_ARRAY <<< "$DNS"
        ALL_VALID_ENTRIES=1

        for DNS_IP in "${DNS_ARRAY[@]}"; do
            if ! VALID_IP_ADDRESS "$DNS_IP"; then
                echo "Invalid IP address format: $DNS_IP"
                ALL_VALID_ENTRIES=0
            fi
        done

        if [ "$ALL_VALID_ENTRIES" -eq 1 ]; then
            break
        else
            echo "Please enter valid IP addresses."
        fi
    done

    read -p "Please enter the subnet mask in CIDR notation (e.g., 24 for 255.255.255.0): " CIDR

    ###--------------------  GATHERED DATA  --------------------###
    ##
    INTERFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -n 1)

    clear
    echo
    if [ -n "$STATIC_IP" ]; then
        echo "Setting up static IP address:"
        echo
        echo "Static IP Address: $STATIC_IP"
    else
        echo "${RED}[  STATIC IP ADDRESS IS NOT CONFIGURED  ]${NORMAL}"
        echo
        echo "Using Dynamic IP Address: $IP_ADDRESS"
    fi
    echo "Subnet Mask CIDR: $CIDR"
    echo "Gateway: $GATEWAY"
    echo "DNS Servers: $DNS"
    echo "Network Interface: $INTERFACE"
    echo

    while true; 
    do
        echo "${RED}[  IF THIS INFORMATION IS INCORRECT YOUR NIC WILL BE MISCONFIGURED  ]${NORMAL}"
        echo
        read -p "Is the information above correct?" YN
        case $YN in
            [Yy]* ) echo; break 2 ;;
            [Nn]* ) clear; break ;;
            * ) echo "Please answer yes or no." ;;
        esac
    done
done


###################################################
##												 ##
##  SCRIPT RUN									 ##
##												 ##
###################################################


###--------------------  UPDATE SYSTEM AND INSTALL NETWORK MANAGER  --------------------###
##
echo "${GREEN}[ 1. ] INSTALL NETWORK MANAGER AND OPEN VSWITCH${NORMAL}"
apt install -y network-manager > /dev/null 2>&1
apt install -y openvswitch-switch > /dev/null 2>&1

###--------------------  DISABLE SYSTEM NETWORKD SERVICE WAIT WHILE BOOT  --------------------###
##
echo "${GREEN}[ 2. ] DISABLE SYSTEM NETWORKD SERVICE WAIT WHILE BOOT${NORMAL}"
systemctl disable systemd-networkd-wait-online.service > /dev/null 2>&1

###--------------------  EDIT GLOBALLY MANAGED DEVICES  --------------------###
##
echo "${GREEN}[ 3. ] EDIT GLOBALLY MANAGED DEVICES${NORMAL}"
CONF_FILE="/usr/lib/NetworkManager/conf.d/10-globally-managed-devices.conf"
tee $CONF_FILE > /dev/null <<EOL
[keyfile]
unmanaged-devices=*,except:type:wifi,except:type:gsm,except:type:cdma,except:type:ethernet,except:type:wireguard
EOL

###--------------------  EDIT NETWORK MANAGER  --------------------###
##
echo "${GREEN}[ 4. ] EDIT NETWORK MANAGER${NORMAL}"
NM_CONF="/etc/NetworkManager/NetworkManager.conf"
    if grep -q "\[ifupdown\]" $NM_CONF; then
      sed -i '/\[ifupdown\]/,/\[/{s/managed=false/managed=true/}' $NM_CONF
    else
      echo -e "\n[ifupdown]\nmanaged=true" | sudo tee -a $NM_CONF > /dev/null 2>&1
    fi

###--------------------  DISABLE CLOUD-INIT NETWORK CONFIGURATION  --------------------###
##
echo "${GREEN}[ 5. ] DISABLE CLOUD-INIT NETWORK CONFIGURATION${NORMAL}"
CLOUD_CFG="/etc/cloud/cloud.cfg.d/99-disable-network-config.cfg"
tee $CLOUD_CFG > /dev/null 2>&1 <<EOL
network: {config: disabled}
EOL

###--------------------  RESTART NETWORK MANAGER  --------------------###
##
echo "${GREEN}[ 6. ] RESTART NETWORK MANAGER${NORMAL}"
systemctl restart NetworkManager > /dev/null 2>&1

###--------------------  CONFIGURE NETWORK INTERFACE USING NMCLI  --------------------###
##
echo "${GREEN}[ 7. ] CONFIGURE NETWORK INTERFACE USING NMCLI${NORMAL}"
    
if [ -n "$STATIC_IP" ]; then
    nmcli device set $STATIC_IP managed yes > /dev/null 2>&1
else
    nmcli device set $IP_ADDRESS managed yes > /dev/null 2>&1
fi

ip addr add $IP_A_CIDR dev $INTERFACE > /dev/null 2>&1
nmcli device connect $INTERFACE > /dev/null 2>&1

ENS=$(nmcli dev status | grep '^ens' | awk '{ print $1 }')

if [ -n "$STATIC_IP" ]; then
    nmcli con modify $ENS ipv4.addresses $STATIC_IP/$CIDR > /dev/null 2>&1
else
    nmcli con modify $ENS ipv4.addresses $IP_ADDRESS/$CIDR > /dev/null 2>&1
fi
    
nmcli con modify $ENS ipv4.gateway $GATEWAY > /dev/null 2>&1
nmcli con modify $ENS ipv4.dns $DNS > /dev/null 2>&1
nmcli con modify $ENS ipv4.method manual > /dev/null 2>&1
sudo nmcli con up $ENS > /dev/null 2>&1

###--------------------  REMOVE NETPLAN FILES AND CREATE A NEW  --------------------###
##
echo "${GREEN}[ 8. ] REMOVE NETPLAN FILES AND CREATE A NEW${NORMAL}"
rm -rf /etc/netplan/* > /dev/null 2>&1
NETPLAN_FILE="/etc/netplan/00-installer-config.yaml" > /dev/null 2>&1

if [ -z "$STATIC_IP" ]; then
    FINAL_IP=$IP_ADDRESS
else
    FINAL_IP=$STATIC_IP
fi

sudo tee $NETPLAN_FILE > /dev/null 2>&1 <<EOL
## This is the network config written by Neil Jamieson for Insentrica Lab!
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    $INTERFACE:
      dhcp4: no
      addresses:
      - $FINAL_IP/$CIDR
      nameservers:
        addresses:
$(IFS=','; for ip in $DNS; do echo "        - $ip"; done)
      routes:
      - to: default
        via: $GATEWAY
EOL

###--------------------  NETPLAN SECURE AND APPLY  --------------------###
##
echo "${GREEN}[ 9. ] NETPLAN SECURE AND APPLY${NORMAL}"
chmod 600 /etc/netplan/00-installer-config.yaml
netplan apply

###--------------------  EXECUTION COMPLETE  --------------------###
##
echo "${GREEN}[ 10. ] EXECUTION COMPLETE${NORMAL}"
systemctl restart NetworkManager

echo
echo "Network has been configured..."
COUNTDOWN 5
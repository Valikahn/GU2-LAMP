###################################################
##												 ##
##  PRE CONFIGURATION							 ##
##												 ##
###################################################


clear

## DEB
if [[ "$DISTRO" == "Ubuntu" ]]; then

	###--------------------  NEEDRESTART PREVENTION  --------------------###
	##
	NEED_CONF_FILE="/etc/needrestart/needrestart.conf"
	UBUNTU_VERSION=$(lsb_release -rs)

	if [[ "$UBUNTU_VERSION" == "22.04" ]]; then
		if grep -q '^\$nrconf{restart} = '\''a'\'';' "$NEED_CONF_FILE"; then
			echo "The setting is already set to '\$nrconf{restart} = '\''a'\'';'. No changes made."
		else
			cp "$NEED_CONF_FILE" "$NEED_CONF_FILE.bak"
			if grep -q "^#\$nrconf{restart} = 'i';" "$NEED_CONF_FILE"; then
				sed -i "s/^#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/" "$NEED_CONF_FILE"
				echo "Configuration updated: \$nrconf{restart} is now set to 'a'."
			else
				echo "No matching line to uncomment and change."
			fi
		fi
	else
		echo "This script only runs on Ubuntu 22.04. Detected version: $UBUNTU_VERSION."
	fi

## RPM
elif [[ "$DISTRO" == "RedHat" ]] || [[ "$DISTRO" == "CentOS" ]]; then
	echo "RHEL Deployment Coming Soon"
	exit

## WTF
else
	echo "ERROR:  Do not know what Linux distribution this is!"
	echo "This script will now end!"
	exit 1

fi

###--------------------  VHOST INFORMAION GATHERING  --------------------###
##
clear
read -p "Are you going to be deploying vHosts? (Yy/Nn): " VHOST_ANSWER
if [[ "$VHOST_ANSWER" == "Y" ]] || [[ "$VHOST_ANSWER" == "y" ]] || [[ "$VHOST_ANSWER" == "YES" ]] || [[ "$VHOST_ANSWER" == "yes" ]] || [[ "$VHOST_ANSWER" == "Yes" ]]; then
		VHOST_ANSWER=1
        echo "You will be prompted later for more input for the vHost configuration..."
        COUNTDOWN 5
		break
	elif [[ "$VHOST_ANSWER" == "N" ]] || [[ "$VHOST_ANSWER" == "n" ]] || [[ "$VHOST_ANSWER" == "NO" ]] || [[ "$VHOST_ANSWER" == "no" ]] || [[ "$VHOST_ANSWER" == "No" ]]; then
        VHOST_ANSWER=0
	    break
    else
	    echo "Invalid choice - try again please. Enter 'Yy' or 'Nn'."
	    echo
    fi
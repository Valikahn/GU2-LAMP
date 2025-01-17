###################################################
##                                               ##
##  CMS DEPLOY		                             ##
##                                               ##
###################################################


###--------------------  DRUPAL CMS DEPLOY  --------------------###
##
DRUPAL_CMS_DEPLOY() {
if wget -O /tmp/drupal.tar.gz https://www.drupal.org/download-latest/tar.gz; then
    if tar -xzf /tmp/drupal.tar.gz -C /var/www/public_html/$VHOST_NAME/cms --strip-components=1; then
        echo "Drupal extracted successfully."
    else
        echo "Failed to extract Drupal."
        COUNTDOWN 5
    fi
    rm -f /tmp/drupal.tar.gz
else
    echo "Failed to download Drupal."
    COUNTDOWN 5
fi
}

###--------------------  JOOMLA CMS DEPLOY  --------------------###
##
JOOMLA_CMS_DEPLOY() {
if wget -O /tmp/joomla.zip https://downloads.joomla.org/cms/joomla5/5-1-4/Joomla_5-1-4-Stable-Full_Package.zip; then
    if unzip /tmp/joomla.zip -d /var/www/public_html/$VHOST_NAME/cms; then
        echo "Joomla extracted successfully."
    else
        echo "Failed to extract Joomla."
        COUNTDOWN 5
    fi
    rm -f /tmp/joomla.zip
else
    echo "Failed to download Joomla."
    COUNTDOWN 5
fi
}

###--------------------  WORDPRESS CMS DEPLOY  --------------------###
##
WORDPRESS_CMS_DEPLOY() {
if wget -O /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz; then
    if tar -xzf /tmp/wordpress.tar.gz -C /var/www/public_html/$VHOST_NAME/cms --strip-components=1; then
        echo "WordPress extracted successfully."
    else
        echo "Failed to extract WordPress."
        COUNTDOWN 5
    fi
    rm -f /tmp/wordpress.tar.gz
else
    echo "Failed to download WordPress."
    COUNTDOWN 5
fi
}

###--------------------  GRAV CMS DEPLOY  --------------------###
##
GRAV_CMS_DEPLOY() {
if wget -O /tmp/grav.zip https://getgrav.org/download/core/grav/latest; then
    if unzip /tmp/grav.zip -d /var/www/public_html/$VHOST_NAME/cms; then
        echo "Grav extracted successfully."
    else
        echo "Failed to extract Grav."
        COUNTDOWN 5
    fi
    rm -f /tmp/grav.zip
else
    echo "Failed to download Grav."
    COUNTDOWN 5
fi
}

###--------------------  MOXD CMS DEPLOY  --------------------###
##
MODX_CMS_DEPLOY() {
if wget -O /tmp/modx.zip https://modx.com/download/latest; then
    if unzip /tmp/modx.zip -d /var/www/public_html/$VHOST_NAME/cms; then
        echo "MODX extracted successfully."
    else
        echo "Failed to extract MODX."
        COUNTDOWN 5
    fi
    rm -f /tmp/modx.zip
else
    echo "Failed to download MODX."
    COUNTDOWN 5
fi
}
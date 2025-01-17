###--------------------  CREATE SELF-SIGNED CERTIFICATE  --------------------###
##
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=UK/ST=Cromarty/L=Alness/O=MAWS_HP2V48/OU=H16S35/CN=$HST" >/dev/null 2>&1
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048 >/dev/null 2>&1
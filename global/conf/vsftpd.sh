###--------------------  INSTALL VSFTPD TO ENABLE FTP ACCESS  --------------------###
##
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/vsftpd.key -out /etc/ssl/private/vsftpd.crt -subj "/C=UK/ST=Cromarty/L=Alness/O=MAWS_HP2V48/OU=H16S35/CN=$HST"

CREATE_RANDOM_PORT
FTP_PORT=$NEW_PORT

sed -i 's/#ssl_enable=YES/ssl_enable=YES/' /etc/vsftpd.conf
echo "rsa_cert_file=/etc/ssl/private/vsftpd.crt" | tee -a /etc/vsftpd.conf
echo "rsa_private_key_file=/etc/ssl/private/vsftpd.key" | tee -a /etc/vsftpd.conf
echo "ssl_tlsv1=YES" | tee -a /etc/vsftpd.conf
echo "ssl_sslv2=NO" | tee -a /etc/vsftpd.conf
echo "ssl_sslv3=NO" | tee -a /etc/vsftpd.conf

echo "listen_port=$FTP_PORT" | tee -a /etc/vsftpd.conf
echo "allow_anon_ssl=NO" | tee -a /etc/vsftpd.conf
echo "force_local_data_ssl=YES" | tee -a /etc/vsftpd.conf
echo "force_local_logins_ssl=YES" | tee -a /etc/vsftpd.conf
echo "ssl_ciphers=HIGH" | tee -a /etc/vsftpd.conf
echo "require_ssl_reuse=NO" | tee -a /etc/vsftpd.conf

echo "pasv_enable=YES" | tee -a /etc/vsftpd.conf
echo "pasv_min_port=10000" | tee -a /etc/vsftpd.conf
echo "pasv_max_port=10100" | tee -a /etc/vsftpd.conf
echo "write_enable=YES" | tee -a /etc/vsftpd.conf
echo "local_umask=022" | tee -a /etc/vsftpd.conf

cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
sed -i "/^#listen_port/c\listen_port $FTP_PORT" /etc/vsftpd.conf

if ufw status | grep -q active; then
    if ! ufw status | grep -q "$FTP_PORT/tcp"; then
        ufw allow $FTP_PORT/tcp
        ufw reload
    fi
fi
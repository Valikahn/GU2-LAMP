###--------------------  INDEX.HTML  --------------------###
#
echo "  <!DOCTYPE html>" >> /var/www/html/index.html
echo "  <html lang="en">" >> /var/www/html/index.html
echo "    <div align='center'>" >> /var/www/html/index.html
echo "      <a href='https://github.com/Valikahn/lamp' target='_blank'>" >> /var/www/html/index.html
echo "        <img alt='lamp' src='img/lamp_img.png'>" >> /var/www/html/index.html
echo "      </a>" >> /var/www/html/index.html
echo "    </div>" >> /var/www/html/index.html
echo "    <head>" >> /var/www/html/index.html
echo "		<link rel='stylesheet' type='text/css' href='css/styles.css'>" >> /var/www/html/index.html
echo "      <title>LAMP (Linux, Apache, MySQL and PHP)</title>" >> /var/www/html/index.html
echo "      <meta charset='UTF-8'>" >> /var/www/html/index.html
echo "      <meta name='viewport' content='width=device-width, initial-scale=1.0'>" >> /var/www/html/index.html
echo "      <header>" >> /var/www/html/index.html
echo "        <nav>" >> /var/www/html/index.html
echo "          <ul>" >> /var/www/html/index.html
echo "            <li><a align='center' href='http://$IP_ADDRESS' target='_blank'>HTTP Unsecure</a></li>" >> /var/www/html/index.html
echo "            <li><a align='center' href='https://$IP_ADDRESS' target='_blank'>HTTPS Secure</a></li>" >> /var/www/html/index.html
echo "            <li><a align='center' href='https://$IP_ADDRESS/phpmyadmin' target='_blank'>phpMyAdmin / MySQL</a></li>" >> /var/www/html/index.html
echo "            <li><a align='center' href='https://$IP_ADDRESS:10000' target='_blank'>Webmin</a></li>" >> /var/www/html/index.html
echo "          </ul>" >> /var/www/html/index.html
echo "        </nav>" >> /var/www/html/index.html
echo "      </header>" >> /var/www/html/index.html
echo "    </head>" >> /var/www/html/index.html
echo "    <body>" >> /var/www/html/index.html
echo "      <h2 align='center'>_________________________________________________</h2><br>" >> /var/www/html/index.html
echo "      <h2 align='center'>LAMP (Linux, Apache, MySQL and PHP)</h2><br>" >> /var/www/html/index.html
echo "      <h3 align='center'>Apache, MySQL, phpMyAdmin, Webmin and VSFTPD inc FTP and Self-Signed Certificate to work with Apache and VSFTPD.</h3><br>" >> /var/www/html/index.html
echo "      <h3 align='center'>Program Version: $SCRIPTVERSION.$BUILD</h3>" >> /var/www/html/index.html
echo "      <h3 align='center'>File Name: $FILENAME</h3>" >> /var/www/html/index.html
echo "      <h3 align='center'>Written by: Neil Jamieson</h3><br>" >> /var/www/html/index.html
echo "      <h3 align='center'>Please refer to the <a href='https://github.com/Valikahn/lamp/blob/master/README.md' target='_blank'>GitHub README</a> file for specific information about this script.</h3><br>" >> /var/www/html/index.html
echo "      <h3 align='center'>phpMyAdmin Username: phpMyAdmin | Password: $PSWD</h3>" >> /var/www/html/index.html
echo "      <h3 align='center'>Webmin Username: $USER_NAME | Password: [SHELL PASSWORD]</h3><br>" >> /var/www/html/index.html
echo "      <h3 align='center'>FTP IP: $IP_ADDRESS | FTP Port: $FTP_PORT</h3>" >> /var/www/html/index.html
echo "      <h3 align='center'>Username: $USER_NAME | Password: [SHELL PASSWORD] | Encryption: Use explicit FTP over TLS</h3><br>" >> /var/www/html/index.html
echo "      <h3 align='center'>SSH IP: $IP_ADDRESS | SSH Port: $SSH_PORT</h3>" >> /var/www/html/index.html
echo "      <h3 align='center'>Username: $USER_NAME | Password: [SHELL PASSWORD]</h3><br>" >> /var/www/html/index.html
echo "      <h3 align='center'>Please ensure you update your connection settings accordingly.</h3>" >> /var/www/html/index.html
echo "      <h2 align='center'>_________________________________________________</h2><br>" >> /var/www/html/index.html
echo "      <footer>" >> /var/www/html/index.html
echo "        <div style='text-align: center; padding: 10px; background-color: #333; color: white;'>" >> /var/www/html/index.html
echo "          <p>Copyright &copy; 2024 <a href='mailto:000705@uhi.ac.uk' style='color: white; margin-right: 15px;'>Neil Jamieson</a></p>" >> /var/www/html/index.html
echo "          <nav>" >> /var/www/html/index.html
echo "            <a href='http://$IP_ADDRESS/phpinfo.php' target='_blank' style='color: white; margin-right: 15px;'>PHP Info</a>" >> /var/www/html/index.html
echo "            <a href='https://github.com/Valikahn/lamp/issues' target='_blank' style='color: white; margin-right: 15px;'>Bugs & Issues</a>" >> /var/www/html/index.html
echo "            <a href='https://github.com/Valikahn/lamp/tree/master/change_logs' target='_blank' style='color: white; margin-right: 15px;'>Change Log</a>" >> /var/www/html/index.html
echo "            <a href='https://www.gnu.org/licenses/gpl-3.0.en.html' target='_blank' style='color: white; margin-right: 15px;'>GPLv3 Licence</a>" >> /var/www/html/index.html
echo "            <a href='https://nwh.uhi.ac.uk/en/' target='_blank' style='color: white; margin-right: 15px;'>NWH UHI</a><br><br>" >> /var/www/html/index.html
echo "            <a style='color: white;'>Program designed, developed, and tested while at university studying Computer Science for module 'Managing a Web Server (MAWS_HP2V48)</a><br>" >> /var/www/html/index.html
echo "          </nav>" >> /var/www/html/index.html
echo "        </div>" >> /var/www/html/index.html
echo "      </footer>" >> /var/www/html/index.html
echo "    </body>" >> /var/www/html/index.html
echo "  </html>" >> /var/www/html/index.html

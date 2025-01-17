RELEASE DATE
------------

Date: 24 September 2024<br />
Released Version: 24.09.24<br />


KNOWN ISSUES
------------
None!


RESOLVED ISSUES
---------------

###--------------------  INSTALL APACHE AND CONFIGURE DIRECTORY PERMISSIONS  --------------------###<br />
Removed the index.html file from the web directory and touched out a new index.html file to echo the data required in order to store variables from the shell script.

###--------------------  HOST DATA COLLECTION  --------------------###<br />
Included a application check for NMCLI and if not installed prompt user to install or use default method.
In host data collection this will be collected using the method the user requests (NMCLI or ifconfig).

###--------------------  CONFIGURE VSFTPD/FTP TO INCLUDE SSL (FTPS)  --------------------###<br />
Configure random port to become accessible when using VSFTPD
Included TCP ports 10000:10100 into the firewall; these are passive ports that VSFTPD uses.

###--------------------  README FILE UPDATED  --------------------###<br />
README file updated to include the additional applications to be installed during automation.
These include dependencies, supporting, and enhancement applications. Extensions, network tools and security modules.


NEW ADDITIONS
-------------

###--------------------  FILE STRUCTURE CHANGE  --------------------###<br />
Added "include" directure with .sh files including functions and variables for the main script to inject when needed.
This saving on resources on the host; not loading one file into memory and only accessing the data when needed.

###--------------------  IONCUBE LOADER  --------------------###<br />
Encoding support for PHP 8.2, 8.1, 7.4 and many others.
Unique runtime compatibility allowing 8.2 encoded files to run on up to PHP 8.3 without re-encoding.

###--------------------  STATIC IP ADDRESS  --------------------###<br />
Static IP address check as this is recommended to build and configure a WebServer.
This will check using default method if NMCLI is not installed.
This will prompt if NMCLI is not installed if you would like to install and continue.
## CHANGE LOG
-------------

RELEASE DATE
------------

Date: 08 October 2024<br />
Released Version: 24.10.08<br />


KNOWN ISSUES
------------
These two CMS applications are not installing correcting and there is testing taking place to implement this fix.
- Grav v1.7.46+
- ModX v3.0.5+


RESOLVED ISSUES
---------------
No known issues were resolved.  Working on features and updates.


UPDATES
-------
Some minor updates to the code and its accessibility to the host in order to make the modular design to be less resourse hungry.
A script has been included into a new file at location '/global/conf/pre_conf.sh' - this is coded to only stop Ubuntu 20.04 an 22.04 from prompting and allowing complete automation.
Work has started to include RHEL into the fold and this sould be evident in the next major update.


NEW ADDITIONS
-------------

###--------------------  VHOST CREATION INCLUDED  --------------------###<br />
Included an option to deploy/configure vHosts into /var/www/public_html/
This feature will also ask if a CMS application is to be downloaded and moved to a 'cms' directory in the vHost location.
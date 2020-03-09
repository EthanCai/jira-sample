#!/bin/bash

yum -y install openldap openldap-servers openldap-clients openldap-servers-sql openldap-devel compat-openldap migrationtools
cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
hown ldap. /var/lib/ldap/DB_CONFIG
systemctl start slapd
systemctl enable slapd

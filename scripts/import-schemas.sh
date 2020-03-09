#!/bin/bash

for ldif in /etc/openldap/schema/*.ldif;
do
    ldapadd -Y EXTERNAL -H ldapi:/// -f $ldif
done

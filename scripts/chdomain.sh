#!/bin/bash

ldapmodify -Y EXTERNAL -H ldapi:/// -f chdomain.ldif

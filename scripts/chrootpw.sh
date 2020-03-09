#!/bin/bash

ldapadd -Y EXTERNAL -H ldapi:/// -f chrootpw.ldif

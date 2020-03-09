#!/bin/bash


ldapadd -x -D cn=Manager,dc=srv,dc=world -W -f basedomain.ldif

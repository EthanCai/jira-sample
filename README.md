# 介绍

这个项的目的是搭建一套jira的测试环境，验证 jira、openldap 的集成方案。

# 安装OpenLDAP

```sh
pushd scripts

./disable-selinux.sh
./install-ldap.sh
./chroopw.sh
./import-schemas.sh
./chdomain.sh
./bashdomain.sh

popd
```

# 参考

- [install openldap](https://www.server-world.info/en/note?os=CentOS_7&p=openldap&f=1)
- [disable selinux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/sect-security-enhanced_linux-enabling_and_disabling_selinux-disabling_selinux)

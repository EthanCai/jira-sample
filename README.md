# 介绍

这个项的目的是搭建一套jira的测试环境，验证 jira、openldap 的集成方案。

# 安装OpenLDAP

```sh
pushd scripts

./disable-selinux.sh
./install-ldap.sh
./chroopw.sh    # 密码是111
./import-schemas.sh
./chdomain.sh
./basedomain.sh
./ldapuser.sh   # 创建新用户，密码111

popd
```

# 安装MySQL

参考：
- https://dev.mysql.com/doc/refman/5.7/en/linux-installation-yum-repo.html


## 第一步

```sh
wget https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
sudo rpm -ivh mysql80-community-release-el7-3.noarch.rpm
sed -i 's/enabled=1/enabled=0/' /etc/yum.repos.d/mysql-community.repo
yum --enablerepo=mysql57-community install mysql-community-server

sudo grep 'temporary password' /var/log/mysqld.log  # 获取root初始密码

mysql_secure_installation
```

`vim /etc/my.cnf`修改MySQL配置

```
[client]
default-character-set=utf8mb4

[mysql]
default-character-set=utf8mb4


[mysqld]
collation-server = utf8mb4_unicode_ci
init_connect='SET collation_connection = utf8mb4_unicode_ci;'
init-connect='SET NAMES utf8mb4'
character-set-server = utf8mb4

### 以上为新增配置 ###

datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```

重启mysql


## 第二步

创建jira数据库，初始化jira用户

```
CREATE DATABASE jira DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER 'jira'@'%' IDENTIFIED BY 'P@ssw0rd!';

GRANT ALL ON jira.* to 'jira'@'%';
FLUSH PRIVILEGES;
```


# 安装JIRA

```
wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.12.3-x64.bin
chmod +x atlassian-jira-software-7.12.3-x64.bin
./atlassian-jira-software-7.12.3-x64.bin

cd /vagrant
tar -xzvf mysql-connector-java-5.1.48.tar.gz
cd mysql-connector-java-5.1.48
cp mysql-connector-java-5.1.48-bin.jar /opt/atlassian/jira/atlassian-jira/WEB-INF/lib/

cp /opt/atlassian/jira/atlassian-jira/WEB-INF/lib/atlassian-extras-3.2.jar /opt/atlassian/jira/atlassian-jira/WEB-INF/lib/atlassian-extras-3.2.jar.bak
```


# 配置JIRA

如何配置JIRA参考 https://www.jianshu.com/p/889a935316ba 这篇文章 “启动JIRA实例” 这一节：


JRIA License

Server: IDBM41-P0UK-V0LY-GQ64
Your License Key:
AAABeg0ODAoPeNp9kUFPwkAQhe/9FU286GGbFosiSRO13Ri0BaRoYuJlXIayBrbN7Bbl31taiKDAcdqd97735mxcop0A2d617Xa6Lb/rX9phNLZbbsu1MkJUs7wokJxYClQa+UQamauA98d8NBz1Um71y8UH0mD6opF0wDwrzJUBYfqwwECAFDNU2QpUdpstQM4dkS+sT0ng/FscliRmoDECg8GagLmXzOtYG+/xqsBaNBwkCR+Fvbt4+4t/F5JWO3s+8663IDypbI+RpEhLpF4U3Ce+x4buyxN7deM39vB85TeYBeWTUhhnPTCdT80XEDqVrlxiYKjE5tnxgg7UeChKRakMKlDiSJwTNP+q3PhUueJelPI+i7221253OjdWNQX7X04IpwbIIAVTmGu0BpSBkhrqhGhmoKyQsB7/3mzeALxWPOvHrb0WsApKBUm9KTBCLUgWtexj5W+nG3/7vLnPxXvX5kuYl7VXA3zsAoe63TXf3fvVbOYfwQUMyTAsAhQydvZ3rUmdSXjgRFda9CNWAxez+QIUSeCnCPJUaiC4KAYjJt96z6Ng0Yw=X02ie


Admin Account

Username: admin
Password: P@ssw0rd!


Other Account

sunbenxin/P@ssw0rd!
wanglei/P@ssw0rd!


# 参考

- Linux
  - [disable selinux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/sect-security-enhanced_linux-enabling_and_disabling_selinux-disabling_selinux)
- JIRA
  - [JIRA Software 7.12 document](https://confluence.atlassian.com/jirasoftwareserver0712/jira-software-server-7-12-documentation-959314519.html)
  - [JIRA User Mangement](https://confluence.atlassian.com/adminjiraserver0712/user-management-959313393.html)
    - Manage Users
      - Create, edit, or remove a user
        - [Connect to an internal directory with LDAP authentication](https://confluence.atlassian.com/adminjiraserver0712/connecting-to-an-internal-directory-with-ldap-authentication-959313434.html)
    - Advanced User Management
      - [Allowing connections to Jira for user management](https://confluence.atlassian.com/adminjiraserver0712/allowing-connections-to-jira-for-user-management-959313424.html)
      - [Diagrams of possible configurations for user management](https://confluence.atlassian.com/adminjiraserver0712/diagrams-of-possible-configurations-for-user-management-959313425.html)
      - [Managing nested groups](https://confluence.atlassian.com/adminjiraserver0712/managing-nested-groups-959313426.html)
      - [User management limitations and recommendations](https://confluence.atlassian.com/adminjiraserver0712/user-management-limitations-and-recommendations-959313427.html)
    - [User directories](https://confluence.atlassian.com/adminjiraserver0712/configuring-user-directories-959313428.html)
- JIRA对接LDAP
  - [LDAP Configuration Guide](https://confluence.atlassian.com/kb/ldap-configuration-guide-820119264.html)
  - [Jira 6.3.6使用openldap进行认证](https://blog.51cto.com/jerry12356/1862090)
  - [Managing nested groups](https://confluence.atlassian.com/adminjiraserver0712/managing-nested-groups-959313426.html)
- OpenLDAP
  - [OpenLDAP Official Website](https://www.openldap.org/)
  - [install openldap](https://www.server-world.info/en/note?os=CentOS_7&p=openldap&f=1)
  - [LDAP Nested Groups: Modelling and Representation in Code](https://developers.mattermost.com/blog/ldap-nested-groups-modelling-and-representation-in-code/)

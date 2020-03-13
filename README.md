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

# 参考

- [install openldap](https://www.server-world.info/en/note?os=CentOS_7&p=openldap&f=1)
- [disable selinux](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/sect-security-enhanced_linux-enabling_and_disabling_selinux-disabling_selinux)

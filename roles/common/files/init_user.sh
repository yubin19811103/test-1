#!/bin/bash
USER=waming
RETURN_SUDO=`cat /etc/sudoers|grep $USER`
RETURN_PermitRoot=`sudo cat /etc/ssh/sshd_config |grep "^PasswordAuthentication no"`
USER_HOME=/home/waming

setenforce 0
sed -i "/^SELINUX=*/ s/SELINUX=.*$/SELINUX=disabled/g" /etc/selinux/config

if [ ! -d $USER_HOME ]; then
    useradd $USER
    mkdir $USER_HOME/.ssh
    chown $USER:$USER $USER_HOME/.ssh
    chmod 700 $USER_HOME/.ssh
    touch $USER_HOME/.ssh/authorized_keys
    chown $USER:$USER $USER_HOME/.ssh/authorized_keys
    chmod 600 $USER_HOME/.ssh/authorized_keys
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgSOiSZ+2R4Mfv0ctLO+M9F7Tzw1dnRUO7e+yZRDNYXcccO6YqEpbfW0kxyGez7f2X/sJzpngLot7LSSo1xE+s0ZbtGA5DywLv/AFeDPJgaLZLTDOdntbPCPC2m4osvHyV9nv4vGfSPYgO8rAg+TbFtDtobekj+IQc0315acRdl0wGtVdnAFq651gZJnvAXvHb7pzqVKHHkBCtrXHvHHat39KEgIOTfCmqQBNyRIJ6i5QnFKyMStVYr1eCB7RPx7l28OHWgRj11IU3I/+xKdCRKD6Npqojmm0jJdzXmkypZo2vLDjpT41bT20WERdoxSFaNtph5aZGfS+iVSs0LA9F yubin@yubindeMacBook-Air.local
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA51LrS8ZOySjy9lzdvWSnrGl7j2J/JFtAjV+emU1LBN59Bl0u3qUsfUusrfXY4jXRg7jC9h2wpXQeEaBHEk75tpXAcy5IXeDOiH/+qhgSxOY0hSFgPf3PBu+Vr5Uiylc+DsNfMdetgBOzz57ShfTFkViBixmPK+NXLQMEAl2NBXOB/wvSNlT5kxK6e1Tf3rckc+SKRkZknu2VTw3m00UmPB17/JG3UIyiD9+7og/ea3JJFkCWbQQK5mnC+tRfSTZpoOzeerLe86/7wHSa78EFVMraWr6GMB/Nbxz9r8xHXi5fjFs8JGGztGKwgnA8hlQUzpBNUrpNfq2BH/OLfrkhBw==
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZEjuTh0EgrsnJCENaM1dMqxEVAdzBRYsw/2+pdPXo8+cDAPLNsul24ZdjGj++8RZv5DxMfuQDZLPx7zQbA8IE8+3WTL7DIMBUszO3JFBEDySgjsofxsKm2YAYIrWyejGnr1BjvAQLei8gAglVAjYtn59j4cGU5nI8aIiIOZzt2cdZUVrL8h2O3Q50U5TTou7+6n5Sikcjal1kVPYNwTwagoqxndy2KVL9f9yTwjPa+dUN0e43Ka9JKP8htUgIqA4uJ2raCW+AXuSlMwfru44EMJp0zs+NBqWeMq8I8YfBX9PPA9FwCPnZySGgjCom/tIBiulyaahOqFd9v/BhVaaR zhangbin@zhangbindeMacBook-Pro.local
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMD0etlZUOMWlNyyr2t6MWVPz1P3mzz1DggFmlu3buHATOsq4DChLZKh3TBzeSD26t3AW8Pzo1XvGnfUMOHvqGTiKzQrgz1dcJUxLXwYJdfhT+OWwMlKUxYVQ5fqkEidChlfciORhVJVOhIirrdA9uPfsut6H4Ad2+m9H/8xw8QPOUbQWWBReMmfb9PR7H16vOO2ABgDVB7ACVWcDn90fxNoZSD3kjF+MtQf5U/RRJjZW6fzSCkt5umSZ60GPJvJWC1frXgstTm0jFHLKRBww0g54UgmpSRcX/AmMWU/KxJUQr+OaHrsPeDNNewiXjl+GHy1IYQIX4K/kt/Xnn5aub waming@wm-gateway-monitor" >> /home/${USER}/.ssh/authorized_keys
fi

if [ "$RETURN_SUDO" = ""  ]; then
    chmod 777 /etc/sudoers
    sed -ri "99 a${USER} ALL=(ALL:ALL) ALL" /etc/sudoers
    chmod 440 /etc/sudoers
    echo "${USER} ALL=(ALL) NOPASSWD : ALL" > /etc/sudoers.d/${USER}
    chmod 440 /etc/sudoers.d/${USER}
    echo "${USER} sudo权限添加完毕"
else
    echo "${USER} sudo权限已存在，不用添加"
fi

if [ "$RETURN_PermitRoot" = "" ]; then
    sed -i "s/#PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
    echo "PermitRootLogin修改完毕"
    sed -i "s/PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
    echo "PasswordAuthentication 修改完毕"
else
    echo "sshd_config文件不用修改"
fi

systemctl restart sshd.service

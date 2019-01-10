#!/bin/bash
# Author：RYB

# yum
yum install -y epel-release.noarch
yum makecache
yum install -y expect.x86_64

# ssh without password
cd $1 && [ ! -f /root/.ssh/id_rsa.pub ] && ssh-keygen -t rsa -f /root/.ssh/id_rsa -P "" &>/dev/null
while read line;do
    if [[ $line != \#* ]]; then
        ip=`echo $line | cut -d " " -f1`            # ip
        username=`echo $line | cut -d " " -f2`      # username
        password=`echo $line | cut -d " " -f3`      # password
    expect <<EOF
        spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $username@$ip
        expect {
            "yes/no" { send "yes\n";exp_continue}
            "password" { send "$password\n"}
        }
        expect eof
EOF
    fi
done < hostInfo

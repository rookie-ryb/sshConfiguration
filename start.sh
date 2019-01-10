#!/bin/bash
# Author：RYB

runPath=/root
cd $runPath && bash sshConfiguration.sh $runPath && echo "[SUCCESS] localhost"
while read line;do
    if [[ $line != \#* ]]; then
        ip=`echo $line | cut -d " " -f1`            # ip
        if [ -z "`ip a | grep $ip`" ]; then 
            scp sshConfiguration.sh $ip:$runPath
            scp hostInfo $ip:$runPath
            ssh $ip -n "bash ${runPath}/sshConfiguration.sh" && echo "[SUCCESS] $ip"
        fi
    fi
done < hostInfo

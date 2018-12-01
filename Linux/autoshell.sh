#Note:Get The Following Path Address Ready.

#Prefix of variables
#SQL server IP address
#Backup and save address after compression
#Backup save address
#Backup transfer address
#Backup copy to store server address
#SQL database name(Add spaces between each name)



#Shell Execution Area:


#!/bin/bash
echo '#!/bin/bash' >/script/shellname.sh
#Prefix of variables
read -p 'Enter Prefix of variables:' v1
pre=$v1
echo logName='$(date +%F)' >>/script/shellname.sh

#SQL server IP address
read -p 'Enter SQL server IP address:' v10
echo $pre\_ip=$v10 >>/script/shellname.sh

#Backup and save address after compression
read -p 'Enter Backup and save address after compression:' v11
#judge whether a file exists
if [ ! -z "$v11" -a ! -d "$v11" ];then
/usr/bin/mkdir -p $v11
fi
echo $pre\_p1=$v11 >>/script/shellname.sh

#Backup save address
read -p 'Enter Backup save address:' v12
echo $pre\_p2=$v12 >>/script/shellname.sh

#Backup transfer address
read -p 'Enter Backup transfer address:' v13
#judge whether a file exists
if [ ! -z "$v13" -a ! -d "$v13" ];then
/usr/bin/mkdir -p $v13
fi
echo $pre\_p3=$v13 >>/script/shellname.sh

#Backup copy to store server address
read -p 'Enter Backup copy to store server address:' v14
echo $pre\_p4=$v14 >>/script/shellname.sh

#Delete backup files
echo /usr/bin/rm -f $pre\_p2/*.bak >>/script/shellname.sh
echo /usr/bin/systemctl start smb >>/script/shellname.sh
echo /usr/bin/systemctl start nmb >>/script/shellname.sh

#SQL database name
read -p 'Enter database name:' v20
sqlpg1=($v20)
sqlpg1_len=${#sqlpg1[*]}
i=0
echo "echo ====================================================" >>/script/shellname.sh
echo "echo Start backup \$(date)" >>/script/shellname.sh
while [ $i -lt $sqlpg1_len ]
do
echo ${sqlpg1[$i]}
echo /opt/mssql-tools/bin/sqlcmd -S \$$pre\_ip -U bak -P \'Jkxx!@#456\' -Q \"backup database \
${sqlpg1[$i]} to disk=\'\\\\\\\\192.168.40.254\codebak\\${sqlpg1[$i]}.bak\'\" >>/script/shellname.sh
let i++
done
echo "echo End backup   \$(date)" >>/script/shellname.sh

echo 'echo ====================================================' >>/script/shellname.sh
echo echo Start compression '$(date)' >>/script/shellname.sh
echo /usr/bin/zip -j \$$pre\_p1/$pre-\$logName.zip \$$pre\_p2/*.bak >>/script/shellname.sh
echo /usr/bin/md5sum \$$pre\_p1/$pre-\$logName.zip \> \$$pre\_p2/md5-$pre-\$logName >> /script/shellname.sh
echo echo End compression   '$(date)' >>/script/shellname.sh
echo echo ==================================================== >>/script/shellname.sh

echo /usr/bin/systemctl stop smb >>/script/shellname.sh
echo /usr/bin/systemctl stop nmb >>/script/shellname.sh

#Judge whether it is empty
if [ ! -z "$v13" ];then
echo /usr/bin/scp -p \$$pre\_p1/$pre-\$logName.zip \$$pre\_p3 >>/script/shellname.sh
fi
echo /usr/bin/scp -p \$$pre\_p1/$pre-\$logName.zip \$$pre\_p4 >>/script/shellname.sh
echo /usr/bin/scp -p \$$pre\_p2/md5-$pre-\$logName \$$pre\_p4 >>/script/shellname.sh

echo /usr/bin/find \$$pre\_p1 -mtime +7 -name \"*.zip\" -exec rm -f {} \\\; >>/script/shellname.sh
echo /usr/bin/find \$$pre\_p2 -mtime +7 -name \"log*\" -exec rm -f {} \\\; >>/script/shellname.sh
echo /usr/bin/find \$$pre\_p2 -mtime +7 -name \"md5*\" -exec rm -f {} \\\; >>/script/shellname.sh
echo /usr/bin/find \$$pre\_p3 -mtime +30 -name \"*.zip\" -exec rm -f {} \\\; >>/script/shellname.sh


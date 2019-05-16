#!/bin/sh

# Color
Red="\033[2;31m"
Red_White="\033[1;41m"
Reset="\033[1;0m"

# Path
directory_path="/root/firewall"

# ^M bad interpreter delete
yum -y install dos2unix

# install firewall
install_firewall(){
	# firewall_config
	cd /root/
	wget "https://github.com/kimtaekhan/firewall/raw/master/firewall.tar.gz"
	tar -xvf firewall.tar.gz
	dos2unix ${directory_path}/ext/firewall_default
	dos2unix ${directory_path}/ext/firewall_geoip
	dos2unix ${directory_path}/firewall
	chmod 700 ${directory_path}/ext/firewall_default
	chmod 700 ${directory_path}/ext/firewall_geoip
	chmod 700 ${directory_path}/firewall
	mv ${directory_path}/firewall /etc/init.d/
}

# Check if a directory exists
if [ ! -d ${PATH} ]
then
	echo -en "${Red_White}/root/firewall${Reset} ${Red}directory is not exist !${Reset}\n"
	echo -en "${Red_White}/root/firewall${Reset} ${Red}make directory now !${Reset}\n"
	mkdir ${directory_path}
	mkdir ${directory_path}/geoip
	mkdir ${directory_path}/iptables_rules
	mkdir ${directory_path}/ext
	mkdir ${directory_path}/config
elif [ -d ${directory_path} ]
then
	if [ ! -d ${directory_path}/geoip ]
	then
		echo -en "${Red}directory for different purposes !"
		echo -en "a modification to the script is required !${Reset}\n"
		exit 1
	elif [ -d ${directory_path}/geoip ]
	then
		echo -en "${Red} Already installed !"
		echo -en "Exit Script !${Reset}\n"
		exit 0
	fi
fi

# Check if a Wget Command exists
wget_exist_check=`yum list installed | grep wget | wc -l`
if [ "${wget_exist_check}" -eq 0 ]
then
	echo -en "${Red}Command is not exist !${Reset}\n"
	echo -en "${Red}install wget start !${Reset}\n"
	yum -y install wget
	install_firewall
elif [ "${wget_exist_check}" -eq 1 ] # go !
then
	install_firewall
fi

rm -f firewall.tar.gz

exit 0

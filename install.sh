#!/usr/bin/env bash
#Variables
prt="echo -e"
pkg_install(){
	pkgs=($*)
	pdirs=$(echo $PATH | tr ':' ' ')
	tsu=""
	#Lists
	declare -A pm_i
	pm_i[apt]="install"
	pm_i[pacman]="-S"
	pm_i['nix-env']="-iA"
	pm_i[apk]="add"
	pm_i[dnf]=@
	pm_i[apx]=@
	#list binaries
	for dir in ${pdirs[@]}
	do
		list+=($(ls $dir/))
	done
	#Package Detect
	for pmc in ${!pm_i[@]}
	do
		if [[ "${list[*]}" = *" $pmc "* ]]
		then
			pm=$pmc
		fi
	done
	#Check Root
	if [[ "${list[*]}" = *"sudo"* ]]
	then
		$prt "#$pm"
		tsu="sudo"
	else
		$prt "$pm"
	fi
	#Packages Install
	if [ "${pm_i[$pm]}" = "@" ]
	then
		$tsu $pm ${pm_i[apt]} ${pkgs} -y
	else
		$tsu $pm ${pm_i[$pm]} ${pkgs} -y
	fi
}
output(){
out_a=($*)
	declare -A t
	[ $1 = '-p' ] && t['-p']="\033[01;35m [$2]: -=- ${out_a[*]:2} -=-\033[00m" #Process
	[ $1 = '-T' ] && t['-T']="\n\033[01;36m ## ${out_a[*]:1} ##\033[00m\n" #Title
	[ $1 = '-H' ] && t['-H']="\033[01;36m ### $([[ ! -z $3 ]] && $prt "$*" | sed "s/$1 $2//") ###\n ~ $2 ~\033[00m\n" #Bundle Header
	$prt ${t[$1]}
}

# N OS Install process
rm -rf bmn-script
output -H 'MatheusNDDS' 'Standalone N-OS Installer'
output -p 'n-os/installer/$pm' 'Installing GIT'
pkg_install git
output -p 'n-os/installer/git' 'Cloning “bmn-script” repo'
git clone https://github.com/MatheusNDDS/bmn-script.git
output -p 'n-os/installer' 'Installing “bmn-script”'
cd bmn-script/
sudo bash bmn.sh -s
output -p 'n-os/installer/bmn' 'Proceed to install “Nano OS”'
sudo bmn -i n-os

#!/bin/bash
# Filename Chnager (fnc) by Kelvin Onuchukwu 
# Initial: Nov 2021; Last update: Dec 2021
# N.B: This project is a work in progress. To contribute to this project, visit the Contributing.md file for basic guidelines. 

trap func exit
function func()
{
	rm ~/tmp/error_log.txt 2> /dev/null
        rm ~/tmp/update.txt 2> /dev/null
	#Remove ~/tmp deirectory only if it is empty
	find ~/tmp -maxdepth 0 -empty -exec rmdir  ~/tmp {} \; 2> /dev/null
}

function Temp_dir () 
{
#check if ~/tmp exists 
if [[ -d ~/tmp ]] 
then 
     :
else 
mkdir ~/tmp
fi
} 

#The init function essentially checks if the user is running the script for the first time.
#If so, it creates an alias **fnc**, so the user can run this script from any directory within their filesystem by simply typing 'fnc'. 
function Init ()
{
#Check whether script is running for the first time on the local machine. 
if [[ -f "~/filename-changer/.first.txt" ]] 
then
	echo -e "fnc.sh: No option selected. \nTry fnc -h for more information"
else
echo -e "Create an alias fnc to run this script anywhere from the command line.y/n?"
read ans 
if [[ $ans == y ]] || [[ $ans == yes ]] 
then
echo "alias fnc='bash ~/filename-changer/fnc.sh'" >> ~/.bash_aliases
source ~/.bash_aliases
echo - e "Alias fnc has been created for command 'bash ~/filename-changer'. \nYou can now execute this program by typing 'fnc' anywhere on your terminal. \nIf you move this directory at any point in time, please be sure to update your .bash_aliases and .bashrc files as appropriate."
touch ~/filename-changer/.first.txt
elif [[ $ans == n ]] || [[ $ans == no ]] 
then
	echo -e "Please restart the script. \nTry fnc -h for more information" 
	touch ~/filename-changer/.first.txt 2> /dev/null
	exit
else 
	echo "Invalid input. Restart the script and try again."
exit
fi
fi
}

function F1()
{
Temp_dir
var1=`ls`
for i in $var1
do
	mv -v $i `tr '[:upper:]' '[:lower:]' < <(echo "$i")` 2> ~/tmp/error_log.txt
	logger $0: `cat ~/tmp/error_log.txt`
done
if [ $? == 0 ]
then
	echo "TASK COMPLETED!"
else
	echo "Error code $?, Please use journalctl for more diagnosis"
fi
exit
}

function F2()
{
Temp_dir
	echo "Please enter the ABSOLUTE Directory path for the files(e.g /home/$USER/Videos):"
	read path
	cd $path 2>/dev/null
	if [ -d $path ]
	then
	for i in `ls -R`
	do
		mv -v $i "$path/`tr '[:upper:]' '[:lower:]' < <(echo "$i")`" 2> ~/tmp/error_log.txt
		logger $0: `cat ~/tmp/error_log.txt`
	done
	echo "TASK COMPLETED!"
else 
	echo -e "Path does not exist! "
	fi
	exit
}

function Update () 
{ 
Temp_dir
echo "Connecting to remote repository..."
#If "git pull" fails to run within 2 minutes, exit program with original Exit code, even when 'kill' signal is sent. 
timeout --preserve-status 120 git pull ~/filename-changer > ~/tmp/update.txt
        if [[ `grep -q "Unpacking objects:" ~/tmp/update.txt` ]] 
		then
			echo "Your package has been updated to the latest version."
        echo "Please restart this file by running 'bash fnc.sh' "
        rm ~/filename-changer/.first.txt 2>/dev/null
        else 
        echo -e "fnc.sh: Program cannot be updated at this time. \nPlease check your network connection and try again."
	exit
fi
logger `cat ~/tmp/update.txt`  
exit 
} 

function Version () 
{
Temp_dir
echo  "fnc.sh: Filename-Changer (fnc)"
echo  "Author: Kelvin Onuchukwu" 
echo  "Version 2.0"
echo -e "For more info, visit \e[4mhttps://github.com/Kelvinskell/filename-changer\e[10m"
exit
} 

while getopts "dDrRVv" options
do
	case ${options} in
		d | D)
			
			F1
			;;
		r | R)
			F2
			;;
                v) 
                       Version 
                        ;;
                V) 
                       Update
                        ;;
		*)
			echo "Use -d or -D option for files in the current directory only, Use -r or -R option to specify a directory and peform action on the files therein."

		esac
	done
        Temp_dir
	Init

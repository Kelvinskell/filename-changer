#!/bin/bash

# Filename Chnager (fnc) by Kelvin Onuchukwu 
# Initial: Nov 2021; Last update: Dec 2021
# N.B: This project is a work in progress. To contribute to this project, visit the Contributing.md file for basic guidelines. 

trap func exit
function func()
{
	rm error_log.txt 2>/dev/null
}

#Check whether script is running for the first time on the local machine. 
If [[ -f ".first.txt" ]] 
then
continue
else
echo "Create an alias **fnc** to run this script anywhere from the command line.y/n?" 
Read ans 
If [[ $ans == y ]] || [[ $ans == yes ]] 
then
echo "alias fnc='cd $HOME/filename-changer ; ./fnc.sh'" >> $HOME/.bash_aliases
source $HOME/.bash_aliases
echo ". $HOME/fnc.sh" >> $HOME/.bashrc
source $HOME/.bashrc
echo - e "Alias **fnc** has been created for command **bash $HOME/filename-changer**. \nYou can now execute this program by typing **fnc** anywhere on your terminal. \nIf you move this directory at any point in time, please be sure to update your .bash_aliases and .bashrc files as appropriate."
elif [[ $ans == n ]] || [[ $ans == no ]] 
then
continue 
else 
echo  "Invalid input. Restart the script and try again."
exit
fi
fi

function F1()
{
var1=`ls`
for i in $var1
do
	mv -v $i `tr '[:upper:]' '[:lower:]' < <(echo "$i")` 2>error_log.txt
	logger $0: `cat error_log.txt`
done
if [ $? == 0 ]
then
	echo "TASK COMPLETED!"
else
	echo "Error code $?, Please use journalctl for more diagnosis"
fi
}

function F2()
{
	echo "Please enter the ABSOLUTE Directory path for the files(e.g /home/$USER/Videos):"
	read path
	cd $path 2>/dev/null
	if [ -d $path ]
	then
	for i in `ls -R`
	do
		mv -v $i "$path/`tr '[:upper:]' '[:lower:]' < <(echo "$i")`" 2>error_log.txt
		logger $0: `cat error_log.txt`
	done
	echo "TASK COMPLETED!"
else 
	echo -e "Path does not exist! "
	fi
}

while getopts "dDrR" options
do
	case ${options} in
		d | D)
			F1
			;;
		r | R)
			F2
			;;
		*)
			echo "Use -d or -D option for files in the current directory only, Use -r or -R option to specify a directory and peform action on the files therein."

		esac
	done

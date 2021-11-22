#!/bin/bash
trap func exit
function func()
{
	rm error_log.txt 2>/dev/null
}

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

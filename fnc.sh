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
# check if ~/tmp directory exists 
if [[ -d ~/tmp ]] 
then 
     :
else 
mkdir ~/tmp
fi
} 

function Init ()
{
# The init function essentially checks if the user is running the script for the first time.
# If so, it creates an alias 'fnc', so the user can run this script from any directory within their filesystem by simply typing 'fnc'. 
# Check whether script is running for the first time on the local machine. 
Temp_dir
if [[ -f ~/filename-changer/.first.txt ]] 
then
	echo -e "fnc.sh: No option selected. \nTry fnc -h for more information"
else
echo -e "Create an alias fnc to run this script anywhere from the command line.y/n?"
read ans 
if [[ $ans == y ]] || [[ $ans == yes ]] 
then
echo "alias fnc='bash ~/filename-changer/fnc.sh'" >> ~/.bash_aliases
source ~/.bash_aliases
echo -e "Alias fnc has been created for command 'bash ~/filename-changer'. \nYou can now execute this program by typing 'fnc' anywhere on your terminal. \nIf you move this directory at any point in time, please be sure to update your .bash_aliases and .bashrc files as appropriate."
touch ~/filename-changer/.first.txt
elif [[ $ans == n ]] || [[ $ans == no ]] 
then
	echo -e "Please restart the script with an option. \nTry fnc -h for more information"
       echo "To stop this display, create an empty ".first.txt" file in the ~/filename-changer directory."
	touch ~/filename-changer/.first.txt 2> /dev/null
	exit
else 
	echo "Invalid input. Restart the script and try again."
exit
fi
fi
}

#####################################################GETOPTS FUNCTIONS########################################################################

function Lowecase()
{
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

function Path()
{
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
echo "Connecting to remote repository..."
# If "git pull" fails to run within 2 minutes, exit program with original Exit code, even when 'kill' signal is sent. 
timeout --preserve-status 120 git pull ~/filename-changer > ~/tmp/update.txt
        if [[ `grep -q "Unpacking objects:" ~/tmp/update.txt` ]] 
		then
			echo "Your package has been updated to the latest version."
        echo "Please restart this file by running 'bash fnc.sh' "
        rm ~/filename-changer/.first.txt 2>/dev/null
        else 
        echo -e "fnc.sh: Program cannot be updated at this time. \nfnc.sh: Please check your network connection and try again."
	exit
fi
logger `cat ~/tmp/update.txt`  
exit 
} 

function Version () 
{
echo  "fnc.sh: Filename-Changer (fnc)"
echo  "Author: Kelvin Onuchukwu" 
echo  "Version 2.0"
echo -e "For more info, visit \e[4mhttps://github.com/Kelvinskell/filename-changer\e[10m"
exit
} 
############################################################################################################################################
# Specify silent error checking 
# Specify functions for different options
while getopts ":dDrRVv" options
do
	case ${options} in
	       	C)
			# Change first letter in filename to uppercase
			Temp_dir
			First
			;;
		 C)
			 # Change filename to uppercase
			Temp_dir
			Uppercase
			;;
		 
		e | E)
			# Change file extension
			Temp_dir
			Extension
			;;
		g | G)
			# Use glob characters to select filenames
			Temp_dir
			Glob
			;;
		h)
			# Display manual page
			Temp_dir
			Help
			;;
		H)
			# Display history
			Temp_dir
			History
			;;
		i | I)
			# Perform filename changes iteratively
			Temp_dir
			Iterate
			;;
		l | L)
			# Change filenames in current directory to lowercase characters
			Temp_dir
			Lowercase
			;;
		p | P)
			# Specify absolute path to directory containing files of interest
			Temp_dir
			Path
			;;
		r)
			# Use this script on a remote system
			Temp_dir
			Remote
			;;
		R)
			# Generate random names for files
			Temp_dir
			Random
			;;
                v) 
		        # Display version information
			Temp_dir
                       Version 
                        ;;
                V) 
			# Update to the latest version
			Temp_dir
                       Update
                        ;;
		z | Z)
			# Revert filename to the last known name
			Temp_dir
			Revert
			;;
		*)
		        # Wrong option selection
             echo -e "fnc.sh: Invalid option. \nTry fnc -h for more information"
	     exit 1
		esac
	done

	# Call the Init function if no argument is used.
	Init


#!/bin/bash -i
# Filename Chnager (fnc) by Kelvin Onuchukwu 
# Initial: Nov 2021; Last update: Dec 2021
# To contribute to this project, visit the Contributing.md file for basic guidelines. 

# Redirect erros to null
exec 2>/dev/null

# Remove files before exiting program
trap func exit
function func()
{
	rm ~/tmp/error.log 
	rm ~/filename-changer/random.txt 
        rm ~/tmp/temp.txt   
        rm ~/tmp/hist_temp.txt 
	#Remove ~/tmp deirectory only if it is empty
	find ~/tmp -maxdepth 0 -empty -exec rmdir  ~/tmp {} \; 
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
if [[ -f ~/filename-changer/.init.txt ]] 
then
	echo -e "fnc.sh: No option selected. \nTry fnc -h for more information"
exit 0
else
        touch ~/filename-changer/.history_page.log 
echo -e "Hi, welcome $USER. \tI hope you enjoy using this program."
sleep 2
echo -e "Create an alias fnc to run this script anywhere from the command line."
read -p "y/n? " ans 
if [[ $ans == y ]] || [[ $ans == yes ]] 
then
echo "alias fnc='bash ~/filename-changer/fnc.sh'" >> ~/.bash_aliases
# Expand aliases defined in the shell
shopt -s expand_aliases
source "~/.bash_aliases"
sleep 1
echo -e "Alias fnc has been created for command 'bash ~/filename-changer'. \nYou can now execute this program by typing 'fnc' anywhere on your terminal. \nIf you move this directory at any point in time, please be sure to update your .bash_aliases and .bashrc files as appropriate."
elif [[ $ans == n ]] || [[ $ans == no ]] 
then
	echo -e "Please restart the script with an option. \nTry fnc -h for more information."
       echo "To stop this display, create an empty ".init.txt" file in the ~/filename-changer directory."
	exit
else 
	echo "fnc.sh: Invalid input. Restart the script and try again."
exit
fi
fi
touch ~/filename-changer/.init.txt
exit 1
}

#####################################################GETOPTS FUNCTIONS########################################################################
function First() 
{
	echo "Exclude directories? "
read  dir
if [[ $dir == n ]] || [[ $dir == no ]]
then
	# Execute action on both files and directories
var1=`ls`
for i in $var1
do
	j=`echo $i | awk '{$1=toupper(substr($1,0,1))substr($1,2)}1'` 
	mv -v $i $j 
echo "`date +%D`:$i:$j:" >> ~/filename-changer/.history_page.log
done
exit 0
elif [[ $dir == y ]] || [[ $dir == yes ]]
then
	# Execute action on only filenames
var1=`ls`
for i in $var1
do
	if [ -d $i ]
	then
		:
	else
	j=`echo $i | awk '{$1=toupper(substr($1,0,1))substr($1,2)}1'` 
	mv -v $i $j 
echo "`date +%D`:$i:$j:" >> ~/filename-changer/.history_page.log
	fi
done
fi
exit
} 

function Help() 
{
less ~/filename-changer/.manual_page.txt
exit 0
} 

function History() 
{
# Check if file is empty or not 
if [ -s ~/filename-changer/.history_page.log ]; then   
echo -e "Press c to clear history \tPress d to view history" 
read ans
if [[ $ans == c ]] || [[ $ans == C ]]; then
rm ~/filename-changer/.history_page.log 
touch ~/filename-changer/.history_page.log
touch ~/filename-changer/.file_inodes.log
echo "History cleared."
exit
elif [[ $ans == d ]] || [[ $ans == D ]]; then 
	awk -f ~/filename-changer/history.awk ~/filename-changer/.history_page.log |less
exit 0
else
       echo "fnc.sh: Unrecognised input. Exiting program..."
exit 0
fi
else 
      echo "You have no history yet."
exit 0
fi
} 

function Uppercase() 
{
echo "Exclude directories? "
read  dir
if [[ $dir == n ]] || [[ $dir == no ]]
then
	# Execute action on both files and directories
var1=`ls`
for i in $var1
do 
	j=$(tr '[:lower:]' '[:upper:]' < <(echo "$i"))
	mv -v $i $j 
echo "`date +%D`:$i:$j:" >> ~/filename-changer/.history_page.log
done
exit
elif [[ $dir == y ]] || [[ $dir == yes ]]
then
	# Execute action on only filenames
var1=`ls`
for i in $var1
do
	if [ -d $i ]
	then
		:
	else
		j=$(tr '[:lower:]' '[:upper:]' < <(echo "$i"))
	mv -v $i $j 
echo "`date +%D`:$i:$j:" >> ~/filename-changer/.history_page.log
	fi
done
fi
exit
} 

function Extension() 
{
echo "Check out common file extensions before proceeding"
read -p "yes or no? " ans 
if [[ $ans == y ]] || [[ $ans == yes ]] 
then 
less  ~/filename-changer/file_extensions.txt 
fi
echo "Exclude directories? "
read  dir
if [[ $dir == n ]] || [[ $dir == no ]]
then
echo -e "Input the new file extension \tDo not include '.'" 
read ext
var1=`ls`
for i in $var1
do
j=$(echo "$i" | cut -f 1 -d '.') 
mv -v $i $j.$ext 
echo "`date +%D`:$i:$j:" >> ~/filename-changer/.history_page.log
done
exit 0
elif [[ $dir == y ]] || [[ $dir == yes ]]
then
echo -e "Input the new file extension \tDo not include '.'" 
read ext
var1=`ls`
for i in $var1
do
	if [ -d $i ]
	then
		:
	else
j=$(echo "$i" | cut -f 1 -d '.') 
mv -v $i $j.$ext 
echo "`date +%D`:$i:$j:" >> ~/filename-changer/.history_page.log
	fi
done
fi
exit
}

function Lowercase()
{
echo "Exclude directories? "
read  dir
if [[ $dir == n ]] || [[ $dir == no ]]
then
	# Execute action on both files and directories
var1=`ls`
for i in $var1
do
	j=$(tr '[:upper:]' '[:lower:]' < <(echo "$i"))
	mv -v $i $j 
echo "`date +%D`:$i:$j:" >> ~/filename-changer/.history_page.log
done
exit
elif [[ $dir == y ]] || [[ $dir == yes ]]
then
	# Execute action on only filenames
var1=`ls`
for i in $var1
do
	if [ -d $i ]
	then
		:
	else
		j=$(tr '[:upper:]' '[:lower:]' < <(echo "$i"))
	mv -v $i $j
echo "`date +%D`:$i:$j:" >> ~/filename-changer/.history_page.log
	fi
done
fi
exit
}

function Path()
{
	echo "Please enter the ABSOLUTE Directory path for the files(e.g /home/$USER/Videos):"
	read path
	if [ -d $path ]
	then
		cd $path
		PS3="Choose how you wish to alter the filenames in this directory: "
                echo "Press a number to select an option." 
		select opt in extension glob uppercase lowercase quit
		do
			case $opt in
				extension)
					Extension
					;;
				first-letter)
					First
					;;
				uppercase)
					Uppercase
					;;
				lowercase)
					Lowercase
					;;
				quit)
					exit 0
					;;
				*)
					echo -e "fnc.sh: Invalid option selected. \nTry fnc -h for more information \nfnc.sh: Exiting program..."
					exit 1
				esac
			done

else 
	echo -e "fnc.sh: $path does not exist as a directory on this system! "
	fi
	exit
}

function Revert() 
{
 echo "Enter the current filename" 
 read filename
 # Check if filename exists in history
 mkdir ~/tmp 
 touch ~/tmp/hist_temp.txt 
 cut -d: -f 3 ~/filename-changer/.history_page.log > ~/tmp/hist_temp.txt
 if [ `tac ~/tmp/hist_temp.txt | grep -w -m1 $filename ~/tmp/hist_temp.txt` ] 
 then 
 j=$filename 
 tac ~/filename-changer/.history_page.log | grep -m1 $filename > ~/tmp/hist_temp.txt
 i=$(cut -d: -f 2 ~/tmp/hist_temp.txt) 
 echo $i
 mv -v $j $i
 echo "`date +%D`:$i:$j:" >> ~/filename-changer/.history_page.log
 else 
 echo "Sorry, $filename does not exist in our record."
 exit 
 fi
 exit
} 

function Random() 
{
echo -e "Press r to rename all files in this directory \tPress s to select a single file to rename "
read ans
if [ $ans == r ] || [ $ans == R ]
then
	var1=`ls`
	for i in $var1
	do
		# Generate a random number
		# Choose a random name from the dictionary and match it to the the random number
		# Cut out the random number and assign the new name to a variable
nl /usr/share/dict/american-english > ~/filename-changer/random.txt ;random=$(grep -w $RANDOM ~/filename-changer/random.txt|tr -d '0123456789')
mv -v $i $random 
echo "`date +%D`:$i:$random:" >> ~/filename-changer/.history_page.log
done
else
	echo "enter the ABSOLUTE PATH for the file (e.g: /home/$USER/tmp/my_file.txt) "
	read old_path
	if [[ -f $old_path ]]
	then
	nl /usr/share/dict/american-english > ~/filename-changer/random.txt ;new_path=$(grep -w $RANDOM ~/filename-changer/random.txt|tr -d '0123456789')
		mv -v "$old_path" "$new_path" 
echo "`date +%D`:$i:$new_path:" >> ~/filename-changer/.history_page.log
	else 
		echo "$old_path does not exist as a file on this system."
	fi
fi
exit
} 

function Update() 
{ 
echo "fnc.sh: Connecting to remote repository..."
sleep 1
             git pull ~/filename-changer
        if [[ $? == 0 ]] 
		then
			:
        else 
        echo -e "fnc.sh: Program cannot be updated at this time. \nfnc.sh: Please check your network connection and try again."
	exit
fi
exit 
} 

function Version() 
{
echo  "fnc.sh: Filename-Changer (fnc)"
echo  "Author: Kelvin Onuchukwu" 
echo  "Version 2.0"
# Highlight and underline the Weblink
echo -e "For more info, visit \e[4mhttps://github.com/Kelvinskell/filename-changer\e[10m"
exit
} 

##############################################################################################################################################

# Specify silent error checking 
# Specify functions for different options
while getopts ":cCeEgGhHiIlLpPrRvVzZ" options
do
	case ${options} in
	       	c) 
			# Change first letter in filename to uppercase
			# This will only change the first letter in the filename and will not affect other characters that make up the filename.
			# For instance, if your filename is "BOY.txt", this option will do nothing to the filename since the first character is already in uppercase.
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
		r | R)
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
			#Revert to last saved state
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

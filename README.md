**Hello :wave: and Welcome!**


## Project Name And Brief Synopsis 
This script shall be called **Filename Changer**, or **fnc** for short. 

The basic function of this script is to automate the renaming of files in order to give users more flexibility and efficiency when working with files on the command line interface. 
This is essentially, a utility-packed bash script that makes it easier for users to quickly change filenames on a directory, or even across a file system, to lowercase characters, uppercase characters, mixed characters.

You can even choose to hide your files in plain sight by generating random names for them, and reverting to their original names when you wish!
Users will have the options to change all the filenames in a directory, utilise glob characters to select files to act on, iteratively change filenames.
And much more! 

A full description of the capabilities of this script will be given under the **features** section. 

It is important to note that this script is specially adapted for Linux/Unix systems and may not (properly) run on Windows or other Operating Systems.

You are welcome to view the `Contributing.md` file if you wish to contribute to this project. 
As always, feel free to [Email](kelvinskelll@gmail.com) me, or check me out on [LinkedIn](https://www.linkedin.com/in/kelvin-onuchukwu-3460871a1) 

## Features 


## Installation
To be able to use this program, simply clone this repository to your local system. Switch (`cd`) into the cloned repository (_filename-changer_) and start the program by running `bash fnc.sh` on your terminal.
When this script is run for the first time on a local machine, it will ask for permission to create an alias in the _.bash_aliases_ file: `alias fnc='cd $HOME/filename-changer ; ./fnc.sh'`. It will also edit the _.bashrc_ file to include `. $HOME/filenane-changer/fnc.sh`.
**This enables the user to run the script from anywhere on the terminal by just typing fnc.**

If however this permission is denied, the user will have to `cd` into this directory and directly execute the `bash fnc.sh` whenever they want to run this script.

On subsequent occasions, if permission had been granted in the first instance, executing **fnc** will startup the script.
If permission was denied, the script will be able to run when `bash fnc.sh` is executed with an absolute or relative path, or when a custom alias is created by the user.

**Note:** 
- For this installation to work correctly, your current working directory has to be set to $HOME (especially if you wish to grant permission to create the alias as intended).
- If you are executing this script for the first time, please use 'bash fnc.sh` without any options. 
- The script will exit after the first instance, regardless of whether permission was granted or not. You'll need to restart the program.
- The script uses the _first.txt_ file to determine whether or not it is running for the first time. Tampering with this file may lead to unintended results.


## Usage 

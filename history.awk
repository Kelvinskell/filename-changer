BEGIN {
	print "DATE \t OLD FILENAME \t  NEW FILENAME"
	print "---- \t ------------ \t -------------"
	FS=":"
}
{
	print $1"\t"$2"    \t  " $3
}
END {
	print "fnc.sh: You have reached the end of this file."
}

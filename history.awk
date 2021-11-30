BEGIN {
	print "DATE \t INODE \t OLD FILENAME \t  NEW FILENAME"
	print "---- \t ----- \t ------------ \t -------------"
	FS=":"
}
{
	print $1  "\ " $2 "   \t " $3 "         \t " $4
}
END {
	print "You have reached the end of this file."
}

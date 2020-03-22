#!/bin/bash
#
# (C) Antonio Maulucci 2020
# antomau.com
#
# esport wa chat
# you have the file txt of chat

echo "filename?"
read filename
echo "outputfile html?"
read outfile
echo "people1's name: me?"
read p1
echo "people2's name: other?"
read p2

touch $outfile

echo "<!DOCTYPE HTML><html><head></head><body>" >> $outfile # start html page
echo "<center><table border='1' width='100%'>" >> $outfile

while read -r line
do
	echo -n $line | grep -q "$p1" # 0 se nella riga l'interlocutore e' p1 ovvero me
	output=$?
	if [ "$output" -eq "0" ]; then # l'interlocutore e' p1 ovvero me (a destra)
		# msg=$(echo $line | )
		echo -n "<tr><td></td><td>" >> $outfile
		echo -n $line >> $outfile
		echo "</td></tr>" >> $outfile
	else # altra persona (a sinistra)
		echo -n "<tr><td>" >> $outfile
		echo -n $line >> $outfile
		echo -n "</td><td></td></tr>" >> $outfile
	fi
done < $filename

echo "</table></center>" >> $outfile
echo "</body></html>" >> $outfile #end html page

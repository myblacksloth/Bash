#!/bin/bash

# $1 e $2 sono gli argomenti da riga di comando
# il comando di esecuzione e' ./$0 $1 $2
# dove $0 e' il nome del file eseguibile
# $1 il numero di caratteri da stampare
# $2 il carattere da stampare

# casi particolari
# * = \*
# # = \#
# \ = \\
# % = \% (in bash funziona anche solo %)

# valutazione degli argomenti passati
if [[ "$1" == "help" ]];
	then
		echo
		echo "Manual:"
		echo "This software prints n times a char c."
		echo "Launch the software with the command     ./char"
		echo "and use as the first argument the number (n) of  chars to print"
		echo "the use as the second argument the char (c) to print."
		echo
		echo "So the final command is (a.g.)    ./char 13 \*"
		echo "to print 13 times the char *"
elif [[ $1 -eq 0 ]]; # se il primo argomento e' nullo
	then
		echo "Not argument! See   ./char help   to know how to use!"
		exit 1
fi

# esecuzione del programma
for ((i=0; i<=$1-1; i++)) # 0, 1, 2, 3, 4, 5 = 6 cicli
do
	echo -n "$2"
done
echo

# (C) Antonio Maulucci 2017
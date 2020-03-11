#!/bin/bash
# (C) Antonio Maulucci 2020
# antomau.com || sites.google.com/view/antomau

# ls:
# downloaded/  downloading/  script  file logfile.txt

# put urls to video inside "file"

### $ bash script file

##########################
# i link cambiamo piu' volte nel corso del tempo
##########################
# cd downloadvideo/algebra2/
# put algebra.tgz
# tar -xvzf algebra.tgz
##########################
# screen [-S ${session_name}]
# screen -ls
# screen -r ${session_id}
# control ++ a ++ d # to detach
# <or> exit to exit
##########################

# ========================================== >>>>>>>>>
i=1 # video index [use 1 if 1st video]
materia="algebra"
# ========================================== <<<<<<<<<

while read -r urlpage
do
	grep -q ${urlpage} '#' # returns 0 if ok or not 0 if not ok === to enable comments inside file
	# every string containing '#' is considered as a comment!
	teststringa=$?
	# echo "teststringa= ${teststringa}"
	# read x
	# if (( $teststringa != 0 )); then
	if [ "$teststringa" -eq "0" ]; then
		wget -P ./downloading/ $urlpage
		testdownload=$?
		# if (( $testdownload != 0 )); then
		if [ "$testdownload" -ne "0" ]; then
			echo "========= ERROR =========" >> logfile.txt
			echo ${i} >> logfile.txt
			echo ${urlpage} >> logfile.txt
			echo "=========================" >> logfile.txt
		else
			echo "downloaded ${i}" >> logfile.txt
		fi
		cd ./downloading/
		filename=$(ls | awk '{print $1}') # si presume che nella directory vi sia solo il file appena scaricato
		echo "reneaming ${filename} to ${materia}-${i}.mp4" >> logfile.txt
		mv "${filename}" "${materia}-${i}.mp4"
		exitcode=$?
		# if (( $exitcode != 0 )); then
		if [ "$exitcode" -ne "0" ]; then
			echo "===== error while reneaming ${filename} ... ${i}" >> logfile.txt
		fi
		mv * ../downloaded/
		exitcode=$?
		# if (( $exitcode == 0 )); then
		if [ "$exitcode" -eq "0" ]; then
			echo "${materia}-${i}.mp4 moved to downloaded" >> logfile.txt
		else
			echo "===== error while moving ${materia}-${i}.mp4" >> logfile.txt
		fi
		cd ..
		((i+=1))
	fi
	##############################
done < $1

#!/bin/bash

# (C) Antonio Maulucci 2020
# use to download tm's [;)] videos
# from unitelma sapienza

# ============================================================
# cat /dev/null > script && vim script && ./script vl
# ============================================================
# execute as
# ls
# downloaded  downloading  script  vl
# >>>>
# ./script file
# ============================================================

# ============================================================ >>>>>>>>>>>>>
# 1st video's variable... use 1 if you don't know what are you doing...
i=89
# ============================================================ <<<<<<<<<<<<<

# urlpage""
# aHR0cDovL3RtYW5jaW5pLmRpLnVuaXJvbWExLml0L3BsYXlfdW5pdGVsbWEucGhwP2tleT1CRDIu
# Qi4yLjEuMQ==

#
#
#

while read -r urlpage
do
	# comandi qua
	video=$(curl ${urlpage} | grep file)
	# echo "video= $video"; echo
	video=$(echo $video | awk '{print $2}')
	# echo "video= $video"; echo
	videolen=${#video}
	# echo "videolen= ${videolen}"
	# videolen=(${videolen}-1)
	((videolen-=3))
	video=${video:1:$videolen}
	video=$(echo $video | awk '{print $1}')
	echo "video= $video"

	##############################

	wget -P ./downloading/ $video

	contenuto=$(ls ./downloading)
	contenuto=$(echo $contenuto | awk '{print $1}')
	echo $contenuto; echo
	# mv ./downloading/{,${i}-}${conenuto}
	cd ./downloading
	# mv "./downloading/${contenuto}" "./downloding/${i}-${contenuto}"
	mv "${contenuto}" "${i}-${contenuto}"
	cd ..
	mv ./downloading/* ./downloaded/

	##############################

	((i+=1))
done < $1

#
#
#

# video=$(curl ${urlpage} | grep file)
# # echo "video= $video"; echo
# video=$(echo $video | awk '{print $2}')
# # echo "video= $video"; echo
# videolen=${#video}
# # echo "videolen= ${videolen}"
# # videolen=(${videolen}-1)
# ((videolen-=3))
# video=${video:1:$videolen}
# video=$(echo $video | awk '{print $1}')
# echo "video= $video"

# ====== no
# url="http://stream1-fg.cineca.it/telma/mancini/A.4.1_Introduzione.mp4"
# wget -P ./downloading/ $url
# mv ./downloading/*{,${i}-}
# mv ./downloading/* ./downloaded/
# ======

# wget -P ./downloading/ $video

# contenuto=$(ls ./downloading)
# contenuto=$(echo $contenuto | awk '{print $1}')
# echo $contenuto; echo
# # mv ./downloading/{,${i}-}${conenuto}
# mv "./downloading/${contenuto}" "./downloaded/${i}-${contenuto}"
# mv ./downloading/* ./downloaded/

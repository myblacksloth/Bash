#!/bin/bash

# /bin/bash -c "/bin/bash ~/Desktop/scheduler.sh -d 29"
# /bin/bash -c "/bin/bash ~/Desktop/scheduler.sh -d 29 2>./errori"
# bash scheduler.sh -x "bash ./scheduler.sh
# /bin/bash -c "/bin/bash ~/Desktop/scheduler.sh -d 29 -x \"bash ~/Desktop/scheduler.sh\""
# /bin/bash -c "/bin/bash ~/Desktop/scheduler.sh -d 29 -x \"pwd\""
# 
# redirect di stdout e stderr
#       bash scheduler.sh -d 02 -w 3 &>> output.txt

# bash scheduler.sh -d 02 -w 2 -x "bash ./backUpper.sh -l nolist.txt &> output_inner.txt" &>> output.txt
# bash scheduler.sh -d 02 -w 2 -o ciao.txt -x "bash ./backUpper.sh -l nolist.txt" &> output.txt

year=-1
month=-1
day=-1
hour=-1
minute=-1
dayOfWeek=-1
randomexec=false
byhostname=false
customHostTarget=31
scriptoutput=""

exesys=$(uname -s)
uuid=$(uuidgen)

execute=true

TOEXEC=""

while getopts "y:m:d:h:m:w:rtx:o:" opt; do
        case ${opt} in
        y)
                year=${OPTARG}
                ;;
        m)
                month=${OPTARG}
                ;;
        d)
                day=${OPTARG}
                ;;
        h)
                hour=${OPTARG}
                ;;
        m)
                minute=${OPTARG}
                ;;
        r)
                randomexec=true
                ;;
        t)
                byhostname=true
                ;;
        w)
                dayOfWeek=${OPTARG}
                ;;
        x)
                TOEXEC=${OPTARG}
                ;;
        o)
                scriptoutput=${OPTARG}
                ;;
        ?)
                echo "Invalid option: -${OPTARG}."
                exit 1
                ;;
        esac
done

echo "[${uuid}][$(date)] [start]         SCHEDULER $@"

if [[ ${TOEXEC} == "" ]]; then
        echo "[${uuid}][$(date)] [error]         NESSUNO SCRIPT SELEZIONATO" >&2
        exit 1
fi

curyear=$(date +%Y)
curmonth=$(date +%m)
curday=$(date +%d)
curhour=$(date +%H)
curminute=$(date +%M)
curDayOfWeek=$(date +%u) # 0 e' la domenica

if [ ${year} -ne -1 ]; then
        if [ ${curyear} -ne ${year} ]; then
                execute=false
        fi
fi

if [ ${month} -ne -1 ]; then
        if [ ${curmonth} -ne ${month} ]; then
                execute=false
        fi
fi

if [ ${day} -ne -1 ]; then
        if [ ${curday} -ne ${day} ]; then
                execute=false
        fi
fi

if [ ${hour} -ne -1 ]; then
        if [ ${curhour} -ne ${hour} ]; then
                execute=false
        fi
fi

if [ ${minute} -ne -1 ]; then
        if [ ${curminute} -ne ${minute} ]; then
                execute=false
        fi
fi

if [ ${dayOfWeek} -ne -1 ]; then
        if [ ${curDayOfWeek} -ne ${dayOfWeek} ]; then
                execute=false
        fi
fi


if ${randomexec}; then
        echo "[${uuid}][$(date)] [info]          Esecuzione random"
        casuale=${RANDOM}
        if (( ${casuale} %2 != 0 )); then
                execute=false
        fi
fi

if ${byhostname}; then
        echo "[${uuid}][$(date)] [info]          Esecuzione in base all'hostname"
        
        if [[ ${exesys} == "Darwin" ]]; then
                # only for macos
                curhostsha=$(hostname | shasum -a 512 | awk '{print $1}')
        elif [[ ${exesys} == "Linux" ]]; then
                curhostsha=$(hostname | sha512sum | awk '{print $1}')
        fi
        # yere
        subhash=$(echo ${curhostsha} | cut -c 121-129)
        inthash=$(echo "ibase=16; ${subhash}" | bc)
        # target=$(( (${RANDOM} + 1) % ${customHostTarget} ))
        target=$(( (${curday} + 1) % ${customHostTarget} ))
        targettedhash=$(( ${inthash} % ( ${target}+1 ) ))
        targettedday=$(( ${curday} % ( ${target}+1 ) ))

        if [ ${targettedhash} -ne ${targettedday} ];then
                execute=false
        fi

fi


if ${execute}; then
        echo "[${uuid}][$(date)] [info]          Execute: ${TOEXEC}"

        if [[ ${scriptoutput} == "" ]]; then
                bash -c "${TOEXEC}"
        else
                bash -c "${TOEXEC}" >> ${scriptoutput}
        fi
        exitcode=$?
        if [ ${exitcode} -eq 0 ];then
                echo "[${uuid}][$(date)] [info]          Execute OK: ${TOEXEC}"
        else
                echo "[${uuid}][$(date)] [error]         Execute ERROR: ${TOEXEC}" >&2
        fi
else
        echo "[${uuid}][$(date)] [info]          NO Execute: ${TOEXEC}"
fi

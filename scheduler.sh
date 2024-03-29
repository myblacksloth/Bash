#!/bin/bash

# /bin/bash -c "/bin/bash ~/Desktop/scheduler.sh -d 29"
# /bin/bash -c "/bin/bash ~/Desktop/scheduler.sh -d 29 2>./errori"
# bash scheduler.sh -x "bash ./scheduler.sh
# /bin/bash -c "/bin/bash ~/Desktop/scheduler.sh -d 29 -x \"bash ~/Desktop/scheduler.sh\""
# /bin/bash -c "/bin/bash ~/Desktop/scheduler.sh -d 29 -x \"pwd\""

year=-1
month=-1
day=-1
hour=-1
minute=-1
randomexec=false
byhostname=false
customHostTarget=31

execute=true

TOEXEC=""

while getopts "y:m:d:h:m:rtx:" opt; do
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
        x)
                TOEXEC=${OPTARG}
                ;;
        ?)
                echo "Invalid option: -${OPTARG}."
                exit 1
                ;;
        esac
done


if [[ ${TOEXEC} == "" ]]; then
        echo "[$(date)] [error] NESSUNO SCRIPT SELEZIONATO" >&2
        exit 1
fi

curyear=$(date +%Y)
curmonth=$(date +%m)
curday=$(date +%d)
curhour=$(date +%H)
curminute=$(date +%M)

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


if ${randomexec}; then
        echo "[$(date)] [info] Esecuzione random"
        casuale=${RANDOM}
        if (( ${casuale} %2 != 0 )); then
                execute=false
        fi
fi

if ${byhostname}; then
        echo "[$(date)] [info] Esecuzione in base all'hostname"
        
        # only for macos
        curhostsha=$(echo -n ${HOST} | shasum -a 512)
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
        echo "[$(date)] [info] Execute: ${TOEXEC}"
        # echo "execute"
        bash -c "${TOEXEC}"
        #
        exitcode=$?
        if [ ${exitcode} -eq 0 ];then
                echo "[$(date)] [info] Execute OK: ${TOEXEC}"
        else
                echo "[$(date)] [error] Execute ERROR: ${TOEXEC}" >&2
        fi
else
        echo "[$(date)] [info] NO Execute"
fi

#!/bin/bash
# readonly SOURCE_DIR="${HOME}"
readonly SOURCE_DIR="./source/"
# readonly BACKUP_DIR="/mnt/data/backups"
readonly BACKUP_DIR="./dest/"
readonly DATETIME="$(date '+%Y_%m_%d_%H_%M_%S')"
# readonly BACKUP_PATH="./versioni/${DATETIME}"
readonly BACKUP_PATH="versioni/${DATETIME}"

# ========================================================

echo "ciao f1 riga 1" > ./source/f1.txt
echo "ciao f1 riga 2" >> ./source/f1.txt
echo "ciao f2 riga 1" >> ./source/f2.txt
echo "ciao f2 riga 2" >> ./source/f2.txt
mkdir -p ./source/provadir
echo "ciaone" > ./source/provadir/ciaone.txt

# ========================================================

rsync -aih --progress --backup --backup-dir=${BACKUP_PATH} ${SOURCE_DIR} ${BACKUP_DIR}

# ========================================================

echo "press any key..."
read # attendi input

# ========================================================

echo "ciao f1 riga 3 newline" >> ./source/f1.txt
echo "ciao f2 riga 3 newline" >> ./source/f2.txt
echo "ciao f3 riga 1 newline" > ./source/f3.txt
echo "ciaone riga 2" >> ./source/provadir/ciaone.txt

# ========================================================

readonly DATETIME="$(date '+%Y_%m_%d_%H_%M_%S')"
# readonly BACKUP_PATH="./versioni/${DATETIME}"
readonly BACKUP_PATH="versioni/${DATETIME}"

rsync -aih --progress --backup --backup-dir=${BACKUP_PATH} ${SOURCE_DIR} ${BACKUP_DIR}

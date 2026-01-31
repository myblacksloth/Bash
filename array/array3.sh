#!/bin/bash

declare -a cmdargs=("-l -s -a -h")
command="ls"

for i in "${cmdargs[@]}"
do
   command="${command} ${i}"
done

echo "eseguo ${command}"

eval "${command}"

#!/bin/bash

declare -a arr=("element 1" "element 2" "element 3")

arraylength=${#arr[@]}
echo "dimensione = ${arraylength}"

for i in "${arr[@]}"
do
   echo "$i"
done

for (( i=0; i<${arraylength}; i++ ));
do
  echo "index: $i, value: ${arr[$i]}"
done

printf '%s\n' "${arr[@]}"
printf '%s ' "${arr[@]}"
echo ""

#!/bin/bash
#

declare -a arr=("element 1" "element 2" "element 3")

# ------------------------------------------------------

array=()

array+=("first")
echo ${array[@]}

# ------------------------------------------------------

destination=()

for i in "${arr[@]}"
do
   destination+=("--include ${i}")
done

echo ${destination[@]}

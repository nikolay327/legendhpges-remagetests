#!/bin/bash

# Make sure to run src/create_gdmls.sh first before sourcing this file
(
gdmls=( $(ls "../gdml") )
gdmls=( ${gdmls[*]/#/..\/gdml\/} )


for gdml in ${gdmls[*]}
do
    DupedLines=$(grep "<rzpoint" ${gdml} | sort | uniq -c | awk '{print $1, $2, $3, $4}' | grep -v "^1")

    if [[ -n ${DupedLines} ]]
    then
        echo "Duplicated r,z-pairs found in ${gdml}:"
        echo -e "${DupedLines}\n"
    fi
done
)

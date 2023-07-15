#!/bin/bash

# Make sure to run src/create_gdmls.sh first before sourcing this file
[[ -d "../remage_logs" ]] && : || mkdir "../remage_logs"

(
gdmls=( $(ls "../gdml") )
macs=( $(ls "../gdml" | sed "s/.gdml/.mac/g") )
names=( $(ls "../gdml" | sed "s/.gdml/""/g") )

gdmls=( ${gdmls[*]/#/..\/gdml\/} )
macs=( ${macs[*]/#/..\/macros\/} )

length=${#gdmls[@]}

for ((Counter=0; Counter<${length}; Counter++))
do
    echo "Running test for ${names[${Counter}]}"
    remage ${macs[${Counter}]} -g ${gdmls[${Counter}]} &> "../remage_logs/${names[${Counter}]}.log"
    echo "Writing the test result in $(dirname $(pwd))/remage_logs/${names[${Counter}]}.log"
done
)

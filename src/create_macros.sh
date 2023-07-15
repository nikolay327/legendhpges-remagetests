#!/bin/bash

# Make sure to run src/create_gdmls.sh first before sourcing this file
[[ -d "../macros" ]] && : || mkdir "../macros"

(
names=( $(ls "../gdml" | sed "s/.gdml/""/g") )

for name in ${names[*]}
do
    cat > "../macros/${name}.mac" <<EOF
    /run/initialize

    # /RMG/Geometry/PrintListOfLogicalVolumes
    # /RMG/Geometry/PrintListOfPhysicalVolumes

    /RMG/Generator/Confine Volume
    /RMG/Generator/Confinement/Physical/AddVolume ${name}_PV

    /RMG/Generator/Select GPS
    /gps/particle ion
    /gps/ion 27 60
    /gps/energy 0 eV

    /run/beamOn 1000
EOF
done
)

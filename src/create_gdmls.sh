#!/bin/bash

[[ -d "../gdml" ]] && : || mkdir "../gdml"

cat > create_gedet.py <<'EOF'
import pyg4ometry as pyg4
import legendhpges as hpges
from legendmeta import LegendMetadata
from legendhpges.materials import natural_germanium

lmeta = LegendMetadata()
db = lmeta.hardware.detectors.germanium.diodes

saving_path = '../gdml/'

for name in db:

    reg = pyg4.geant4.Registry()

    if name == "P00664B":
      #excluding this detector because the metadata does not contain "crack" information yet.
      continue

    elif db[name].production.enrichment is None:
        gedet = hpges.make_hpge(db[name], reg, material=natural_germanium)

    else:
        gedet = hpges.make_hpge(db[name], reg)

    height = db[name].geometry.height_in_mm
    radius = db[name].geometry.radius_in_mm

    solidWorld = pyg4.geant4.solid.Box("solidWorld", 2.5*radius, 2.5*radius, 2.5*height, reg)
    worldMat = pyg4.geant4.MaterialPredefined("G4_Galactic", reg)
    logicWorld = pyg4.geant4.LogicalVolume(solidWorld, worldMat, "logicWorld", reg)
    reg.setWorld(logicWorld.name)
    pyg4.geant4.PhysicalVolume([0,0,0], [0,0,0], gedet, name + "_PV", logicWorld, reg)

    w = pyg4.gdml.Writer()
    w.addDetector(reg)
    w.write(saving_path + name + ".gdml")

    print(f"{name} height {height} radius {radius}")
EOF

python3 create_gedet.py
rm -rf create_gedet.py

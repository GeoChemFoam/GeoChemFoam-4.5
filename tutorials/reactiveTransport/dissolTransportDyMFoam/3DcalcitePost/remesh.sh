#!/bin/bash

cp -r ../3DcalcitePost ../temp
cd ../temp

./removeInternalFaces.sh

surfaceMeshTriangulate -patches '(movingWalls)' constant/triSurface/calcitePost.stl
cp constant/triSurface/calcitePost.stl ../3DcalcitePost/constant/triSurface/calcitePost.stl
rm -rf 0 0.* [1-9]*

./delete.sh
./initCase.sh
cp -r 0_org 0
cp -r constant/polyMesh 0/.

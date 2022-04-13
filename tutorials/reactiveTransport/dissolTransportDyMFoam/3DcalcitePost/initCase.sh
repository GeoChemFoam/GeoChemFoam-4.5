#!/bin/bash

# Load user environment variables 
source $HOME/.bashrc

NP=8

source $OF4X_DIR/OpenFOAM-4.x/etc/bashrc WM_LABEL_SIZE=64 FOAMY_HEX_MESH=yes

MPIRUN=mpirun 


# Create background mesh
echo -e "Create background mesh"
blockMesh  > blockMesh.out

# Decompose background mesh
echo -e "Decompose background mesh"
decomposePar > decomposeBlockMesh.out

# Remove fields on this stage
rm -rf ./processor*/0/*

# Run snappyHexMesh in parallel
echo -e "Run snappyHexMesh in parallel"
$MPIRUN -np $NP snappyHexMesh -overwrite -parallel  > snappyHexMesh.out

# reconstruct mesh to fields decomposition
echo -e "splitMeshRegions and decompose fields"
reconstructParMesh -constant > reconstructParMesh.out
#decomposePar -fields  > decomposeFields.out
$MPIRUN -np $NP splitMeshRegions -largestOnly -overwrite -parallel > splitMeshRegions.out

# renumberMesh
echo -e "renumberMesh"
$MPIRUN -np $NP renumberMesh -overwrite -parallel > renumberMesh.out


echo -e "checkMesh"
$MPIRUN -np $NP checkMesh -parallel > checkMesh.out


rm -rf *.out processor*
#transformPoints -translate '(0 0 2e-4)'

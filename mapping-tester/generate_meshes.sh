#!/usr/bin/env bash
set -e

GENERATOR_PATH=~/Bureau/aste/tools/mesh-generators

# Generate all coarse meshes,
for RES in 0.5 0.25 0.2 0.1 0.05 0.04 0.03 0.02
do
    echo ""
    python ${GENERATOR_PATH}/generate_unit_square.py --mesh coarse_${RES}.vtk --resolution $RES
done

# Generate fine mesh, finer than the finest of the coarse ones.
RES=0.005
python ${GENERATOR_PATH}/generate_unit_square.py --mesh fine.vtk --resolution $RES

FILES=$(ls | grep coarse.*\.vtk)

echo "Put this in setup.json at the section of A's meshes: (remove last comma)"
for file in ${FILES}
do
    mesh_name=$(echo $file | sed 's/\(.*\)\.vtk/\1/')
    echo "\"$mesh_name\": \"${file}\","
done

echo "Put this in setup.json at the section of A's meshes to be used in the mapping: (remove last comma)"
for file in ${FILES}
do
    mesh_name=$(echo $file | sed 's/\(.*\)\.vtk/\1/')
    echo "\"$mesh_name\","
done
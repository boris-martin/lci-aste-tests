#!/bin/bash

files=("mapping-tester-2d/test-statistics-franke2d"
     "mapping-tester-2d/test-statistics-rosenbrock2d"
      "mapping-tester-2d/test-statistics-quad"
      "mapping-tester-3d/test-statistics-quad-3d"
      "mapping-tester-3d/test-statistics-rosenbrock3d"
      "mapping-tester-3d/test-statistics-franke3d"
        );

# Make a no-rbf version
for f in ${files[@]};
do
    sed -E '/(ctps|gaussian)/d' $f.csv > $f-no-rbf.csv
    sed -i 's/lci/LCI/g' $f-no-rbf.csv
    sed -i 's/nng/NNG/g' $f-no-rbf.csv 
    sed -i 's/np/NP/g' $f-no-rbf.csv 
    sed -i 's/nn/NN/g' $f-no-rbf.csv 
done

# Keep only RBF and LCI
for f in ${files[@]};
do
    sed -E '/(nn|np)/d' $f.csv > $f-rbf.csv
    sed -i 's/ctps/RBF-CTPS/g' $f-rbf.csv 
    sed -i 's/gaussian/RBF-Gaussian/g' $f-rbf.csv 
    sed -i 's/lci/LCI/g' $f-rbf.csv 
done

CONV=~/Bureau/aste/tools/mapping-tester/plotconv.py


for f in ${files[@]};
do
  NAME=$(echo $f | sed "s/^.*statistics-\(\S*\).*$/\1/")

  # Plot for RBF
  $CONV -f $f-rbf.csv
  echo "Handling $f-rbf"
  cp result-computet.pdf plots/compute_map_time/$NAME-rbf.pdf
  cp result-mapt.pdf plots/map_time/$NAME-rbf.pdf
  cp result-error.pdf plots/error/$NAME-rbf.pdf
  cp result-peakMemB.pdf plots/memory/$NAME-rbf.pdf

  # Plot for non-RBF
  $CONV -f $f-no-rbf.csv
  echo "Handling $f-no-rbf"
  cp result-computet.pdf plots/compute_map_time/$NAME-no-rbf.pdf
  cp result-mapt.pdf plots/map_time/$NAME-no-rbf.pdf
  cp result-error.pdf plots/error/$NAME-no-rbf.pdf
  cp result-peakMemB.pdf plots/memory/$NAME-no-rbf.pdf
done
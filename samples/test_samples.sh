#!/bin/bash
set -e

# Clean and rebuild 
(
cd .. 
dune clean
dune build
)

(
cd ptrdist
./runall.sh
)
(
cd Olden
./runall.sh
)
(
cd checkedc-parson
make clean
make parson_c3
./parson_c3
)

echo "All Tests Pass!"

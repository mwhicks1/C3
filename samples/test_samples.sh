#!/bin/bash
set -e

cd ptrdist
./runall.sh
cd ..
cd Olden
./runall.sh
cd ..
cd checkedc-parson
make parson_c3
./parson_c3

echo "All Tests Pass!"

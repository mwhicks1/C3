#!/bin/bash
set -e

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
make parson_c3
./parson_c3
)

echo "All Tests Pass!"

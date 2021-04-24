#!/bin/bash

C3_DIR=$(pwd)

set -e

function fail() { 
  if [ -z $LASTCASE ] 
  then
    echo All Tests Pass!
  else
    echo Test $LASTCASE Failed!
  fi
}
 
trap fail EXIT

for test_case in $(ls ./tests/checked_cases/)
do
  echo testing $test_case
  full=./tests/checked_cases/$test_case
  LASTCASE=$full
  C3_DIR=. ./tests/test_checked.sh $full
done

LASTCASE=

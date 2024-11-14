#!/bin/bash

source /gem_ws/devel/setup.bash

if [ "$1" == "--fail" ]; then
  TEST=test_error_sim
else
  TEST=test_pure_pursuit
fi
python3 -m unittest tests.test.Test_Crosstrack_error.${TEST} --verbose
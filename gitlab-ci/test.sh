#!/bin/bash
cd ~/ci/beos-core/$CI_ENVIRONMENT_SLUG/$CI_COMMIT_REF_NAME/build
echo "Starting integration tests"
#if ! make test
if ! ctest -LE "beos_tests" || ! ctest -j4 -L "beos_tests" ;
then
  printf "Test failure. Exiting..."
  exit 1
fi

echo "Starting unit tests"

if ! ./unittests/unit_test --log_level=test_suite
then
  printf "Unit test failure. Exiting..."
  exit 2
fi


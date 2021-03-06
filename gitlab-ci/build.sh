#!/bin/bash
cd ~/ci/beos-core/$CI_ENVIRONMENT_SLUG/$CI_COMMIT_REF_NAME
cd cd-scripts
cp config-$CI_BEOS_CONFIG_NAME.py config.py
if ! ./deploy.py --build-beos
then
  cat beos_deploy_main.log
  printf "Unable to build beos project. Exiting..."
  exit 1
fi

cat beos_deploy_main.log

echo "Removing object files"
find ~/ci/beos-core/$CI_ENVIRONMENT_SLUG/$CI_COMMIT_REF_NAME -type f -name '*.o' -delete
echo "Stopping old keosd instance"
kill -2 $(lsof -t -i:8900) || true
python3 ./wait.py $(lsof -t -i:8900)
echo "Stopping old nodeos instance"
kill -2 $(lsof -t -i:8888) || true
python3 ./wait.py $(lsof -t -i:8888)

if ! ./deploy.py --initialize-beos
then
  cat beos_deploy_main.log
  printf "Unable to initialize beos blockchain"
  exit 2
fi

cat beos_deploy_main.log


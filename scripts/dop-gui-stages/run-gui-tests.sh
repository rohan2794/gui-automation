#!/bin/bash

set -e
GROUP="$1"
GUID="$2"
URL="$3"
THREADS="$4"
REGION="$5"

if [[ $GUID == *"e2e-aws"* ]]; then
  echo '#### AWS CONFIG ####'
	mkdir -p ~/.aws
	cp $AWS_CREDS ~/.aws/credentials
	echo '#### Output AWS Selenium Grid stack ####'
  output=`aws cloudformation describe-stacks --stack-name $GUID --region $REGION --query Stacks[].Outputs[].OutputValue | sed -r 's/"+//g'`
  grid=`echo $output | awk {'print $2'}`
  echo 'Selenium Grid: ' $grid
  ######################
  ##   Running test  ##
  ######################
  python3.7 -m pip install -r requirements.txt

  #Running tests with proper marker
  if [[ $GROUP == *dmaas* ]]; then
    python3.7 -m pytest -m $GROUP --url $URL --environment remote --hub $grid -v --tests-per-worker $THREADS --html=./results/report.html
  else
    python3.7 -m pytest -m $GROUP --url $URL --environment remote --hub $grid -v --tests-per-worker $THREADS --reruns 1 --html=./results/report.html
  fi
fi

if [[ $GUID == *"e2e-konvoy"* ]]; then
  # Test grid connection
  echo '#### curl http://10.66.2.5:4444 ####'
  CURL_INT=`curl http://10.66.2.5:4444`
  echo $CURL_INT
  echo '#### Output konvoy Selenium Grid stack ####'
  grid="10.66.2.5"
  echo 'Selenium Grid: ' $grid
  ######################
  ##   Running test  ##
  ######################
  #Running tests with proper marker
  if [[ $GROUP == *dmaas* ]]; then
    python3.7 -m pytest -m $GROUP --url $URL --environment remote --hub $grid -v --tests-per-worker $THREADS --html=./results/report.html
  else
    python3.7 -m pytest -m $GROUP --url $URL --environment remote --hub $grid -v --tests-per-worker $THREADS --reruns 1 --html=./results/report.html
  fi
fi
if [[ $GUID == *"e2e-rancher"* ]]; then
  # Test grid connection
  echo '#### curl http://10.67.2.12:4444 ####'
  CURL_INT=`curl http://10.67.2.12:4444`
  echo $CURL_INT
  echo '#### Output konvoy Selenium Grid stack ####'
  grid="10.67.2.12"
  echo 'Selenium Grid: ' $grid

  ######################
  ##   Running test  ##
  ######################

  #Running tests with proper marker
  if [[ $GROUP == *dmaas* ]]; then
    python3.7 -m pytest -m $GROUP --url $URL --environment remote --hub $grid -v --tests-per-worker $THREADS --html=./results/report.html
  else
    python3.7 -m pytest -m $GROUP --url $URL --environment remote --hub $grid -v --tests-per-worker $THREADS --reruns 1 --html=./results/report.html
  fi

fi


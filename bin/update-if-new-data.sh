#!/bin/bash

URL=https://raw.githubusercontent.com/KITmetricslab/hospitalization-nowcast-hub/main/data-truth/COVID-19/COVID-19_hospitalizations_preprocessed.csv
CSV=data/COVID-19_hospitalizations_preprocessed.csv 

if [ ! -f $CSV ] 
  then
  echo No cached data found - updating estimates
  wget -nc $URL -P data/
  bash bin/update-targets-and-publish.sh
  rm $CSV
  else
  echo Cache found - pipeline running - no action taken
fi
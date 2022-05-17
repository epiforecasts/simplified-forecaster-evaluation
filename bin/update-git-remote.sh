#!/bin/bash

git add data _targets_r _targets.md _targets.Rmd
date=$(date +'%Y-%m-%d')
git commit -m "$date - nowcast update"
git pull -Xours
git push

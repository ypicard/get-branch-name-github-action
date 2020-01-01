#!/bin/bash

declare -A TAGS_MAP
TAGS_MAP=( ["master"]="latest" ["development"]="development")

BRANCH=$(echo ${GITHUB_REF} | sed -e "s/refs\/heads\///g")
TAG=${TAGS_MAP[$BRANCH]}

# if contains /refs/pull/ for pull requests
if [ $(echo ${GITHUB_REF} | sed -e "s/refs\/pull\///g") != ${GITHUB_REF} ]; then
  cd /github/workspace 
  #only call git if checkout was done
  if [ -d .git ]; then
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
  fi;
fi;

# if contains /refs/tags/
if [ $(echo ${GITHUB_REF} | sed -e "s/refs\/tags\///g") != ${GITHUB_REF} ]; then
  TAG="latest"
fi;

echo "::set-output name=branch::${BRANCH}"
echo "::set-output name=tag::${TAG}"

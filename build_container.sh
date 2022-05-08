#!/bin/bash

VERSION=$(cat README.md | grep "Version" | awk '{print $2}')
OLD_VERSION=$VERSION

CHANGED_DOCKER=$(git diff --name-only Dockerfile)


docker build --tag mooremachine/ubuntu20:$VERSION .

if [ $? -ne 0 ]
then
    echo "docker build failed!"
    exit 1
fi

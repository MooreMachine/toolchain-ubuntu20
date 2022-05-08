#!/bin/bash

VERSION=$(cat README.md | grep "Version" | awk '{print $2}')
OLD_VERSION=$VERSION

CHANGED_DOCKER=$(git diff --name-only Dockerfile)

# If the Dockerfile has changed
if [ ! -z ${CHANGED_DOCKER} ]
then
    printf 'Please consider updating the version number.\nCurrent version: %s\n' "$VERSION"
    read -p "New version: " NEW_VERSION
    if [ ! -z ${NEW_VERSION} ]
    then
        if [[ ! $NEW_VERSION =~ [0-9]+\.[0-9]+\.[0-9] ]]
        then
            printf 'Please provide a version number in the form of MAJOR.MINOR.PATCH\n'
            exit 1
        fi
    else
        printf 'Please provide a version number'
        exit 1
    fi
    VERSION=$NEW_VERSION
fi


docker build --tag mooremachine/ubuntu20:$VERSION .

if [ $? -ne 0 ]
then
    echo "docker build failed!"
    exit 1
fi

printf 'Updating the version number in the README.md file...\n'
sed -i '' 's/Version: '"$OLD_VERSION"'/Version: '"$VERSION"'/g' README.md

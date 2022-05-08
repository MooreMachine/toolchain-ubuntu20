#!/bin/bash

VERSION=$(cat README.md | grep "Version" | awk '{print $2}')
OLD_VERSION=$VERSION

CHANGED_DOCKER=$(git diff --name-only Dockerfile)
CHANGED_README_VERSION=$(git diff README.md | grep +Version | awk '{print $2}')

# If the Dockerfile has changed but your README.md version number hasn't been updated
# prompt the developer to bump up the version number.
if [ ! -z ${CHANGED_DOCKER} ] && [ -z ${CHANGED_README_VERSION} ]
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

# If the Dockerfile has changed and your README.md version number has already been updated
# check that the new version number follows the MAJOR.MINOR.PATCH format.
if [ ! -z ${CHANGED_DOCKER} ] && [ ! -z ${CHANGED_README_VERSION} ]
then
    if [[ ! $CHANGED_README_VERSION =~ [0-9]+\.[0-9]+\.[0-9] ]]
    then
        printf 'You already changed the version number but it is not in the form of MAJOR.MINOR.PATCH\n'
        exit 1
    fi
fi

docker build --tag mooremachine/ubuntu20:$VERSION .

if [ $? -ne 0 ]
then
    echo "docker build failed!"
    exit 1
fi

printf 'Updating the version number in the README.md file...\n'
sed -i '' 's/Version: '"$OLD_VERSION"'/Version: '"$VERSION"'/g' README.md

if [ $? -ne 0 ]
then
    echo "sed failed to update the version number!"
    exit 1
fi

CHANGED_CHANGELOG=$(git diff --name-only CHANGELOG.md)

if [ -z ${CHANGED_CHANGELOG} ]
then
    printf '\nPlease consider updating the CHANGELOG.md file to document the changes made to the Dockerfile\n'
fi

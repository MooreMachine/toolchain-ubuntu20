#!/bin/bash

VERSION=$(cat README.md | grep "Version" | awk '{print $2}')

docker run \
    --rm \
    --interactive \
    --tty \
    --name ubuntu20_interactive \
    mooremachine/ubuntu20:$VERSION

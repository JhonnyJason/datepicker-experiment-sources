#!/bin/bash

## This script is called to copy all ressources
## Destination is basicly the output/ module
## The output module is the document-root of what is served on deployment

mkdir -p output/font

## app files
cp sources/ressources/font/* output/font/

cp sources/ressources/favicon/* output/
cp sources/ressources/manifest/* output/

echo 0

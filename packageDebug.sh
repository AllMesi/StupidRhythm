#!/bin/bash

clear
printf "Packaging on version: "
awk '/version:/{print $NF}' packager.yml
sed -i '5s/.*/RELEASE\ =\ false/' "components/globals.lua"
npx love-packager build
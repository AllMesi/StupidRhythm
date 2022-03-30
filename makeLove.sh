#!/bin/bash

mkdir out
sed -i '5s/.*/RELEASE\ =\ true/' globals.lua
rm -rf out/release
mkdir out/release
mkdir out/release/bin
mkdir out/release/love
zip -9 -r StupidRhythm.love . -x /.git/*
mv StupidRhythm.love out/release/love
./love out/release/love/StupidRhythm.love
#!/bin/bash

mkdir out
sed -i '5s/.*/RELEASE\ =\ false/' globals.lua
rm -rf out/debug
mkdir out/debug
mkdir out/debug/bin
mkdir out/debug/love
zip -9 -r StupidRhythm.love . -x /.git/*
mv StupidRhythm.love out/debug/love 
./love out/debug/love/StupidRhythm.love
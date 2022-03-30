#!/bin/bash

mkdir out > logs.txt 2>> logs.txt
sed -i '5s/.*/RELEASE\ =\ false/' globals.lua >> logs.txt
rm -rf out/debug >> logs.txt 2>> logs.txt
mkdir out/debug >> logs.txt
mkdir out/debug/bin >> logs.txt
mkdir out/debug/love >> logs.txt
zip -9 -r StupidRhythm.love . -x /.git/* >> logs.txt
mv StupidRhythm.love out/debug/love >> logs.txt
./love out/debug/love/StupidRhythm.love >> logs.txt
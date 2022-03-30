#!/bin/bash

mkdir out > logs.txt 2>> logs.txt
sed -i '5s/.*/RELEASE\ =\ true/' globals.lua >> logs.txt
rm -rf out/release >> logs.txt 2>> logs.txt
mkdir out/release >> logs.txt
mkdir out/release/bin >> logs.txt
mkdir out/release/love >> logs.txt
zip -9 -r StupidRhythm.love . -x /.git/* >> logs.txt
mv StupidRhythm.love out/release/love >> logs.txt
./love out/release/love/StupidRhythm.love >> logs.txt
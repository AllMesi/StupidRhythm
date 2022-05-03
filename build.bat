@echo off
cls
rmdir build /S /Q > NUL 2> NUL
mkdir build > NUL
mkdir build\bin > NUL
mkdir build\bin\exe > NUL
mkdir build\bin\exe\x32 > NUL
mkdir build\bin\exe\x64 > NUL
mkdir build\bin\love > NUL
mkdir tmp > NUL 2> NUL
curl -o love2d.zip https://github.com/love2d/love/releases/download/11.4/love-11.4-win64.zip -L -s > NUL
curl -o love2dx32.zip https://github.com/love2d/love/releases/download/11.4/love-11.4-win32.zip -L -s > NUL
tar -xf love2d.zip -C tmp > NUL
tar -xf love2dx32.zip -C tmp > NUL
rename tmp\love-11.4-win64 love2d > NUL
rename tmp\love-11.4-win32 love2dx32 > NUL
del love2d.zip > NUL
del love2dx32.zip > NUL
StupidRhythm\other\7z a -tzip StupidRhythm.love .\StupidRhythm\src\* > NUL
copy /b tmp\love2d\love.exe+StupidRhythm.love build\bin\exe\x64\StupidRhythm.exe > NUL
copy /b tmp\love2dx32\love.exe+StupidRhythm.love build\bin\exe\x32\StupidRhythm.exe > NUL
copy /b tmp\love2d\lovec.exe+StupidRhythm.love build\bin\exe\x64\StupidRhythmC.exe > NUL
copy /b tmp\love2dx32\lovec.exe+StupidRhythm.love build\bin\exe\x32\StupidRhythmC.exe > NUL
copy tmp\love2d\license.txt build\bin\exe\x64\love2dLicense.txt > NUL
copy tmp\love2d\readme.txt build\bin\exe\x64\love2dReadMe.txt > NUL
copy tmp\love2d\license.txt build\bin\exe\x32\love2dLicense.txt > NUL
copy tmp\love2d\readme.txt build\bin\exe\x32\love2dReadMe.txt > NUL
copy tmp\love2d\license.txt build\bin\love\love2dLicense.txt > NUL
copy tmp\love2d\readme.txt build\bin\love\love2dReadMe.txt > NUL
copy LICENSE build\bin\love\license.txt > NUL
copy LICENSE build\bin\exe\x32\license.txt > NUL
copy LICENSE build\bin\exe\x64\license.txt > NUL
xcopy tmp\love2d\*.dll build\bin\exe\x64 /E /Y > NUL
xcopy tmp\love2dx32\*.dll build\bin\exe\x32 /E /Y > NUL
move StupidRhythm.love build\bin\love > NUL
rmdir tmp /S /Q > NUL
xcopy StupidRhythm\other\* build\bin\exe\x64 /E /Y > NUL
xcopy StupidRhythm\other\* build\bin\exe\x32 /E /Y > NUL
xcopy StupidRhythm\other\discordRPC.dll build\bin\exe\x64 /E /Y > NUL
xcopy StupidRhythm\other\discordRPC.dll build\bin\love /E /Y > NUL
xcopy StupidRhythm\other\discordRPCx32.dll build\bin\exe\x32 /E /Y > NUL
xcopy StupidRhythm\other\* build\bin\love /E /Y > NUL
del build\bin\exe\x32\discordRPC.dll > NUL
del build\bin\exe\x32\7z.dll > NUL
del build\bin\exe\x32\7z.exe > NUL
del build\bin\exe\x64\7z.dll > NUL
del build\bin\exe\x64\7z.exe > NUL
del build\bin\exe\x64\discordRPCx32.dll > NUL
del build\bin\love\7z.dll > NUL
del build\bin\love\7z.exe > NUL
del build\bin\love\discordRPCx32.dll > NUL
rename build\bin\exe\x32\discordRPCx32.dll discordRPC.dll > NUL
StupidRhythm\other\7z a -tzip build\StupidRhythm-Win64.zip .\build\bin\exe\x64\* > NUL
StupidRhythm\other\7z a -tzip build\StupidRhythm-Win32.zip .\build\bin\exe\x32\* > NUL
StupidRhythm\other\7z a -tzip build\StupidRhythm-LOVE.zip .\build\bin\love\* > NUL
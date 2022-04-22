@echo off
rmdir build /S /Q
mkdir tmp
curl -o love2d.zip https://github.com/love2d/love/releases/download/11.4/love-11.4-win64.zip -L
curl -o love2dx32.zip https://github.com/love2d/love/releases/download/11.4/love-11.4-win32.zip -L
tar -xf love2d.zip -C tmp
tar -xf love2dx32.zip -C tmp
rename tmp\love-11.4-win64 love2d
rename tmp\love-11.4-win32 love2dx32
del love2d.zip
del love2dx32.zip
other\7z a -tzip StupidRhythm.love .\src\*
mkdir build
mkdir build\bin
mkdir build\bin\exe
mkdir build\bin\exe\x32
mkdir build\bin\exe\x64
mkdir build\bin\love
copy /b tmp\love2d\love.exe+StupidRhythm.love build\bin\exe\x64\StupidRhythm.exe
copy /b tmp\love2dx32\love.exe+StupidRhythm.love build\bin\exe\x32\StupidRhythm.exe
xcopy tmp\love2d\*.dll build\bin\exe\x64 /E /Y
xcopy tmp\love2dx32\*.dll build\bin\exe\x32 /E /Y
move StupidRhythm.love build\bin\love
rmdir tmp /S /Q
xcopy other\* build\bin\exe\x64 /E /Y /exclude:copyExclude.txt
xcopy other\* build\bin\exe\x32 /E /Y /exclude:copyExclude.txt
xcopy other\discordRPC.dll build\bin\exe\x64 /E /Y
xcopy other\discordRPC.dll build\bin\love /E /Y
xcopy other\discordRPCx32.dll build\bin\exe\x32 /E /Y
rename build\bin\exe\x32\discordRPCx32.dll discordRPC.dll
xcopy other\* build\bin\love /E /Y /exclude:copyExclude.txt
other\7z a -tzip build\StupidRhythm-Win32.zip .\build\bin\exe\x32
other\7z a -tzip build\StupidRhythm-Win64.zip .\build\bin\exe\x64
other\7z a -tzip build\StupidRhythm-LOVE.zip .\build\bin\love\
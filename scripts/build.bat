@echo off

set executableName=StupidRhythm
set gameName=StupidRhythm
set dest=dist
set sourceFolder=source

IF [%1] == [] goto help
IF [%1] == [clean] goto clean
IF [%1] == [run] goto run
IF [%1] == [build] goto build

:help
    echo Usage: build.bat clean^|build^|run
    exit /B

:clean
    cd ..
    rmdir %dest% /S /Q > NUL 2>NUL
    cd scripts
    exit /B

:run
    cd ..
    %dest%\%executableName%.exe --console
    cd scripts
    exit /B

:build
    cd ..
    rmdir %dest% /S /Q > NUL 2>NUL
    mkdir %dest% > NUL 2>NUL
    mkdir tmp > NUL 2>NUL
    %gameName%\other\7z a -tzip tmp\StupidRhythm.love .\%gameName%\%sourceFolder%\* > NUL 2>NUL
    copy /b StupidRhythm\LOVE\love.exe+tmp\StupidRhythm.love %dest%\%executableName%.exe > NUL 2>NUL
    xcopy StupidRhythm\LOVE\*.dll %dest%\ /E /Y > NUL 2>NUL
    xcopy %gameName%\other\* %dest% /E /Y > NUL 2>NUL
    del %dest%\7z.dll > NUL 2>NUL
    del %dest%\7z.exe  > NUL 2>NUL
    mkdir %dest%\stuff > NUL 2>NUL
    copy StupidRhythm\LOVE\license.txt %dest%\stuff\love2dLicense.txt > NUL 2>NUL
    copy StupidRhythm\LOVE\readme.txt %dest%\stuff\love2dReadMe.txt > NUL 2>NUL
    copy license %dest%\stuff\license.txt > NUL 2>NUL
    rmdir tmp /S /Q > NUL 2>NUL
    cd scripts > NUL 2>NUL
    exit /B
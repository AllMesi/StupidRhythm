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
    curl -o love2d.zip https://github.com/love2d/love/releases/download/11.4/love-11.4-win64.zip -L -s
    tar -xf love2d.zip -C tmp > NUL 2>NUL
    rename tmp\love-11.4-win64 love2d > NUL 2>NUL
    del love2d.zip > NUL 2>NUL
    %gameName%\other\7z a -tzip tmp\StupidRhythm.love .\%gameName%\%sourceFolder%\* > NUL 2>NUL
    copy /b tmp\love2d\love.exe+tmp\StupidRhythm.love %dest%\%executableName%.exe > NUL 2>NUL
    xcopy tmp\love2d\*.dll %dest%\ /E /Y > NUL 2>NUL
    xcopy %gameName%\other\* %dest% /E /Y > NUL 2>NUL
    del %dest%\7z.dll > NUL 2>NUL
    del %dest%\7z.exe  > NUL 2>NUL
    mkdir %dest%\stuff > NUL 2>NUL
    copy tmp\love2d\license.txt %dest%\stuff\love2dLicense.txt > NUL 2>NUL
    copy tmp\love2d\readme.txt %dest%\stuff\love2dReadMe.txt > NUL 2>NUL
    copy license %dest%\stuff\license.txt > NUL 2>NUL
    rmdir tmp /S /Q > NUL 2>NUL
    cd scripts > NUL 2>NUL
    exit /B
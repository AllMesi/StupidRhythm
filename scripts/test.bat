@echo off
cd ..
rmdir test /S /Q 2> NUL > NUL
mkdir test > NUL
xcopy StupidRhythm\other\* test /E /Y > NUL
xcopy StupidRhythm\source\* test /E /Y > NUL
del test\7z.dll > NUL
del test\7z.exe > NUL
lovec test > NUL
rmdir test /S /Q > NUL
cd scripts
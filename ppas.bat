@echo off
SET THEFILE=c:\users\joaolo~1\desktop\pascal~1\game.exe
echo Linking %THEFILE%
c:\progra~2\dev-pas\bin\ldw.exe  -s   -b base.$$$ -o c:\users\joaolo~1\desktop\pascal~1\game.exe link.res
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end

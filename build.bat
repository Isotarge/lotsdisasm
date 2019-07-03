@echo off
echo Assembling...
binaries\wla-z80 -v -o lots.o lots.asm > bank_info.txt
if %ERRORLEVEL% neq 0 goto assemble_fail

echo Linking...
binaries\wlalink -s lots.link lotsbuilt.sms
if %ERRORLEVEL% neq 0 goto link_fail

binaries\MSChecksumFixer lotsbuilt.sms

echo ==========================
echo   Build Success.
echo ==========================

IF EXIST bank_info.txt del bank_info.txt
IF EXIST lots.o del lots.o

goto end

:assemble_fail
echo Error while assembling.
goto fail
:link_fail
echo Error while linking.
:fail

echo ==========================
echo   Build failure."
echo ==========================

pause

:end
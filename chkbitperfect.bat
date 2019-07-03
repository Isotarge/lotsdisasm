@ECHO OFF

REM // build the ROM
call build %1

REM  // run fc
echo -------------------------------------------------------------
IF EXIST lotsbuilt.sms ( fc /b lotsbuilt.sms lotsoriginal.sms
) ELSE echo lotsbuilt.sms does not exist, probably due to an assembly error

REM // clean up after us
IF EXIST bank_info.txt del bank_info.txt
IF EXIST lots.o del lots.o
IF EXIST lotsbuilt.sym del lotsbuilt.sym
IF EXIST lotsbuilt.sms del lotsbuilt.sms

REM // if someone ran this from Windows Explorer, prevent the window from disappearing immediately
pause

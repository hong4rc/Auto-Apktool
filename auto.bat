@echo off
:: dont show code

:: set Root and color
setlocal EnableDelayedExpansion
mode con: cols=70 lines=40
set root=%cd%
set mIn=Apk_In
set mWorking=Working
set mOut=Apk_Out
set mSystem=System
set mList=%mSystem%\list.txt

color 71

:: create folder
if not exist %mIn% MD %mIn%
if not exist %mWorking% MD %mWorking%
if not exist %mOut% MD %mOut%

:: check java
java -version
if errorlevel 1 (
 echo May tinh cua ban chua cai JAVA
 echo.
 pause
 exit
 ) else goto :MAIN_MENU
:MAIN_MENU
    cls
    echo     1.    Import framework
    echo     2.    Decompile file apk
    echo     3.    Recompile file apk
    echo     4.    Sign file apk
    echo     X.    Exit

    set oAction=nul
    set /p oAction=   Nhap so tuong ung de thuc hien:

    set oD=-d
    :: choose dir to get list
    if "%oAction%"=="1" (
        set dir=%mIn%
        set mAction=importFramework
    ) else if "%oAction%"=="2" (
        set dir=%mIn%
        set mAction=decompileApk
    ) else if "%oAction%"=="3" (
        set dir=%mWorking%
        set mAction=recompileApk
        set oD=d
    ) else if "%oAction%"=="4" (
        set dir=%mOut%
        set mAction=signApk
    ) else if "%oAction%"=="X" (
        exit
    ) else goto:MAIN_MENU
    :reCall
    call :getListFile
    call :%mAction% %file%
    pause
    goto:reCall



goto:eof

:getListFile
    cd %root%
    cd .\%dir%
    set file=""
    set log=-

    :choose
    cls

    set i=0
    set list=.
    for /f "delims=" %%d in ('dir /a:%oD% /b') do (
        set /A i+=1
        set list[!i!]=%%d
        echo !i! - %%d
    )
    echo.
    call:showX
    echo %log%
    set log=-


    set /p oFile=Nhap so tuong ung:
    if %oFile%==x goto :MAIN_MENU

    :: check is number
    set "var="&for /f "delims=0123456789" %%i in ("%oFile%") do set var=%%i
    if defined var (
        set log= Vui long nhap so
        goto:choose
    )


    set file=!list[%oFile%]!

    cd %root%




goto:eof

:showX
    echo -----------
    echo - X:Thoat -
    echo -----------
goto:eof

:getApkFromList

goto:eof

:importFramework
    call:apktool if %mIn%\%~1
goto:eof

:decompileApk
    call:apktool -f d %mIn%\%~1 -o %mWorking%\%~1
goto:eof

:recompileApk
    call:apktool b %mWorking%\%~1 -o %mOut%\%~1
goto:eof

:signApk
    java -jar %mSystem%\sign.jar  %mOut%\%~1
goto:eof

:apktool
    java -jar %mSystem%\apktool.jar %1 %2 %3 %4 %5 %6 %7 %8 %9
goto:eof
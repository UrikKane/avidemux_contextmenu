@echo off
setlocal enabledelayedexpansion
title Remove Avidemux context menu entry

set allvideo=avi,asf,wmv,wma,flv,mkv,mpg,mpeg,ts,mp4,nuv,ogm,mov,mts,m2ts,3gp,vob,webm

:check_permissions
net session >nul 2>&1
if not %errorLevel% == 0 echo   & echo Error: Must run as administrator. & pause>nul & goto :eof

:: ask extensions
echo.
echo example: mp4,avi,mkv (divide by comma, no dots)
echo or just press enter for default
echo.
set /p extensions="What extensions to delete for (default ALL): "
if "%extensions%"=="" set "extensions=%allvideo%"

:: exec for all extensions
for %%E in (%extensions%) do CALL :DelKey %%E

:: results
echo.
echo -------------------------------------------------------
if "!processedcount!"=="" ( echo  No entries to remove ) else ( echo  !processedcount! entries removed: !processed! )
echo -------------------------------------------------------
echo.
pause & goto :eof

:DelKey
::reg query "HKCR\SystemFileAssociations\.%1\shell\AviDemux.open">nul 2>&1
::if not !errorlevel!==0 goto :eof
reg delete "HKCR\SystemFileAssociations\.%1\shell\AviDemux.open" /f>nul 2>&1
if !errorlevel!==0 CALL :LogFileType %1
goto :eof

:LogFileType
if "!processedcount!"=="" ( set "processedcount=1" ) else ( set /a "processedcount=!processedcount!+1" ) 
if "!processed!"=="" ( set "processed=%1" ) else ( set "processed=!processed!,%1" )
goto :eof
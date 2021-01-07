@echo off
setlocal enabledelayedexpansion
title Remove Avidemux context menu entry

set default_extensions=3gp,asf,avi,flv,m2ts,m4p,m4v,mkv,mov,mp2,mp4,mpe,mpeg,mpg,mpv,mts,nuv,ogm,qt,swf,ts,vob,webm,wma,wmv,xmf

:check_elevation
net session >nul 2>&1
if not %errorlevel%==0 echo   & echo Error: Must run as administrator. & pause>nul & goto :eof

:: exec for all extensions
for %%E in (%default_extensions%) do CALL :CheckKey %%E

if "%found%"=="" ( echo  & echo No entries to remove^^! Exiting.& pause>nul & goto :eof) else ( echo Found entries for^: %found%)

:hintextensions
echo.
echo Please enter file extensions to remove, divided by comma, lowercase, no dots or just press enter for remove ALL
echo.
:askextensions
set /p extensions="What extensions to delete for (default %found%): "
if not "!extensions!"=="" (
	set "extensions=!extensions: =!"
	for /f "tokens=1 delims=abcdefghijklmnopqrstuvwxyz1234567890," %%A in ('echo !extensions!') do (
		set "extensions=%default_extensions%"
		echo Warning: input incorrect, will use default setting ^(%found%^)
		pause
	)
) else ( set "extensions=%found%" )

:: exec for all extensions
for %%E in (%extensions%) do CALL :DelKey %%E

:: results
echo.
echo -------------------------------------------------------
if "!processedcount!"=="" ( echo  No entries to remove ) else ( echo  !processedcount! entries removed: !processed! )
echo -------------------------------------------------------
echo.
pause & goto :eof

:CheckKey
reg query "HKCR\SystemFileAssociations\.%1\shell\AviDemux.open">nul 2>&1 && CALL :LogExtFound %1
goto :eof

:DelKey
reg delete "HKCR\SystemFileAssociations\.%1\shell\AviDemux.open" /f>nul 2>&1 && CALL :LogExtRemoved %1
goto :eof

:LogExtRemoved
if "!processedcount!"=="" ( set "processedcount=1" ) else ( set /a "processedcount=!processedcount!+1" ) 
if "!processed!"=="" ( set "processed=%1" ) else ( set "processed=!processed!,%1" )
goto :eof

:LogExtFound
if "!foundcount!"=="" ( set "foundcount=1" ) else ( set /a "foundcount=!foundcount!+1" ) 
if "!found!"=="" ( set "found=%1" ) else ( set "found=!found!,%1" )
goto :eof
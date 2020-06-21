@echo off
setlocal enabledelayedexpansion
title Add Avidemux context menu entry (manual)

set default_extensions=mp4,mov,mts,m2ts,mkv

:check_permissions
net session >nul 2>&1
if not %errorLevel% == 0 echo   & echo Error: Must run as administrator. & pause>nul & goto :eof

:hintfolder
echo Please enter Avidemux folder, for example C:\Program Files\Avidemux 2.7
echo.
:askfolder
set installpath=
echo.
set /p installpath="Enter your avidemux folder "
for %%A in (%installpath%) do goto :next
goto :askfolder
:next
set installpath=%installpath:"=%
if "%installpath:~-1%"=="\" set "installpath=%installpath:~0,-1%"
if "%installpath:~-1%"=="/" set "installpath=%installpath:~0,-1%"
for %%A in (avidemux.exe,avidemux_portable.exe) do ( 
	if exist "%installpath%\%%A" (
		set "installpath=%installpath%\%%A"
		echo. & echo Selected Avidemux: "!installpath!"
		goto :hintextensions
	)
)
echo Error: Could not find Avidemux executable in given folder
goto :askfolder

:hintextensions
echo.
echo Please enter file extensions to add, for example: mp4,avi,mkv (lowercase, divide by comma, no dots), or just press enter for default list
echo.
:askextensions
set /p extensions="What extensions to add for (default %default_extensions%): "
if not "!extensions!"=="" (
	set "extensions=!extensions: =!"
	for /f "tokens=1 delims=abcdefghijklmnopqrstuvwxyz1234567890," %%A in ('echo !extensions!') do (
		set "extensions=%default_extensions%"
		echo Warning: input incorrect, will use default setting ^(%default_extensions%^)
		pause
	)
) else ( set "extensions=%default_extensions%" )

:: exec for all extensions
for %%E in (%extensions%) do CALL :SetKeys %%E

:: results
echo.
echo -------------------------------------------------------
if "!processedcount!"=="" ( echo  No entries added ) else ( echo  !processedcount! entries added: !processed! )
echo -------------------------------------------------------
echo.
pause & goto :eof


:SetKeys
reg add "HKCR\SystemFileAssociations\.%1\shell\AviDemux.open" /f /v "" /t REG_SZ /d "Open in Avidemux">nul 2>&1
reg add "HKCR\SystemFileAssociations\.%1\shell\AviDemux.open" /f /v "Icon" /t REG_SZ /d "\"%installpath%\",0">nul 2>&1
reg add "HKCR\SystemFileAssociations\.%1\shell\AviDemux.open\command" /f /v "" /t REG_SZ /d "\"%installpath%\" \"%%1\"">nul 2>&1
if !errorlevel!==0 CALL :LogFileType %1
goto :eof

:LogFileType
if "!processedcount!"=="" ( set "processedcount=1" ) else ( set /a "processedcount=!processedcount!+1" ) 
if "!processed!"=="" ( set "processed=%1" ) else ( set "processed=!processed!,%1" )
goto :eof
@echo off
setlocal enabledelayedexpansion
title Add Avidemux context menu entry

set default_extensions=mp4,mov,mts,m2ts,mkv

:check_permissions
net session >nul 2>&1
if not %errorLevel% == 0 echo   & echo Error: Must run as administrator. & pause>nul & goto :eof

:: find installation path
cd /d %programfiles%
set foundcount=0
for /f "tokens=*" %%F in ('dir /b /a:d /o:-n ^|find /i "avidemux"') do (	
	for %%A in (avidemux.exe,avidemux_portable.exe) do (
		if exist "%%~F\%%A" (
		set /a foundcount=!foundcount!+1
		echo Found Avidemux: %programfiles%\%%~F\%%A
		set "foundpath!foundcount!=%programfiles%\%%~F\%%A"		
		)
	)
)
if !foundcount!==0 echo Error: Could not find installation folder. & pause>nul & goto :eof
if !foundcount!==1 (
	set "installpath=%foundpath1%"
	goto :hintextensions
)
FOR /L %%F IN (1,1,%foundcount%) DO ( if ""!folderidlist!=="" ( set folderidlist=%%F) else ( set folderidlist=!folderidlist!,%%F))

:AskFolder
echo.
echo please choose folder ^( !folderidlist! ^)
FOR /L %%F IN (1,1,%foundcount%) DO ( echo  %%F     !foundpath%%F!)
echo.
set folderid=
set /p folderid="enter number    = "
if not "!folderid!"=="" (
	set "folderid=!folderid: =!"
	for /f "delims=1234567890" %%A in ('echo !folderid!') do echo ERROR: !folderid! - only numbers are allowed^^! & goto :AskFolder
	for %%A in (%folderidlist%) do if "!folderid!"=="%%A" (	
		set "installpath=!foundpath%%A!"
		echo. & echo Selected folder: !installpath!
		goto :hintextensions
	)
	echo ERROR: !folderid! is NOT a valid option^^!
)
goto :AskFolder

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
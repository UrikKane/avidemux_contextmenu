@echo off
setlocal enabledelayedexpansion
title Fix Avidemux location open with (auto)

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
	goto :SetKeys
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

:SetKeys
set regkey="HKCR\Applications\avidemux.exe\shell\open\command"
if not !errorlevel!==0 echo Could not find registry key. Create one? & pause
reg add "HKCR\Applications\avidemux.exe\shell\open\command" /f /v "" /t REG_SZ /d "\"%installpath%\avidemux.exe\" \"%%1\""

:: results
echo.
echo -------------------------------------------------------
if !errorlevel!==0 ( echo  Succesfully changed value ) else ( echo  Failed to change value)
echo -------------------------------------------------------
echo.
pause & goto :eof
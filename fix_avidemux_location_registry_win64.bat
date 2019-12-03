@echo off
setlocal enabledelayedexpansion
title Fix Avidemux location open with (auto)

:check_permissions
net session >nul 2>&1
if not %errorLevel% == 0 echo Error: Must run as administrator. & pause>nul & goto :eof

:: find installation path
cd /d %programfiles%
for /f "tokens=*" %%F in ('dir /b /a:d /o:-n ^|find /i "avidemux"') do (
	if exist %%F\avidemux.exe (
	set "installpath=%programfiles%\%%F"
	echo Found Avidemux folder %programfiles%\%%F
	goto :SetKeys
	)
)
echo Error: Could not find installation folder. & pause>nul & goto :eof

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
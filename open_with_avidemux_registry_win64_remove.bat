@echo off
setlocal enabledelayedexpansion
title Remove Avidemux from registry

:check_elevation
net session >nul 2>&1
if not %errorlevel%==0 echo   & echo Error: Must run as administrator. & pause>nul & goto :eof

:SetKeys
reg query "HKCR\Applications\avidemux.exe\shell\open\command">nul 2>&1 || ( echo Registry key has already been deleted - nothing to delete & pause & goto :eof)
reg delete "HKCR\Applications\avidemux.exe\shell\open\command" /f>nul 2>&1

:: results
echo.
echo -------------------------------------------------------
if !errorlevel!==0 ( echo  Succesfully deleted key ) else ( echo  Failed to delete key)
echo -------------------------------------------------------
echo.
pause & goto :eof
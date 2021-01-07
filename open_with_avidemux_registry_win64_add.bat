@echo off
setlocal enabledelayedexpansion
title Add/Update Avidemux in registry

:check_elevation
net session >nul 2>&1
if not %errorlevel%==0 echo   & echo Error: Must run as administrator. & pause>nul & goto :eof

set executables=avidemux.exe,avidemux_portable.exe
set foundcount=0

:: search in C:\Program Files
cd /d %programfiles%
for /d %%F in (*avidemux*) do ( for %%X in (%executables%) do ( if exist "%%~F\%%~X" ( CALL :LogFoundFolder "%programfiles%\%%~F\%%~X")))

:: search in the same folder the script is located in
cd /d "%~dp0"
for %%X in (%executables%) do ( if exist "%~dp0%%~X" ( cd..\.. & CALL :LogFoundFolder "%~dp0%%~X"))


if !foundcount!==0 echo Could not auto-find any installations. & goto :hintcustomfolder
if !foundcount!==1 goto :ConfirmFolder
FOR /L %%F IN (1,1,%foundcount%) DO ( if ""!folderidlist!=="" ( set folderidlist=%%F) else ( set folderidlist=!folderidlist!,%%F))


:SelectFoundFolder
echo.
echo please choose folder ^( !folderidlist! or custom^)
FOR /L %%F IN (1,1,%foundcount%) DO ( echo  %%F     !foundpath%%F!)
echo.
set folderid=
set /p folderid="enter number !folderidlist! or word ^"custom^"   = "
if not "!folderid!"=="" (
	set "folderid=!folderid: =!"
	for %%A in (!folderid!) do ( if /i "%%~A"=="custom" goto :hintcustomfolder)
	for /f "delims=1234567890" %%A in ('echo !folderid!') do echo ERROR: !folderid! - only numbers are allowed^^! & goto :SelectFoundFolder
	for %%A in (%folderidlist%) do if "!folderid!"=="%%A" (	
		set "installpath=!foundpath%%A!"
		echo. & echo Selected folder: !installpath!
		goto :SetKeys
	)
	echo ERROR: !folderid! is NOT a valid option^^!
)
goto :SelectFoundFolder

:hintcustomfolder
echo.
echo Please enter Avidemux folder
echo.
:AskCustomFolder
set installpath=
set /p installpath="Enter Avidemux folder "
for %%P in (%installpath%) do goto :next
goto :AskCustomFolder
:next
set installpath=%installpath:"=%
if "%installpath:~-1%"=="\" set "installpath=%installpath:~0,-1%"
if "%installpath:~-1%"=="/" set "installpath=%installpath:~0,-1%"
for %%P in (%installpath%) do (
	if exist "%installpath%" (
		if not "%%~xP"=="" ( for %%X in (%executables%) do ( if /i "%%~nxP"=="%%~X"	CALL :SetCustomFolder "%installpath%" & goto :ConfirmFolder))
		for %%X in (%executables%) do ( if exist "%installpath%\%%~X" ( CALL :SetCustomFolder "%installpath%\%%~X" & goto :ConfirmFolder))
	)
)
echo  & echo Error^: Could not find installation in provided folder. & echo. & goto :AskCustomFolder

:SetKeys
reg query "HKCR\Applications\avidemux.exe\shell\open\command">nul 2>&1 || ( echo Could not find registry key. Create one? & pause)
reg add "HKCR\Applications\avidemux.exe\shell\open\command" /f /v "" /t REG_SZ /d "\"%installpath%\" \"%%1\""

:: results
echo.
echo -------------------------------------------------------
if !errorlevel!==0 ( echo  Succesfully changed value & CALL :OpenKey) else ( echo  Failed to change value)
echo -------------------------------------------------------
echo.
pause & goto :eof

:OpenKey
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" /v "LastKey" /d "HKCR\Applications\avidemux.exe\shell\open\command" /f>nul 2>&1
start /b regedit
goto :eof

:LogFoundFolder
set /a foundcount=!foundcount!+1
echo.
echo Avidemux installation found: "%~1"
set "foundpath!foundcount!=%~1"
goto :eof

:SetCustomFolder
echo.
echo Avidemux custom installation: "%~1" & echo.
set "foundpath1=%~1"
goto :eof

:ConfirmFolder
set proceed=
set /p "proceed=Use this installation (Y/N)?"
if not "!proceed!"=="" (
	set "proceed=!proceed: =!"
	for /f "delims=yYnN" %%A in ('echo !proceed!') do goto :ConfirmFolder
)
if /i !proceed!==y ( set "installpath=%foundpath1%" & goto :SetKeys)
if /i !proceed!==n ( echo. & goto :hintcustomfolder)
goto :ConfirmFolder
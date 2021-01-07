@echo off
setlocal enabledelayedexpansion
title Add Avidemux context menu entry

set default_extensions=mp4,mov,mts,m2ts,mkv

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
		goto :hintextensions
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

:hintextensions
echo.
echo Please enter file extensions to remove, divided by comma, lowercase, no dots or just press enter for default list
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
if /i !proceed!==y ( set "installpath=%foundpath1%" & goto :hintextensions)
if /i !proceed!==n ( echo. & goto :hintcustomfolder)
goto :ConfirmFolder
@echo off & title No-Bling DOTA mod builder

:: manually override required STEAMPATH variable here if needed
set "STEAMPATH=C:\Program Files (x86)\Steam"

:: detect STEAMPATH
for /f "tokens=2*" %%R in ('reg query HKCU\SOFTWARE\Valve\Steam /v SteamPath') do set "steampath_reg=%%S"
if not exist "%STEAMPATH%\steamapps\libraryfolders.vdf" for %%S in ("%steampath_reg%") do set "STEAMPATH=%%~fS"
if not exist "%STEAMPATH%\steamapps\libraryfolders.vdf" echo [ERROR] STEAMPATH not found! Set it manually in the script

:: prepare
cd/d "%~dp0" & (taskkill /f /im vpkmod.exe & del /f /q vpkmod.exe) >nul 2>nul
set "SHORTCUT=%USERPROFILE%\Desktop\No-Bling-DOTA.bat"
echo @set "STEAMPATH=%STEAMPATH%" ^& call "%~dp0vpkmod.exe" -b -s ^& start "dota" steam://rungameid/570 > "%SHORTCUT%"

:: csc compile vpkmod tool
for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d /o:-n "%SystemRoot%\Microsoft.NET\Framework\*csc.exe"') do set "csc=%%v"
"%csc%" /out:vpkmod.exe /target:exe /platform:anycpu /optimize /nologo /define:NOTMONO "vpkmod.cs"
if not exist vpkmod.exe echo [ERROR] compiling VPKMOD C# code! Needs .net framework 4.0 / VS2010 compiler & pause & exit

:: launch vpkmod with -b option for building No-Bling DOTA mod
vpkmod.exe -b

echo Press any key to start DOTA
timeout -1 >nul
start "dota" steam://rungameid/570

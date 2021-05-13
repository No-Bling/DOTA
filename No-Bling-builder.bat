@echo off & title No-Bling DOTA mod builder

:: manually override required STEAMPATH variable here if needed
set "STEAMPATH=D:\SteamLibrary\steamapps\common\dota 2 beta

:: detect STEAMPATH
for /f "tokens=2*" %%R in ('reg query HKCU\SOFTWARE\Valve\Steam /v SteamPath 2^>nul') do set "steampath_reg=%%S"
if not exist "%STEAMPATH%\steamapps\libraryfolders.vdf" for %%S in ("%steampath_reg%") do set "STEAMPATH=%%~fS"

:: Define color macros [windows10]: %<% = <ESC> and %>% = <ESC>[0m
for /f "tokens=3 delims=." %%b in ('ver') do if %%b gtr 14393 for /f %%s in ('echo prompt $E^|cmd') do set "<=%%s"&set ">=%%s[0m"

if not exist "%STEAMPATH%\steamapps\libraryfolders.vdf" (
  echo %<%[1;7;91m [ERROR] STEAMPATH not found! Set it manually in the script %>%` & timeout -1 >nul & exit/b
)

:: prepare
cd/d "%~dp0" & (taskkill /f /im vpkmod.exe & del /f /q vpkmod.exe) >nul 2>nul
set "SHORTCUT=%USERPROFILE%\Desktop\No-Bling-DOTA.bat"
echo @set "STEAMPATH=%STEAMPATH%" ^& call "%~dp0vpkmod.exe" -b -s ^& start "dota" steam://rungameid/570 > "%SHORTCUT%"

:: csc compile vpkmod tool
for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d /o:-n "%SystemRoot%\Microsoft.NET\Framework\*csc.exe"') do set "csc=%%v"
"%csc%" /out:vpkmod.exe /target:exe /platform:anycpu /optimize /nologo /define:NOTMONO "vpkmod.cs"
if not exist vpkmod.exe (
  echo %<%[1;7;91m [ERROR] compiling VPKMOD C# code! Needs .net framework 4.0 / VS2010 compiler %>%` & timeout -1 >nul & exit
)

:: launch vpkmod with -b option for building No-Bling DOTA mod
vpkmod.exe -b

echo Press any key to start DOTA
timeout -1 >nul
start "dota" steam://rungameid/570

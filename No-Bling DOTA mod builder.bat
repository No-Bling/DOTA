::             No-Bling dota_lv mod builder by AveYo
:: Tools used by this script require Windows x64! version 10 recommended, 7 tested fine 
@echo off &setlocal enableextensions disabledelayedexpansion &set version=1.0
::----------------------------------------------------------------------------------------------------------------------------------
:"BAT_Options"
::----------------------------------------------------------------------------------------------------------------------------------
:: Script options - not available in gui so set them here if needed
set "@dialog=1"           || :gui_choices_wait 1 = show choices dialog and wait on end, 0 = no dialog, auto-close window
set "@timers=1"           || :measure_run      1 = total and per tasks accurate timer,  0 = no timers
set "MOD_DIR=MOD"         || :work_folder      ~ = defaults to batch file subdirectory MOD
set "VPK_ROOT=particles"  || :vpk_root         ~ = this is a particles-only mod, no other file types modified
:: No-Bling DOTA mod builder gui choices - no need to edit defaults here, script shows a graphical dialog later for easier selection
set "-LowViolence=1"      || :Restore_Blood    1 = undo -lv launch option turning all blood into alien green              Essential!
set "Events=1"            || :Event_Rewards    1 = the International 7 custom tp, blink etc.
set "Spells=1"            || :Custom_Spells    1 = penguin Frostbite and stuff like that..
set "Hats=1"              || :Workshop_Hats    1 = cosmetic particles spam - slowly turning into TF2..
set "Heroes!=1"           || :Default_Heroes   1 = model particles, helps potato pc's but glancevalue can suffer            Careful!
set "Wards=1"             || :Custom_Wards     1 = only a few of them make the ward and the sentry item too similar
set "Couriers=1"          || :Custom_Couriers  1 = couriers particles are fine.. until a dumber abuses gems on hats 
set "Towers=1"            || :Penis_Contest    1 = just the tower particle effects, models remain unchanged
set "Soundboard=1"        || :Chatwheel_sounds 1 = silence the annoying chatwheel sounds - temporarily featured
set "@verbose=1"          || :verbose_output   1 = print file names and export detailed per-hero item lists
set "@refresh=0"          || :recompile_mod    1 = recompile mod instead of reusing cached files - usually not needed
::----------------------------------------------------------------------------------------------------------------------------------
:"BAT_Main"
::----------------------------------------------------------------------------------------------------------------------------------
title No-Bling DOTA mod builder by AveYo - version %version% &call :set_window 0 7 120 40 ||:i Bg Fg Cols Lines
:: no-bling dota logo powershell snippet cached temporarily to %ps_dota%
setlocal &rem free script so no bitching!
set "322=  ,,,,,, ,,,,,,,,,     , ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, ,,     :"
set "323= ,,:.................:,,,,,,,,,:.........:,,,,,,:............:,,:.......:,    :"
set "324= ,,:......................................:,,:.......................:,,  :"
set "325= ,,,:.............................................................:,,,  :"
set "326= ,,,:.............................................................:,,,  :"
set "327= ,,,:.............................................................:,,,  :"
set "328=,,,,:........:,,,,:................................:,,,:..............:,,,  :"
set "329= ,,:........:,,,,,,,:.......................:,,,,,,,,,,,,:.............:,,, :"
set "330=,,,:..........:,,,,,,,,:.....................:,,, ,    ,,,:............:,,, :"
set "331= ,,:............:,,,  ,,,,,:....................:,,,,  ,,:.............:,,  :"
set "332=,,,:..............:,,,  ,,,,,,:...................:,,,,,,:.............:,,  :"
set "333= ,,,:...............:,,    ,,,,,:....................:,,,:............:,,,  :"
set "334=  ,,:................:,,,       ,,,,:..............................:,,    :"
set "335=  ,,:..................:,,,,      ,,,,,:..........................:,,,    :"
set "336=  ,,:....................:,,,       , ,,,:.........................:,,,   :"
set "337=  ,,:......................:,,,         ,,,,:.......................:,,   :"
set "338=  ,,,:.......................:,,,,        ,,,,,:....................:,,,  :"
set "339= ,,,:..........................:,,,           ,,,,:.................:,,,  :"
set "340= ,,:.............................:,,,            ,,,,:..............:,,,  :"
set "341= ,,:..............................:,,,,            ,,,,,:............:,,  :"
set "342= ,,:...........:,,:...................:,,,,             ,,,,,:.........:,,, :"
set "343= ,,,:.........:,,,,,:....................:,,,               ,,:........:,,  :"
set "344=   ,,:.......:,,, ,,,,:...................:,,,,            ,,,:........:,,, :"
set "345=  ,,,:.......:,,,    ,,,:...................:,,,,          ,,:.........:,,, :"
set "346= ,,,:.......:,,,      ,,,,:...................:,,,        ,,:..........:,,  :"
set "347= ,,:.........:,,,     ,,,,,,:...................:,,,, ,  ,,,:..........:,, ,:"
set "348= ,,:...........:,,,,,,,,,:......................:,,,,,,,:...........:,,,    :"
set "349= ,,:...............................................................:,,, :"
set "350= ,,:...............................................................:,,, :"
set "351=,,,:..............................                         ........:,, ,:"
set "352= ,,:..............................: No-: Bling : mod by AveYo :........:,,, :"
set "353=,,,,:.............................                         ........:, , :"
set "354= ,,,,,,,,,,,,,,,,,,,,,,,,,:..:,,,:.............................:,,,,:..:,,, :"
set "355=    , ,,, ,,,, , , ,,,,,,,,, ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  ,,,,   :"
set "356=                                                                      :"
set "d=write-host; $logo=""; for($l=$first;$l -le $last;$l++){ $logo += " " * 24 + (Get-Item env:$l).Value + "`n" };"
set "o=$bling=$logo.split(":"); foreach ($i in $bling) { $fc="Cyan"; $bc="Black";"
set "t=if($i.Contains(".")){$fc="Red"}; if($i.Contains(",")){$fc="DarkRed"}; if($i.Contains("Bling")){$fc="Black";$bc="Cyan"};"
set "a=$i=$i.replace(".","#").replace(",","``"); write-host $i -BackgroundColor $bc -ForegroundColor $fc -NoNewLine };"
set "ps_dota=%d:"=\"%%o:"=\"%%t:"=\"%%a:"=\"%"
powershell -c "$first=322; $last=356; %ps_dota%" &rem comment this line to skip the awesome ascii art logo.. but why would you?
endlocal

:: Parse Script options
for %%o in (@dialog @timers @refresh) do call set "%%o=%%%%o:0=%%"
if defined @dialog set "@verbose=0"
if defined @timers ( set "@time=%TIME: =0%" &set "TIMER=call :timer" ) else set "TIMER=call :noop"
if "%MOD_DIR::=%"=="%MOD_DIR%" set "MOD_DIR=%~dp0%MOD_DIR%"
mkdir "%MOD_DIR%" >nul 2>nul &pushd "%MOD_DIR%"

:: Check DOTA, tools and environment
call :set_dota
if not exist "%~dp0tools\*" call :end ! \tools subfolder missing, did you unpack whole `dota_no_bling_sdk.zip` file?
if /i "%PROCESSOR_ARCHITECTURE%"=="x86" if not defined PROCESSOR_ARCHITEW6432 call :end ! This script requires Windows x64 !
set "compiler="%DOTA%\game\bin\win64\resourcecompiler.exe""                              ||:i Valve does not provide a 32bit version
if not exist %compiler% copy /y "%~dp0tools\Steam\dota 2 beta\game\bin\win64\resourcecompiler.exe" "%DOTA%\game\bin\win64\" >nul
if not exist %compiler% call :end ! "%DOTA%\game\bin\win64\resourcecompiler.exe" missing !
set "decompiler="%~dp0tools\ValveResourceFormat\Decompiler.exe""
if not exist %decompiler% call :end ! tools\ValveResourceFormat missing!
set "vpk="%~dp0tools\Steam\SourceFilmmaker\game\bin\vpk.exe""
if not exist %vpk% call :end ! tools\Steam\SourceFilmmaker\bin\vpk.exe missing!
set "nodejs="%~dp0tools\Node.js\node.exe""
if exist %nodejs% for /f "delims=" %%i in ('%nodejs% -e process.execArgv[0] -p') do if not "%%i"=="-e" set "nodejs="
if not exist %nodejs% set "nodejs="
if defined nodejs ( set "js_engine=%nodejs% "%~dpn0.js"" ) else set "js_engine=cscript //E:JScript //nologo "%~dpn0.js""
set "WORKSHOP=" &set "SRC_CONTENT=%DOTA%\content\dota"
if exist "%STEAMAPPS%\workshop\appworkshop_570.acf" if exist "%DOTA%\game\bin\win64\resourceinfo.exe" set "WORKSHOP=installed"
if not exist "%DOTA%\content\dota\particles\dev\*.vpcf" set "WORKSHOP="

:: Check for new DOTA patch (quick and dirty, useful for testing options without lenghty recompiling the particles each time)
for /f usebackq^ delims^=^"^ tokens^=4 %%a in (`findstr LastUpdated "%STEAMAPPS%\appmanifest_570.acf"`) do set /a "UPDATED=%%a+0"
pushd "%MOD_DIR%" &set "NEWPATCH=" &set /a "LASTUPDATED=0" &if exist last_updated.bat call last_updated.bat
if %UPDATED% GTR %LASTUPDATED% set "NEWPATCH=yes" &set "@refresh=1" &echo @set /a "LASTUPDATED=%UPDATED%" ^&exit /b>last_updated.bat  

:: Check for existing compiled mod categories 
if not exist "%MOD_DIR%\out" set /a "MOD_COUNT=0"
if exist "%MOD_DIR%\out" pushd "%MOD_DIR%\out" &for /f %%a in ('dir /a:d') do set /a "MOD_COUNT=%%a-2" >nul 2>nul
if %MOD_COUNT% LSS 1 set "@refresh=1" &rem there must be a category folder under MOD\out
set /a "MOD_COUNT=0" &for /f %%a in ('dir /a:-d /b /s ^|findstr vpcf_c') do set /a "MOD_COUNT+=1"
if %MOD_COUNT% LSS 1 set "@refresh=1" &rem there must be compiled particle files under MOD\out

:: Check DOTA launch options
if defined STEAMDATA pushd "%STEAMDATA%\config" &if exist localconfig.vdf (
 for /f "delims=" %%a in ('cscript //E:JScript //nologo "%~dpn0.js" DOTA_LaunchOptions localconfig.vdf "" 0') do set "LOPTIONS=%%a"
 for /f %%a in ('cscript //E:JScript //nologo "%~dpn0.js" DOTA_LaunchOptions localconfig.vdf "-LV" 1') do set "LVCHECK=%%a"
)

:: Parse gui dialog choices - rather complicated back & forth define - undefine, but it gets the job done!
set "all_choices=-LowViolence Events Spells Hats Heroes! Wards Couriers Towers Soundboard @verbose" &set "@choices="
if not defined @refresh set "all_choices=%all_choices% @refresh" &rem insert @refresh option 
for %%o in (%all_choices%) do call set "%%o=%%%%o:0=%%" &rem if any option is equal to 0, undefine it for easier script usage
for %%o in (%all_choices%) do if defined %%o (if defined @choices ( call set "@choices=%%@choices%%,%%o" ) else set "@choices=%%o")
if defined @dialog call :choices 322 444 "No-Bling" "%all_choices: =,%" "%@choices%" ||:i width height title all_choices def_choices
if defined CHOICES ( set "MOD_CHOICES=%CHOICES%" ) else set "MOD_CHOICES=%@choices%"
for %%o in (%all_choices%) do set "%%o=" &rem undefine all initial choices
for %%o in (%MOD_CHOICES%) do set "%%o=1" &rem then redefine selected ones to 1
:: Clear script-only options
call :unselect @verbose MOD_CHOICES &call :unselect @refresh MOD_CHOICES
set "CHOICES=%MOD_CHOICES%" &reg add "HKCU\Environment" /v "No-Bling choices" /t REG_SZ /d "%MOD_CHOICES%" /f >nul 2>nul

:: Increase window buffer powershell snippet                    this restores scrollbar after mode command in :set_window removed it
powershell -c "$H=$host.UI.RawUI; $B=$H.BufferSize; $W=$B.Width; $B.Height=9999; $H.BufferSize=$B;" >nul 2>nul

:: Print configuration
%LABEL% " No-Bling DOTA mod configuration "
echo  Script options = @dialog:%@dialog%  @timers:%@timers%  @verbose:%@verbose%  @refresh:%@refresh%
echo  Mod choices    = %MOD_CHOICES%
echo  Mod directory  = %MOD_DIR%
echo  Mod output     = %DOTA%\game\dota_lv
echo  Source content = %SRC_CONTENT%
echo  User profile   = %STEAMDATA%
echo  Launch options = %LOPTIONS%
echo  Workshop Tools = %WORKSHOP%
echo  Needs refresh? = %NEWPATCH%

:: Prepare
%LABEL% " Preparing MOD directory "
%TIMER%
set ".=dota_lv"
if defined @verbose set ".=%.% log"
if defined @refresh set ".=%.% src out scripts"
mkdir "%MOD_DIR%" >nul 2>nul &pushd "%MOD_DIR%" &for %%i in (%.%) do ( del /f/s/q "%%~i" &rmdir /s/q "%%~i" ) >nul 2>nul
if defined @verbose mkdir "log" >nul 2>nul
%TIMER%

:: Skip lengthy compile process if only @verbose was selected #1
if defined @verbose if not defined CHOICES echo. & %INFO%  No src mod choices, just generating MOD\log  &goto :skip_lowviolence

:: Skip lengthy compile process and only do it if there is a new patch or requested by @refresh option
if not defined @refresh echo. & %INFO%  No new patch - skipping compile step, select @refresh option to rebuild the mod..
if not defined @refresh goto :skip_compiling 

:: Update source content
if defined WORKSHOP goto :skip_update_content
if not defined CHOICES goto :skip_update_content
if exist "%SRC_CONTENT%_tmp\particles\dev\*.vpcf" del /f/s/q "%SRC_CONTENT%" >nul 2>nul &rmdir /s/q "%SRC_CONTENT%" >nul 2>nul
if exist "%SRC_CONTENT%_tmp\particles\dev\*.vpcf" ren "%SRC_CONTENT%_tmp" dota >nul 2>nul
if not exist "%SRC_CONTENT%\particles\dev\*.vpcf" del /f /q "%DOTA%\game\dota\pak01_dir.vpk.manifest.txt" >nul 2>nul
if exist "%SRC_CONTENT%\particles\dev\*.vpcf" if not defined NEWPATCH goto :skip_update_content
%LABEL% " Workshop Tools DLC content not found, decompiling pak01_dir.vpk directly "
echo Task can take a few minutes...
%TIMER%
%decompiler% -i "%DOTA%\game\dota\pak01_dir.vpk" -o "%DOTA%\content\dota" --vpk_cache -d -e vpcf_c >nul 2>nul
call :clearline 1
set "newmanifest=%DOTA%\game\dota\pak01_dir.vpk.manifest.txt" &set "oldmanifest=%MOD_DIR%\pak01_dir.vpk.manifest.txt"
set "OUTDATED=" &if not exist "%newmanifest%" set "OUTDATED=yes" &copy /y "%newmanifest%" "%oldmanifest%" >nul 2>nul
if not defined OUTDATED echo n|COMP "%newmanifest%" "%oldmanifest%" >nul 2>nul
if not defined OUTDATED if ERRORLEVEL 1 ( set "OUTDATED=yes" &set "@refresh=1" ) else set "OUTDATED="  
copy /y "%newmanifest%" "%oldmanifest%" >nul 2>nul
%TIMER%
if not exist "%SRC_CONTENT%\particles\dev\*.vpcf" call :end ! Could not decompile particles - better install Workshop Tools DLC!
:skip_update_content
:: Workaround for Jugg arcana '.vpcf.vpcf' typo? in items_game.txt
pushd "%DOTA%\content\dota\particles\econ\items\juggernaut\bladekeeper_omnislash"
set ".=_dc_juggernaut_omni_slash_tgt.vpcf"
if not exist %.%.vpcf copy /y %.% %.%.vpcf >nul 2>nul &popd

:: Pure batch method for -LowViolence removal - much faster than integrated JS engine method but arguably less reliable
if not defined CHOICES goto :skip_lowviolence
%LABEL% " Disabling default -lv 'green alien blood' particles "
echo Task can take a minute... &rem on sequential runs it's usually cashed and only takes 5-10 seconds
%TIMER%
set "lv_root=particles" &set "LV_FILTER=m_hLowViolenceDef = resource:"
mkdir "%MOD_DIR%\src\-LowViolence" >nul 2>nul &pushd "%MOD_DIR%\src\-LowViolence"
for /f delims^=^ eol^= %%a in ('pushd "%SRC_CONTENT%" ^&findstr /l /s /m /off /c:"%LV_FILTER%" "%VPK_ROOT%\*"') do (
  mkdir "%%~dpa" >nul 2>nul &findstr /l /v /off /c:"%LV_FILTER%" "%SRC_CONTENT%\%%a" > "%%~dpnxa"
)
call :clearline 1  &pushd "%MOD_DIR%\src\-LowViolence" &set ".=%MOD_DIR%\log\LowViolence.txt"
if not defined @verbose call :unselect -LowViolence MOD_CHOICES &%TIMER% &goto :skip_lowviolence
echo %.% &cd.>"%.%" &for /f delims^=^ eol^= %%a in ('dir /a:-d /b /s') do set "__fa=%%~fa" &call echo/%%__fa:%__CD__%=%%>>"%.%"
call :unselect -LowViolence MOD_CHOICES
%TIMER%
:skip_lowviolence rem comment this whole code block to use the integrated JS engine reliable but slower method instead

%LABEL% " Extracting items_game.txt from game\dota\pak01_dir.vpk "
if defined @verbose ( set ".= " ) else set ".=>nul 2>nul"
%TIMER%
%decompiler% -i "%DOTA%\game\dota\pak01_dir.vpk" -o "%MOD_DIR%" -d -e txt -f "scripts/items/items_game.txt" %.%
%TIMER%

%LABEL% " Processing items_game.txt using JS engine "
pushd "%MOD_DIR%"
%TIMER%
%js_engine% No_Bling "%SRC_CONTENT%" "%MOD_DIR%" "%VPK_ROOT%" "%MOD_CHOICES%" "%@verbose%" "%@timers%" >DEBUG.TXT
%TIMER%
:: Verify items_game.txt VDF parser
if defined @verbose pushd "%MOD_DIR%\scripts\items" &echo. &echo n|COMP items_game.txt items_game_out.txt 2>NUL
echo.
%ECHOM% ": f0 ' G ';: c0 ' L ';: e0 ' A ';: a0 ' N ';: d0 ' C ';: b0 ' E ';: 2f ' V ';: 4f ' A ';: 6f ' L ';: 5f ' U ';: 9f. ' E '"

:: Skip compiling if only @verbose was selected #2
timeout /t 5 >nul 2>nul &call :clearline 2 &if not defined CHOICES goto :done
pushd "%MOD_DIR%\src" &for /f %%a in ('dir /a:d') do set /a "MOD_COUNT=%%a-2" >nul 2>nul
if %MOD_COUNT% LSS 1 goto :done &rem there must be a category folder under MOD\src
:: Sort Mod list
pushd "%MOD_DIR%\src" &if defined @verbose if exist No-Bling*.* for /f %%a in ('dir /A:-D /B /O:D No-Bli*.*') do sort "%%a" /o "%%a"

:: Resource compiling - since it's a lengthy process, only do it if there is a new patch or requested by @refresh option
if not defined @refresh goto :skip_compiling 
echo. &call :color 70 " Resource compiling MOD\src " &call :color c0. " Don't interrupt! " &timeout /t 5 >nul 2>nul
%TIMER%
if defined @verbose ( set ".= " ) else set ".=>nul 2>nul"
if exist "%DOTA%\content\dota" ren "%DOTA%\content\dota" "dota_tmp"
if exist "%DOTA%\content\dota" call :end ! ERROR %DOTA%\content\dota in use - close the folder!
mkdir "%MOD_DIR%\out" >nul 2>nul
pushd "%MOD_DIR%\src"
for /f %%s in ('dir /a:d /b') do (
  pushd "%%s"
  for /f %%a in ('dir /a:d /b') do (
    if exist "%DOTA%\game\dota\%%a" ren "%DOTA%\game\dota\%%a" "%%a_tmp" >nul 2>nul
    xcopy /E/C/I/Q/H/R/K/Y/Z "%%a\*.*" "%DOTA%\content\dota\%%a\" >nul 2>nul
    echo. %.%
    %compiler% -r -nop4 -game "%DOTA%\game\dota" -fshallow "%DOTA%\content\dota\%%a\*.*" %.%
    call :color 03 " %%s "
    xcopy /E/C/I/Q/H/R/K/Y/Z "%DOTA%\game\dota\%%a\*.*" "%MOD_DIR%\out\%%s\%%a\"
    del /f/s/q "%DOTA%\game\dota\%%a" >nul 2>nul &rmdir /s/q "%DOTA%\game\dota\%%a" >nul 2>nul
    if exist "%DOTA%\game\dota\%%a_tmp" ren "%DOTA%\game\dota\%%a_tmp" "%%a" >nul 2>nul
  )
  popd
  del /f/s/q "%DOTA%\content\dota" >nul 2>nul &rmdir /s/q "%DOTA%\content\dota" >nul 2>nul
)
if exist "%DOTA%\content\dota_tmp" ren "%DOTA%\content\dota_tmp" "dota" >nul 2>nul
%TIMER%
:skip_compiling

:: Create mod vpk
%LABEL% " ValvePak-ing MOD\out "
%TIMER%
pushd "%MOD_DIR%" &mkdir "%MOD_DIR%\dota_lv\pak01_dir" >nul 2>nul
del /f/s/q "%MOD_DIR%\dota_lv\pak01_dir" >nul 2>nul &rmdir /s/q "%MOD_DIR%\dota_lv\pak01_dir" >nul 2>nul
for %%a in (%CHOICES:,= %) do if exist "out\%%a" call :color 0e " %%a " &xcopy /E/C/I/Q/H/R/K/Y/Z "out\%%a\*.*" "dota_lv\pak01_dir\"
::Bonus Soundboard
if not defined Soundboard goto :skip_soundboard
%decompiler% -i "%DOTA%\game\dota\pak01_dir.vpk" -o "%MOD_DIR%\scripts" -e vsnd_c -f "sounds/test/null.vsnd_c" >nul 2>nul
set "me=all_dead ay_ay_ay bozhe_ti_posmotri brutal charge crash_burn cricket crybaby disastah drum_roll ehto_g_g eto_prosto_netchto"  
set "mes=frog headshake jia_you patience po_liang_lu rimshot sad_bone sproing tian_huo wan_bu_liao_la wow zhil_do_konsta" 
set "memes=%me% %mes% zou_hao_bu_song"
mkdir "%MOD_DIR%\dota_lv\pak01_dir\sounds\misc\soundboard" >nul 2>nul &set .="%MOD_DIR%\scripts\sounds\test\null.vsnd_c" 
pushd "%MOD_DIR%\dota_lv\pak01_dir\sounds\misc\soundboard" &for %%b in (%memes%) do copy /y %.% %%b.vsnd_c >nul 2>nul
copy /y %.% "%MOD_DIR%\dota_lv\pak01_dir\sounds\misc\crowd_lv_01.vsnd_c" >nul 2>nul
copy /y %.% "%MOD_DIR%\dota_lv\pak01_dir\sounds\misc\crowd_lv_02.vsnd_c" >nul 2>nul
:skip_soundboard
pushd "%MOD_DIR%\dota_lv" &set .="%MOD_DIR%\dota_lv\pak01_dir"
for /f %%a in ('dir /a:d /b') do %vpk% %.% &echo  %%~na.vpk done
%TIMER%

:: Export builds
set "BUILDS_FOLDER=%MOD_DIR%\BUILDS\%CHOICES:,=-%"
pushd "%MOD_DIR%" &mkdir "%BUILDS_FOLDER%" >nul 2>nul
:: Generate readme
set .="%MOD_DIR%\dota_lv\No-Bling DOTA mod readme.txt"
echo  No-Bling DOTA mod v%version% choices: %CHOICES% >%.%  
echo ------------------- >>%.%
echo We all know where we are headed looking at the Immortals spam in the last two years... >>%.%  
echo. >>%.%  
echo  About >>%.%  
echo ------- >>%.%
echo Simply a competent alternative to Settings -- Video -- Effects Quality with the main focus on GlanceValue. >>%.%  
echo No-Bling DOTA mod is economy-friendly, gracefully disabling particle spam while leaving hats model untouched. >>%.%  
echo Might say it even helps differentiate great artistic work, shadowed by the particle effects galore Valve slaps on top. >>%.%  
echo. >>%.%  
echo  How to manually install the zip / vpk releases? >>%.%  
echo ------------------------------------------------- >>%.%
echo 1. Browse with a filemanager to: >>%.%  
echo   %DOTA%\game\ >>%.%  
echo 2. Delete directory (or just it's content): >>%.%  
echo   dota_lv >>%.%  
echo 3. Unpack release zip file / copy pak01_dir.vpk there >>%.%  
echo 4. Verify that this file exists: >>%.%  
echo   %DOTA%\game\dota_lv\pak01_dir.vpk >>%.%  
echo 5. Add Dota 2 LAUNCH OPTIONS: >>%.%  
echo   -LV >>%.%  
echo 6. Profit! >>%.%  
echo. >>%.%  
echo  pak01_dir.vpk file list >>%.%
echo ------------------------- >>%.%
pushd "%MOD_DIR%\dota_lv\pak01_dir"
for /f delims^=^ eol^= %%a in ('dir /a:-d /b /s') do set "__fa=%%~fa" &call echo/%%__fa:%__CD__%=%% >>%.%
copy /y "%MOD_DIR%\dota_lv\No-Bling DOTA mod readme.txt" "%BUILDS_FOLDER%\" >nul 2>nul
copy /y "%MOD_DIR%\dota_lv\pak01_dir.vpk" "%BUILDS_FOLDER%\" >nul 2>nul
pushd "%MOD_DIR%\dota_lv"
for /f %%a in ('dir /a:d /b') do del /f/s/q %%a\*.* >nul 2>nul &rmdir /s/q %%a >nul 2>nul 

:: Install mod vpk
%LABEL% " Installing No-Bling DOTA mod: %CHOICES% "
echo  Cancel now if you prefer manual install:
set "_msg_=: __ ' COPY ';: _a MOD\dota_lv\pak01_dir.vpk;: __ ' to ';: _d 'dota 2 beta\game\dota_lv';: __ ' and ADD launch option ';"
%ECHOM% "%_msg_%; : _b. '-LV';"
timeout /t 10 &call :clearline 2
mkdir "%DOTA%\game\dota_lv" >nul 2>nul
copy /y "%MOD_DIR%\dota_lv\*.vpk" "%DOTA%\game\dota_lv\" >nul 2>nul
if defined LVCHECK goto :done [ -LV option already present ]
if not defined STEAMDATA goto :done 
%WARN%  DOTA and Steam will be closed automatically! &timeout /t 10 &call :clearline 3
taskkill /f /im dota2.exe /im steam.exe /t >nul 2>nul
pushd "%STEAMDATA%\config" &if not exist localconfig.vdf.bak copy /y localconfig.vdf localconfig.vdf.bak >nul
%js_engine% DOTA_LaunchOptions "localconfig.vdf" "-LV"
rem start "w" steam://rungameid/570 &rem (re)launch DOTA

:done
call :end  :Done!
goto :eof
:: end of BAT_Main

::----------------------------------------------------------------------------------------------------------------------------------
:"BAT_Utils"
::----------------------------------------------------------------------------------------------------------------------------------
:set_dota outputs %STEAMPATH% %STEAMAPPS% %STEAMDATA% %DOTA%                       ||:i AveYo:" Override detection below if needed "
set "STEAMPATH=C:\Steam" &set "DOTA=C:\Games\steamapps\common\dota 2 beta"
if not exist "%STEAMPATH%\Steam.exe" call :reg_query "HKCU\SOFTWARE\Valve\Steam" "SteamPath" STEAMPATH
if not exist "%STEAMPATH%\Steam.exe" call :end ! Cannot find SteamPath in registry
if exist "%DOTA%\game\dota\maps\dota.vpk" set "STEAMAPPS=%DOTA:\common\dota 2 beta=%" &goto :eof
for %%s in ("%STEAMPATH%") do set "STEAMPATH=%%~dpns" &set "libfilter=LibraryFolders { TimeNextStatsReport ContentStatsID }"
if not exist "%STEAMPATH%\SteamApps\libraryfolders.vdf" call :end ! Cannot find "%STEAMPATH%\SteamApps\libraryfolders.vdf"
for /f usebackq^ delims^=^"^ tokens^=4 %%s in (`findstr /v "%libfilter%" "%STEAMPATH%\SteamApps\libraryfolders.vdf"`) do (
if exist "%%s\steamapps\appmanifest_570.acf" if exist "%%s\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" set "libfs=%%s" )
set "STEAMAPPS=%STEAMPATH%\steamapps" &if defined libfs set "STEAMAPPS=%libfs:\\=\%\steamapps"
if not exist "%STEAMAPPS%\common\dota 2 beta\game\dota\maps\dota.vpk" call :end ! Cannot find "%STEAMAPPS%\common\dota 2 beta"
set "DOTA=%STEAMAPPS%\common\dota 2 beta" &pushd "%STEAMAPPS%\common\dota 2 beta\game\dota"
call :reg_query "HKCU\SOFTWARE\Valve\Steam\ActiveProcess" "ActiveUser" STEAMUSER &set /a "STEAMID=STEAMUSER" >nul 2>nul
if defined STEAMID if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
if not defined STEAMDATA for /f delims^=^ eol^= %%b in ('dir /a:-d /b /o:d /t:w cache_*.soc 2^>nul') do set "usercache=%%~nb"
if not defined STEAMDATA if defined usercache set "STEAMDATA=%steampath%\userdata\%usercache:cache_=%"
if defined STEAMDATA if not exist "%STEAMDATA%\config\localconfig.vdf" set "STEAMDATA=" &rem call :end ! Cannot find STEAMDATA
goto :eof

::----------------------------------------------------------------------------------------------------------------------------------
:"BAT_Core"
::----------------------------------------------------------------------------------------------------------------------------------
:set_window %1:Bg[hex] %2:Fg[hex] %3:Cols[int] %4:Lines[int]     " also initiates text macros used by :color and :mcolor functions "
set "_bg=%~1"&set "_fg=%~2" &set "_cols=%~3" &call color %~1%~2 &call mode %~3,%~4 & <nul set/p "=-">"%TEMP%\`"
for /f "skip=4 tokens=2 delims=:" %%a in ('mode con') do for %%c in (%%a) do if not defined _cols set "_cols=%%c"
for /f %%b in ('"prompt $H &for %%h in (1) do rem"') do set "`BS=%%b" &for /f %%c in ('copy /z "%~dpf0" nul') do set "`CR=%%c"
for /f %%n in ('cscript //E:JScript //nologo "%~dpn0.js" OutChars "160"') do call set "`NBSB=%%n"
set "`B_B=%`BS% %`BS%" &set "`LINE=%`CR%" &for /l %%i in (1,1,%_cols%) do call set "`LINE=%`BS% %`BS%%%`LINE%%"
set "ECHON=call :echop" set "ECHOC=call :color" &set "ECHOM=call :mcolor" &set "LABEL=echo. &call :color 70. "
set "INFO=call :color b0 " INFO " &echo" &set "WARN=call :color e0 " WARN " &echo" &set "ERROR=call :color cf " ERROR " &echo"
set "`ZZ=-%`B_B%\..\%`B_B%%`B_B%%`B_B%"&set "`YY=-%`B_B%/..\%`B_B%%`B_B%%`B_B%"&set "`XX=%`B_B%%`B_B%%`B_B%%`B_B%%`B_B%%`B_B%%`B_B%"
:: multicolor text powershell snippet                                                                           cached to %ps_color%
set "c=$c="Black,DarkBlue,DarkGreen,DarkCyan,DarkRed,DarkMagenta,DarkYellow,Gray,DarkGray,Blue,Green,Cyan,Red,Magenta,Yellow,White""
set "o=;$cn=$c.split(",");$h=$Host.UI.RawUI;function :([String]$fbn,[String]$txt){$b=$fbn[0];$f=$fbn[1];$n=$fbn[2]; if($b -eq "_"){"
set "l=$bc=$h.BackgroundColor}else{$bc=$cn[([int[]]"0x$b")]}; if($f -eq "_"){$fc=$h.ForegroundColor}else{$fc=$cn[([int[]]"0x$f")]};"
set "r=write-host $txt -BackgroundColor $bc -ForegroundColor $fc -NoNewLine;if($n -eq "."){write-host ([CHAR]160)}}"
call set "ps_color=%c:"=\"%%o:"=\"%%l:"=\"%%r:"=\"%"
goto :eof                                        ||:i AveYo - Short macros:" %WARN% %ERROR% %LABEL% %INFO% %ECHON% %ECHOC% %ECHOM% "

:color %1:BgFg.[one or both of hexpair can be _ as defcolor, optional . use newline] %2:text["text with spaces"]
setlocal enableDelayedExpansion &set "bf=%~1" &set "tx=%~2" &set "tx=-%`BS%!tx:\=%`ZZ%!" &set "tx=!tx:/=%`YY%!" &set "tx=!tx:"=\"!"
set "bf=!bf: =!" &set "bc=!bf:~0,1!" &set "fc=!bf:~1,1!" &set "nl=!bf:~2,1!" &set "bc=!bc:_=%_bg%!" &set "fc=!fc:_=%_fg%!"
pushd "%TEMP%" &findstr /p /r /a:!bc!!fc! "^^-" "!tx!\..\`" nul & <nul set/p "=%`XX%" &popd &if defined nl echo/%`NBSB%
endlocal &goto :eof                      ||:i AveYo - Usage: call :color fc Hello & call :color _c " fancy " & call :color cf. World
:mcolor %1:" : BgFg.[one or both of hexpair can be _ as defcolor, optional . use newline] text['text with spaces'] ; "    chain cmds
:: this method draws many lines with different colors in one go faster, but repeated single calls are way slower than using :colors
powershell -c " %ps_color%; %~1 " &goto :eof           ||:i AveYo - Usage: call :mcolor " : fc Hello; : _c ' fancy '; : cf. World; "
:echop %1:text[no newline]
<nul set/p "=`%`BS%%*" &goto :eof                                      ||:i AveYo - Usage:" call :echop Hello  & call :echop World "
:clearline %1:Number[how many lines above to delete - macro does not work as intended under Windows 7]
setlocal enableDelayedExpansion &( for /l %%i in (1,1,%~1) do <nul set/p "=!`LINE!" ) &endlocal &goto :eof
:end %1:Message[Delayed termination with status message - prefix with ! to signal failure]
echo. &if defined @dialog ( set "end_=echo. &pause" ) else if "%~1"=="!" ( set "end_=timeout /t 32" ) else set "end_=timeout /t 20"
( if defined @time call :timer "%@time%" &call :timer ) &if "%~1"=="!" ( %ERROR%  %* &%end_% &exit ) else %INFO%  %* &%end_% &exit
:noop [does_nothing]
goto :eof

:reg_query %1:KeyName %2:ValueName %3:OutputVariable %4:other_options[example: "/t REG_DWORD"]
setlocal &for /f "skip=2 delims=" %%s in ('reg query "%~1" /v "%~2" /z 2^>nul') do set "rq=%%s" &call set "rv=%%rq:*)    =%%"
endlocal &call set "%~3=%rv%" &goto :eof                         ||:i AveYo - Usage:" call :reg_query "HKCU\MyKey" "MyValue" MyVar "

:timer %1:input[optional] %2:nodisplay[optional]
if not defined timer_set ( if not "%~1"=="" ( call set "timer_set=%~1" ) else set "timer_set=%TIME: =0%" ) &goto :eof
( if not "%~1"=="" ( call set "timer_end=%~1" ) else set "timer_end=%TIME: =0%" ) &setlocal EnableDelayedExpansion
for /f "tokens=1-6 delims=0123456789" %%i in ("%timer_end%%timer_set%") do set "CE=%%i" &set "DE=%%k" &set "CS=%%l" &set "DS=%%n"
set "TE=!timer_end:%DE%=%%100)*100+1!" &set "TS=!timer_set:%DS%=%%100)*100+1!"
set/A "T=((((10!TE:%CE%=%%100)*60+1!%%100)-((((10!TS:%CS%=%%100)*60+1!%%100)" &set/A "T=!T:-=8640000-!"
set/A "cc=T%%100+100,T/=100,ss=T%%60+100,T/=60,mm=T%%60+100,hh=T/60+100"
set "value=!hh:~1!%CE%!mm:~1!%CE%!ss:~1!%DE%!cc:~1!" &if "%~2"=="" echo/!value!
endlocal &set "timer_end=%value%" &set "timer_set=" &goto :eof       ||:i AveYo:" Result printed second-call, saved to %timer_end% "

:unselect %1:choice %2:from variable containing a list of choices separated by comma
if not defined %~2 goto :eof
setlocal &call set "ops=%%%~2%%" &call set "ops=%%ops:,%~1=%%" &call set "ops=%%ops:%~1,=%%" &call set "ops=%%ops:%~1=%%"
endlocal &call set "%~2=%ops%" &goto :eof

:choices %1:width %2:height %3:title %4:all_choices %5:def_choices     
setlocal &rem example:"  call :choices 322 96 "Test" "opt1 opt2 opt3" "opt2 opt3"  ": all opt shown, but just opt2 and opt3 selected
:: gui dialog choices powershell snippet                                                          cached temporarily to %ps_choices%
set "z=[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms"); $f=New-Object System.Windows.Forms.Form;"
set "y=[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing"); $fminsize=New-Object System.Drawing.Size(320,32);"
set "x=$r=(Get-ItemProperty $p).$n; if($r -ne $null){$opt=$r.split(",")}else{$opt=$def.split(",")}; function CLK(){ $v=@();"
set "w=;foreach($x in $cb){if($x.Checked){$v+=$x.Text}}; New-ItemProperty -Path $p -Name $n -Value $($v -join ",") -Force };"
set "v=$BCLK=@(0,{$f.close()},{foreach($z in $cb){$z.Checked=$false;if($def.split(",") -contains $z.Text){$z.Checked=$true}};CLK});"
set "u=$i=1;$cb=foreach($l in $all.split(",")){ $c=New-Object System.Windows.Forms.CheckBox; $c.Name="c$i"; $c.AutoSize=$true;" 
set "t=;$c.Text=$l; $c.Location=New-Object System.Drawing.Point(($pad*3),(16+(($i-1)*24))); $c.BackColor="Transparent";"
set "s=;$c.add_Click({CLK}); $f.Controls.Add($c); $c; $i++; }; foreach($s in $cb){if($opt -contains $s.Text){$s.Checked=$true}};"
set "r=$j=1;$bn=@("OK","Reset"); foreach($t in $bn){ $b=New-Object System.Windows.Forms.Button; $b.Name="b$j";"
set "q=;$b.Text=$t; $b.Location=New-Object System.Drawing.Point(($pad*2+($j-1)*$pad*3),(32+(($i-1)*24)));"
set "p=;$b.add_Click($BCLK[$j]); $f.Controls.Add($b); $j++; };"
set "o=$f.Text=$n; $f.BackColor="DarkRed"; $f.Forecolor="White"; $f.FormBorderStyle="Fixed3D"; $f.StartPosition="CenterScreen";"
set "n=$f.MaximizeBox=$false; $f.MinimumSize=$fminsize; $f.AutoSize=$true; $f.AutoSizeMode='GrowAndShrink';"
set "m=$f.Add_Shown({$f.Activate()}); [void]$f.ShowDialog();"
set "ps_choices=%z:"=\"%%y:"=\"%%x:"=\"%%w:"=\"%%v:"=\"%%u:"=\"%%t:"=\"%%s:"=\"%%r:"=\"%%q:"=\"%%p:"=\"%%o:"=\"%%n:"=\"%%m:"=\"%"
powershell -c "$n='%~3 choices'; $all='%~4'; $def='%~5'; $p='HKCU:\Environment'; $pad=32; %ps_choices%" &rem >nul 2>nul
call :reg_query "HKCU\Environment" "%~3 choices" CHOICES
endlocal &set "CHOICES=%CHOICES%" &goto :eof                  ||:i AveYo:" GUI dialog with autosize checkboxes - outputs %CHOICES% "
:: end of BAT_Core
goto="init" /* %~nx0
:: v2.0rc2 - finally updated after 7.07 - way faster, new options, detailed instructions, auto-install method for Steam language
::----------------------------------------------------------------------------------------------------------------------------------
:main No-Bling DOTA :G :l :a :n :c :e :V :a :l :u :e restoration mod builder                                      edited in SynWrite
::----------------------------------------------------------------------------------------------------------------------------------
:: Mod builder gui choices - no need to edit defaults here, script shows a graphical dialog for easier selection
set "Abilities=1"                      ||   1 = penguin Frostbite and stuff like that..
set "Hats=1"                           ||   1 = cosmetic particles spam - slowly turning into TF2..                              LOW
set "Couriers=1"                       ||   1 = couriers particles are fine.. until a dumber abuses gems on hats
set "Wards=1"                          ||   1 = only a few of them make the ward and the sentry item too similar
set "Seasonal=1"                       ||   1 = the International 7 custom tp, blink etc.

set "Heroes=1"                         ||   1 = default hero particles, helps potato pc but glancevalue can suffer               MED

set "Tweaks=1"                         ||   1 = extra potato pc optimizations                                                   HIGH

rem set "Towers=0"                     ||   1 = just the tower particle effects, models remain unchanged                     EXPIRED
rem set "Soundboard=0"                 ||   1 = silence the annoying chatwheel sounds - temporarily featured                 EXPIRED
rem set "-LowViolence=0"               ||   1 = undo -lv launch option turning all blood into alien green                   RIP 7.07
::----------------------------------------------------------------------------------------------------------------------------------
:: Script options - not available in gui so set them here if needed
set "@refresh=0"                       ||   1 = always recompile mod instead of reusing cached files,  0 = just when new patch found
set "@verbose=0"                       ||   1 = show extra details; log detailed per-hero item lists,  0 = skip detailed item lists
set "@dialog=1"                        ||   1 = show choices dialog,                                   0 = no dialog - use above
set "@autoclose=1"                     ||   1 = auto-install kills Steam and Dota,                     0 = can't add launch options!
set "@timers=1"                        ||   1 = total and per tasks accurate timers,                   0 = no reason to disable them
rem set "MOD_OUTPUT=%~dp0"             || rem = current batch file directory,
rem set "MOD_LANGUAGE=english"         || rem = current Steam language,
rem set "MOD_FILE=pak01_dir.vpk"       || rem = localized versions might use pak02_dir.vpk,
set "all_choices=Abilities,Hats,Couriers,Wards,Seasonal,Heroes,Tweaks"
set "def_choices=Abilities,Hats,Couriers,Wards,Seasonal,Heroes"
set "version=2.0rc2"

title No-Bling DOTA mod builder by AveYo v%version%
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
set "351=,,,:...............................                       .........:,, ,:"
set "352= ,,:...............................:  No-: Bling : DOTA mod  :.........:,,, :"
set "353=,,,,:..............................                       .........:, , :"
set "354= ,,,,,,,,,,,,,,,,,,,,,,,,,:..:,,,:.............................:,,,,:..:,,, :"
set "355=    , ,,, ,,,, , , ,,,,,,,,, ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  ,,,,   :"
set "d=$logo=""; for($l=$first;$l -le $last;$l++){ $logo += " " * 24 + (Get-Item env:$l).Value + "`n" };"
set "o=$bling=$logo.split(":"); foreach ($i in $bling) { $fc="Cyan"; $bc="Black";"
set "t=if($i.Contains(".")){$fc="Red"}; if($i.Contains(",")){$fc="DarkRed"}; if($i.Contains("Bling")){$fc="Black";$bc="Cyan"};"
set "a=$i=$i.replace(".","#").replace(",","``"); write-host $i -BackgroundColor $bc -ForegroundColor $fc -NoNewLine };"
set "ps_dota=%d%%o%%t%%a%"
powershell -c "$first=322; $last=355; %ps_dota:"=\"%"    &rem comment this line to -commit heresy- skip the awesome ascii art logo..
endlocal

:: Parse Script options
for %%o in (@verbose @refresh @dialog @autoclose @timers) do call set "%%o=%%%%o:0=%%"
if defined @timers ( set "@time=%TIME: =0%" & set "TIMER=call :timer" ) else set "TIMER=call :noop"

:: Check DOTA, tools and environment
call :set_steam & call :set_dota & call :set_tools

:: Check for new DOTA patch (quick and dirty, useful for testing options without extracting the particles from vpk each time)
mkdir "%CONTENT%" >nul 2>nul &rem Should be \steamapps\common\dota 2 beta\content\
for /f usebackq^ delims^=^"^ tokens^=4 %%a in (`findstr LastUpdated "%STEAMAPPS%\appmanifest_570.acf"`) do set/a "UPDATED=%%a+0"
pushd "%CONTENT%" & set "NEWPATCH=" & set/a "LASTUPDATED=0" & if exist last_updated.bat call last_updated.bat
echo @set/a "LASTUPDATED=%UPDATED%" ^&exit/b>last_updated.bat & if %UPDATED% GTR %LASTUPDATED% set "NEWPATCH=yes" & set "@refresh=1"

:: Check Steam language = MOD languge - used to auto-install mod after 7.07
if not defined MOD_LANGUAGE call :reg_query "HKCU\SOFTWARE\Valve\Steam" "Language" STEAM_LANGUAGE
if not defined MOD_LANGUAGE if defined STEAM_LANGUAGE set "MOD_LANGUAGE=%STEAM_LANGUAGE%"
if not defined MOD_LANGUAGE set "MOD_LANGUAGE=english"
set "MOD_FOLDER=dota_%MOD_LANGUAGE%" & set "MOD_OPTIONS=-language %MOD_LANGUAGE%"
if /i "%MOD_LANGUAGE%"=="english" set "MOD_OPTIONS=-language english%%,-textlanguage english,+cl_language english"
if /i "%MOD_LANGUAGE%"=="english" set "MOD_FOLDER=dota_english%%"
if not defined MOD_FILE set "MOD_FILE=pak01_dir.vpk"
for %%# in (russian schinese koreana) do if /i "%MOD_LANGUAGE%"=="%%#" set "MOD_FILE=pak02_dir.vpk"
if not exist "%DOTA%\%MOD_FOLDER%\pak01_dir.vpk" set "MOD_FILE=pak01_dir.vpk"

:: Check DOTA launch options
if defined STEAMDATA pushd "%STEAMDATA%\config" & if exist localconfig.vdf (
 for /f "delims=" %%a in ('cscript //E:JScript //nologo "%~dpn0.js" Dota_LOptions localconfig.vdf "_" -read') do set "LOPTIONS=%%a"
)

:: Parse gui dialog choices - rather complicated back & forth define - undefine, but it gets the job done!
set "@choices=" & if defined @dialog if not defined @refresh set "all_choices=%all_choices%,@refresh"    &rem insert @refresh option
set "@choices=" & if defined @dialog if not defined @verbose set "all_choices=%all_choices%,@verbose"    &rem insert @verbose option
for %%o in (%all_choices%) do call set "%%o=%%%%o:0=%%"                     &rem undefine any option equal to 0, easier script usage
for %%o in (%all_choices%) do if defined %%o (if defined @choices ( call set "@choices=%%@choices%%,%%o" ) else set "@choices=%%o")
if defined @dialog call :choices 322 444 "No-Bling" "%all_choices%" "%def_choices%"  &rem width height title all_choices def_choices
if defined @dialog if not defined CHOICES call :end ! No choices selected!
if defined CHOICES ( set "MOD_CHOICES=%CHOICES%" ) else set "MOD_CHOICES=%@choices%"
for %%o in (%all_choices%) do set "%%o="  &rem undefine all initial choices
for %%o in (%MOD_CHOICES%) do set "%%o=1" &rem then redefine selected ones to 1
:: Clear script-only options and export choices to registry
call :unselect @verbose MOD_CHOICES & call :unselect @refresh MOD_CHOICES
set "CHOICES=%MOD_CHOICES%" & reg add "HKCU\Environment" /v "No-Bling choices" /t REG_SZ /d "%MOD_CHOICES%" /f >nul 2>nul

:: Print configuration
%LABEL% " Configuration "
echo  Mod choices    = %MOD_CHOICES%
echo  Mod file       = %DOTA%\%MOD_FOLDER%\%MOD_FILE%
echo  Mod options    = %MOD_OPTIONS%
echo  User profile   = %STEAMDATA%
echo  User options   = %LOPTIONS%
echo  Content        = %CONTENT%\pak01_dir
echo  New patch?     = %NEWPATCH%
echo  Script options = @refresh:%@refresh%  @verbose:%@verbose%  @dialog:%@dialog%  @autoclose:%@autoclose%  @timers:%@timers%
echo.

:: Prepare directories
%WARN%  Preparing directories, please wait..
if not defined MOD_OUTPUT set "MOD_OUTPUT=%~dp0"
if "%MOD_OUTPUT::=%"=="%MOD_OUTPUT%" set "MOD_OUTPUT=%~dp0%MOD_OUTPUT%"
mkdir "%MOD_OUTPUT%\log" >nul 2>nul & pushd "%MOD_OUTPUT%"
set "MOD_OUTPUT=%CD%" & set "BUILDS=%CD%\BUILDS\%CHOICES:,=_%"
mkdir "%BUILDS%" >nul 2>nul
set ".="%CD%\src""
if defined @refresh set ".=%.% "%CONTENT%\pak01_dir""
rem if defined @verbose set ".=%.% "%MOD_OUTPUT%\log""       &rem no need to clear the log folder each time [~2k files ~200 folders]
for %%i in (%.%) do ( del /f/s/q "%%~i" & rmdir /s/q "%%~i" & mkdir "%%~i" ) >nul 2>nul
call :clearline 2

:: Skip lengthy compile process if only @verbose was selected #1
if defined @verbose if not defined CHOICES echo. & %INFO%  No mod choices selected, just generating logs & goto :skip_update_content

:: Skip lengthy compile process and only do it if there is a new patch or requested by @refresh option
if not defined @refresh echo. & %INFO%  No new patch - skipping update content step. Select @refresh option to force update..
if not defined @refresh goto :skip_update_content

:: Update source content
if not exist "%CONTENT%\pak01_dir\particles\dev\*.vpcf_c" del /f /q "%DOTA%\dota\pak01_dir.vpk.manifest.txt" >nul 2>nul
if exist "%CONTENT%\pak01_dir\particles\dev\*.vpcf_c" if not defined NEWPATCH goto :skip_update_content
call :mcolor 70 " Updating Content from dota\pak01_dir.vpk directly ... " c0. " ETA: 1-3m "
%TIMER%
%decompiler% -i "%DOTA%\dota\pak01_dir.vpk" -o "%CONTENT%\pak01_dir" --vpk_cache -e vpcf_c >nul 2>nul
set "newmanifest=%DOTA%\dota\pak01_dir.vpk.manifest.txt" & set "oldmanifest=%CONTENT%\pak01_dir.vpk.manifest.txt"
set "OUTDATED=" & if not exist "%newmanifest%" set "OUTDATED=yes" & copy /y "%newmanifest%" "%oldmanifest%" >nul 2>nul
if not defined OUTDATED echo n|COMP "%newmanifest%" "%oldmanifest%" >nul 2>nul
if not defined OUTDATED if ERRORLEVEL 1 ( set "OUTDATED=yes" & set "@refresh=1" ) else set "OUTDATED="
copy /y "%newmanifest%" "%oldmanifest%" >nul 2>nul
%TIMER%
if not exist "%CONTENT%\pak01_dir\particles\dev\*.vpcf_c" call :end ! Could not extract particles!
:: Workaround for Jugg arcana '.vpcf.vpcf' typo? in items_game.txt
pushd "%CONTENT%\pak01_dir\particles\econ\items\juggernaut\bladekeeper_omnislash" & set ".=_dc_juggernaut_omni_slash_tgt.vpcf_c"
if not exist %.%.vpcf_c copy /y %.%_c %.%.vpcf.vpcf_c >nul 2>nul & popd
:: Workaround for NS evil_eyed_arms renamed? in items_game.txt
pushd "%CONTENT%\pak01_dir\particles\econ\items\nightstalker\evil_eyed_arms" & set ".=nightstalker_ambient_evil_eyed_arms.vpcf_c"
if not exist %.% copy /y evil_eyed_arms_eye_sparks.vpcf_c %.% >nul 2>nul & popd
:skip_update_content

::----------------------------------------------------------------------------------------------------------------------------------
%LABEL% " Extracting items_game.txt from dota\pak01_dir.vpk "
if defined @verbose ( set ".= " ) else set ".=>nul 2>nul"
%TIMER%
%decompiler% -i "%DOTA%\dota\pak01_dir.vpk" -o "%CONTENT%\pak01_dir" -d -e txt -f "scripts/items/items_game.txt" %.%
%TIMER%

%LABEL% " Processing items_game.txt using JS engine ... "
pushd "%MOD_OUTPUT%"
%TIMER%
%js_engine% No_Bling "%CONTENT%\pak01_dir" "%MOD_OUTPUT%" "%MOD_CHOICES%" "%@verbose%" "%@timers%" >"%MOD_OUTPUT%\log\no_bling.txt"
%TIMER%

:: Verify items_game.txt VDF parser
if defined @verbose pushd "%CONTENT%\pak01_dir\scripts\items" & echo n | comp items_game.txt "%MOD_OUTPUT%\log\items_game.txt" 2>nul
if defined @verbose call :clearline 1

:: Sort particle?mod definitions for each src category
pushd "%MOD_OUTPUT%\src" & for %%a in (*.ini) do sort "%%a" /o "%%a"

:: Skip further processing if only @verbose was selected
if not defined CHOICES goto :done

::----------------------------------------------------------------------------------------------------------------------------------
:: Resource-compiling before 7.07 - now dumbed-down to file replacement
%LABEL% " Deploying src particles ... "
%TIMER%
pushd "%MOD_OUTPUT%\src" & set/a MOD_COUNT=0 & for %%a in (*.ini) do set/a MOD_COUNT+=1 >nul 2>nul
if %MOD_COUNT% LSS 1 goto :done &rem there must be a category folder under MOD\src
for %%a in (*.ini) do (
 mkdir "%%~na" >nul 2>nul & pushd "%%~na"
 for /f "usebackq skip=1 tokens=1,2 delims=?" %%i in ("%%~dpnxa") do (
  if not exist "%%~dpi" mkdir "%%~dpi" >nul 2>nul
  copy /y "%CONTENT%\pak01_dir\%%j" "%MOD_OUTPUT%\src\%%~na\%%i" >nul 2>nul
 )
 popd
)
%TIMER%
:skip_compiling

:: Create mod vpk
%LABEL% " ValvePak-ing src particles ... "
%TIMER%
pushd "%MOD_OUTPUT%"
for %%a in (%CHOICES%) do if exist "src\%%a" call :color 0e " %%a " &xcopy /E/C/I/Q/R/Y "src\%%a\*.*" "%BUILDS%\pak01_dir"
pushd "%BUILDS%"
for /f %%a in ('dir /a:d /b') do %vpk% %%~na & echo  %%~na.vpk done
pushd "%BUILDS%" & for /f %%a in ('dir /a:d /b') do ( del /f/s/q %%a\*.* & rmdir /s/q %%a ) >nul 2>nul
%TIMER%

:: Generate readme
set .="%BUILDS%\No-Bling DOTA mod readme.txt"
 >%.% echo  No-Bling DOTA mod v%version% choices: %CHOICES%
>>%.% echo --------------------------------------------------------------------------------
>>%.% echo We all know where we are headed looking at the Immortals spam in the last two years...
>>%.% echo.
>>%.% echo  About
>>%.% echo --------------------------------------------------------------------------------
>>%.% echo Simply a competent companion to Settings -- Video -- Effects Quality with the main focus on GlanceValue.
>>%.% echo No-Bling DOTA mod is economy-friendly, gracefully disabling particle spam while leaving hats model untouched.
>>%.% echo Might say it even helps differentiate great artistic work, shadowed by the particle effects galore Valve slaps on top.
>>%.% echo.
>>%.% echo  How to manually install the .vpk / .zip builds after 7.07?
>>%.% echo --------------------------------------------------------------------------------
>>%.% echo Instructions for English language (default)
>>%.% echo - CREATE FOLDER \steamapps\common\dota 2 beta\game\dota_english%%
>>%.% echo - COPY pak01_dir.vpk TO dota_english%% FOLDER
>>%.% echo - ADD LAUNCH OPTIONS: -language english%% -textlanguage english +cl_language english
>>%.% echo Yes there is a percent sign after 'english' as a workaround to keep feed updates
>>%.% echo.
>>%.% echo Instructions for Russian language (same steps for Koreana and Schinese)
>>%.% echo IF NOT EXISTS \steamapps\common\dota 2 beta\game\dota_russian\pak01_dir.vpk
>>%.% echo - COPY pak01_dir.vpk TO dota_russian FOLDER
>>%.% echo IF EXISTS \steamapps\common\dota 2 beta\game\dota_russian\pak01_dir.vpk
>>%.% echo - RENAME pak01_dir.vpk TO pak02_dir.vpk
>>%.% echo - MOVE pak02_dir.vpk TO dota_russian FOLDER
>>%.% echo - ADD LAUNCH OPTION: -language russian
>>%.% echo.
>>%.% echo Instructions for German language (same steps for French, Spanish and others)
>>%.% echo - CREATE FOLDER \steamapps\common\dota 2 beta\game\dota_german
>>%.% echo - COPY pak01_dir.vpk TO dota_german FOLDER
>>%.% echo - ADD LAUNCH OPTION: -language german
>>%.% echo.
>>%.% echo  Mod details
>>%.% echo --------------------------------------------------------------------------------
for %%a in (%CHOICES:,= %) do if exist "%MOD_OUTPUT%\src\%%a.ini" type "%MOD_OUTPUT%\src\%%a.ini" >>%.%

:: Print install mod instructions
%LABEL% " Installing No-Bling DOTA mod after 7.07 "
echo  Press Alt+F4 to Cancel now if you prefer manual install:
setlocal
set "322= ______________________________________________________________________________________ /"
set "323= /"
set "324= Instructions for English language [default]  /"
set "325=   CREATE FOLDER \steamapps\common\dota 2 beta\game\/dota_english%%  /"
set "326=   COPY/ pak01_dir.vpk /TO/ dota_english%% /FOLDER  /"
set "327=   ADD LAUNCH OPTIONS:/ -language english%% -textlanguage english +cl_language english  /"
set "328= Yes there is a percent sign after 'english' as a workaround to keep feed updates  /"
set "329= /"
set "330= Instructions for Russian language [same steps for Koreana and Schinese]  /"
set "331= IF NOT EXISTS \steamapps\common\dota 2 beta\game\/dota_russian\/pak01_dir.vpk  /"
set "332=   COPY/ pak01_dir.vpk /TO/ dota_russian /FOLDER  /"
set "333= IF EXISTS \steamapps\common\dota 2 beta\game\/dota_russian\/pak01_dir.vpk  /"
set "334=   RENAME/ pak01_dir.vpk /TO/ pak02_dir.vpk  /"
set "335=   MOVE/ pak02_dir.vpk /TO/ dota_russian /FOLDER  /"
set "336=   ADD LAUNCH OPTION:/ -language russian  /"
set "337= /"
set "338= Instructions for German language [same steps for French, Spanish and others]  /"
set "339=   CREATE FOLDER \steamapps\common\dota 2 beta\game\/dota_german  /"
set "340=   COPY/ pak01_dir.vpk /TO/ dota_german /FOLDER  /"
set "341=   ADD LAUNCH OPTION:/ -language german  /"
set "342= ______________________________________________________________________________________ /"
set "343= /"
set "i= $inst=""; for($l=$first;$l -le $last;$l++){ $inst += (Get-Item env:$l).Value + "`n" };"
set "n= $delims=$inst.split("/"); foreach ($i in $delims) { $fc="Gray"; $bc="Black"; if($i.Contains(".vpk")){$fc="Green"};"
set "s= if($i.Contains("dota_")){$fc="Magenta"}; if($i.Contains("-")){$fc="Cyan"}; if($i.Contains("[")){$fc="White"};"
set "t= write-host $i -BackgroundColor $bc -ForegroundColor $fc -NoNewLine };"
set "ps_inst=%i%%n%%s%%t%"
powershell -c "$first=322; $last=343; %ps_inst:"=\"%"
endlocal

:: Auto-Install No-Bling mod
echo.
if defined @autoclose ( %WARN%  Closing Dota / Steam to auto-install ) else %WARN%  Auto-install can fail if Dota / Steam is running
timeout /t 10 & call :clearline 4
call :mcolor 0c " G " 04 " L " 0c " A " 04 " N " 0c " C "  04 " E " 4c " V " 04 " A " 0c " L " 04 " U " 0c " E " 04 " +" 0c. " +"
(
if defined @autoclose taskkill /f /im dota2.exe /t & del /f /q "%STEAMPATH%\.crash" >nul 2>nul & timeout /t 1 >nul
mkdir "%DOTA%\%MOD_FOLDER%"
copy /y "%BUILDS%\pak01_dir.vpk" "%DOTA%\%MOD_FOLDER%\%MOD_FILE%"
copy /y "%BUILDS%\No-Bling DOTA mod readme.txt" "%DOTA%\%MOD_FOLDER%\"
) >nul 2>nul
if not defined STEAMDATA goto :done
if defined @autoclose taskkill /f /im steam.exe /t >nul 2>nul
pushd "%STEAMDATA%\config" & copy /y localconfig.vdf localconfig.vdf.bak >nul
%js_engine% Dota_LOptions "localconfig.vdf" "-lv,-language x,-textlanguage x,+cl_language x" -remove
%js_engine% Dota_LOptions "localconfig.vdf" "%MOD_OPTIONS%" -add
:: Relaunch Steam with fast options
set l1=-silent -console -forceservice -windowed -nobigpicture -nointro -vrdisable -single_core -no-dwrite -tcp
set l2=-inhibitbootstrap -nobootstrapperupdate -nodircheck -norepairfiles -noverifyfiles -nocrashmonitor -noassert
if defined @autoclose start "Steam" "%STEAMPATH%\Steam.exe" %l1% %l2%

:done                                                                                                       Gaben shall not prevail!
call :end  Done!
exit/b

::----------------------------------------------------------------------------------------------------------------------------------
:"init" Console preferences                                          &rem " Batch hybrid engine jumps here after goto='init' trick "
::----------------------------------------------------------------------------------------------------------------------------------
@echo off & setlocal &set "BackClr=0" &set "TextClr=7" &set "Columns=40" &set "Lines=120" &set "Buff=9999" &call :clearline 1 2>nul
if not "%1"=="init" set/a SColors=0x%BackClr%%TextClr% & set/a WSize=Columns*256*256+Lines & set/a SBSize=Buff*256*256+Lines
if not "%1"=="init" for %%# in ("HKCU\Console\init" ) do (
 reg add %%# /v QuickEdit /d 0 /t REG_DWORD /f & reg add %%# /v CtrlKeyShortcutsDisabled /d 0 /t REG_DWORD /f
 reg add %%# /v LineWrap /d 0 /t REG_DWORD /f & reg add %%# /v LineSelection /d 1 /t REG_DWORD /f
 reg add %%# /v FaceName /d "Lucida Console" /t REG_SZ /f & reg add %%# /v FontSize /d 0xe0008 /t REG_DWORD /f
 reg add %%# /v ScreenBufferSize /d %SBSize% /t REG_DWORD /f & reg add %%# /v WindowSize /d %WSize% /t REG_DWORD /f
 reg add %%# /v ScreenColors /d %SColors% /t REG_DWORD /f & reg add HKCU\Console /v ForceV2 /d 1 /t REG_DWORD /f
 reg add %%# /v ColorTable00 /d 0x000000 /t REG_DWORD /f & reg add %%# /v ColorTable08 /d 0x808080 /t REG_DWORD /f &rem black  dgray
 reg add %%# /v ColorTable01 /d 0x800000 /t REG_DWORD /f & reg add %%# /v ColorTable09 /d 0xff0000 /t REG_DWORD /f &rem blue   lblue
 reg add %%# /v ColorTable02 /d 0x008000 /t REG_DWORD /f & reg add %%# /v ColorTable10 /d 0x00ff00 /t REG_DWORD /f &rem green  lgree
 reg add %%# /v ColorTable03 /d 0x808000 /t REG_DWORD /f & reg add %%# /v ColorTable11 /d 0xffff00 /t REG_DWORD /f &rem cyan   lcyan
 reg add %%# /v ColorTable04 /d 0x000080 /t REG_DWORD /f & reg add %%# /v ColorTable12 /d 0x0000ff /t REG_DWORD /f &rem red    lred
 reg add %%# /v ColorTable05 /d 0x800080 /t REG_DWORD /f & reg add %%# /v ColorTable13 /d 0xff00ff /t REG_DWORD /f &rem purple lpurp
 reg add %%# /v ColorTable06 /d 0x008080 /t REG_DWORD /f & reg add %%# /v ColorTable14 /d 0x00ffff /t REG_DWORD /f &rem yellow lyell
 reg add %%# /v ColorTable07 /d 0xc0c0c0 /t REG_DWORD /f & reg add %%# /v ColorTable15 /d 0xffffff /t REG_DWORD /f &rem lgray  white
) >nul 2>nul
if not "%1"=="init" ( cd/d %~dp0 & start "init" "%~f0" init & exit/b ) else goto :main      &rem " Self-restart or return to :main "

::----------------------------------------------------------------------------------------------------------------------------------
:: Core functions
::----------------------------------------------------------------------------------------------------------------------------------
:set_macros outputs %[BS]%=BackSpace %[CR]%=CarriageReturn %[GL]%=Glue/NonBreakingSpace %[DEL]%=DelChar %[DEL7]%=DelCharX7
pushd "%TEMP%" & echo=WSH.Echo(String.fromCharCode(160))>` & for /f %%# in ('cscript //E:JScript //nologo `') do set "[GL]=%%#"
for /f %%# in ('echo prompt $H ^| cmd') do set "[BS]=%%#" & for /f %%# in ('copy /z "%~dpf0" nul') do set "[CR]=%%#"
for /f "tokens=2 delims=1234567890" %%# in ('shutdown /?^|findstr /bc:"E"') do set "[TAB]=%%#"
set/p "=-"<nul>` & set "ECHOP=<nul set/p =%[BS]%" & set "[DEL]=%[BS]%%[GL]%%[BS]%" & call set "[DEL3]=%%[DEL]%%%%[DEL]%%%%[DEL]%%"
set "[L]=-%[DEL]%\..\%[DEL3]%" & set "[J]=-%[DEL]%/..\%[DEL3]%" & set "[DEL6]=%[DEL3]%%[DEL3]%" &set "LABEL=echo. &call :color 70. "
set "INFO=call :color b0 " INFO " &echo" & set "WARN=call :color e0 " WARN " &echo" & set "ERROR=call :color cf " ERROR " &echo"
exit/b                                           &rem AveYo - :clearline and :color depend on this, initialize with call :set_macros

:clearline %1:Number[how many lines above to delete - macro designed for Windows 10 but adjusted to work under 7 too]
( if not defined [DEL] call :set_macros ) & setlocal enableDelayedExpansion & set "[LINE]=%[CR]%" & set "[LINE7]=" & set "[COL]="
for /f "skip=4 tokens=2 delims=:" %%a in ('mode con') do for %%c in (%%a) do if not defined [COL] call set "[COL]=%%c"
set/a "[COL7]=2+(%[COL]%+7)/8" &for /l %%i in (1,1,%[COL]%) do call set "[CLR]=%%[CLR]%%%[GL]%" &call set "[LINE]=%[DEL]%%%[LINE]%%"
for /L %%a in (1,1,%[COL7]%) do call set "[LINE7]=%%[LINE7]%%%[BS]%"
ver | find "10." > nul & if errorlevel 1 ( for /L %%i in (1,1,%1) do echo;%[TAB]%%[LINE7]%%[CLR]% & echo;%[TAB]%%[LINE7]% ) else (
for /l %%i in (1,1,%1) do <nul set/p "=![LINE]!" )
endlocal & exit/b                                                                                      &rem Usage: call :clearline 2

:color %1:BgFg.[one or both of hexpair can be _ as defcolor, optional . use newline] %2:text["text with spaces"]
setlocal enableDelayedExpansion &set "bf=%~1" &set "tx=%~2" &set "tx=-%[BS]%!tx:\=%[L]%!" &set "tx=!tx:/=%[J]%!" &set "tx=!tx:"=\"!"
set "bf=!bf: =!" &set "bc=!bf:~0,1!" &set "fc=!bf:~1,1!" &set "nl=!bf:~2,1!" &set "bc=!bc:_=%BackClr%!" &set "fc=!fc:_=%TextClr%!"
pushd "%TEMP%" & findstr /p /r /a:!bc!!fc! "^^-" "!tx!\..\`" nul & <nul set/p "=%[DEL]%%[DEL6]%" & popd & if defined nl echo/%[GL]%
endlocal & exit/b                        &rem AveYo - Usage: call :color fc Hello & call :color _c " fancy " & call :color cf. World

:mcolor %1:BgFg. %2:"only-quoted-text1" %3:BgFg. %4:"only-quoted-text2" etc.
setlocal & set "mc=" & for %%C in (%*) do if "%%C"=="%%~C" ( call set "mc=%%mc%% & call :color %%C" ) else call set "mc=%%mc%% %%C"
echo. %mc% & endlocal & exit/b                                  &rem AveYo - Usage: call :mcolor fc "Hello" _c " fancy " cf. "World"

:end %1:Message[Delayed termination with status message - prefix with ! to signal failure]
echo. & (if defined @time call :timer "%@time%" &call :timer ) & if "%~1"=="!" (%ERROR% %* ) else %INFO%  %*
pause>nul & exit

:noop [does_nothing]
exit/b

:reg_query %1:KeyName %2:ValueName %3:OutputVariable %4:other_options[example: "/t REG_DWORD"]
setlocal & for /f "skip=2 delims=" %%s in ('reg query "%~1" /v "%~2" /z 2^>nul') do set "rq=%%s" & call set "rv=%%rq:*)    =%%"
endlocal & call set "%~3=%rv%" & exit/b                          &rem AveYo - Usage:" call :reg_query "HKCU\MyKey" "MyValue" MyVar "

:timer %1:input[optional] %2:nodisplay[optional]
if not defined timer_set ( if not "%~1"=="" ( call set "timer_set=%~1" ) else set "timer_set=%TIME: =0%" ) & exit/b
( if not "%~1"=="" ( call set "timer_end=%~1" ) else set "timer_end=%TIME: =0%" ) & setlocal EnableDelayedExpansion
for /f "tokens=1-6 delims=0123456789" %%i in ("%timer_end%%timer_set%") do set "CE=%%i" & set "DE=%%k" & set "CS=%%l" & set "DS=%%n"
set "TE=!timer_end:%DE%=%%100)*100+1!" & set "TS=!timer_set:%DS%=%%100)*100+1!"
set/A "T=((((10!TE:%CE%=%%100)*60+1!%%100)-((((10!TS:%CS%=%%100)*60+1!%%100)" & set/A "T=!T:-=8640000-!"
set/A "cc=T%%100+100,T/=100,ss=T%%60+100,T/=60,mm=T%%60+100,hh=T/60+100"
set "value=!hh:~1!%CE%!mm:~1!%CE%!ss:~1!%DE%!cc:~1!" & if "%~2"=="" echo/!value!
endlocal & set "timer_end=%value%" & set "timer_set=" & exit/b       &rem AveYo:" Result printed second-call, saved to %timer_end% "

:unselect %1:choice %2:from variable containing a list of choices separated by , comma
if not defined %~2 exit/b
setlocal & call set "ops=%%%~2%%" & call set "ops=%%ops:,%~1=%%" & call set "ops=%%ops:%~1,=%%" & call set "ops=%%ops:%~1=%%"
endlocal & call set "%~2=%ops%" & exit/b

:choices %1:width %2:height %3:title %4:all_choices %5:def_choices
setlocal  &rem example:" call :choices 322 96 "Test" "opt1 opt2 opt3" "opt2 opt3"  ": all opt shown, but just opt2 and opt3 selected
:: gui dialog choices powershell snippet                                                          cached temporarily to %ps_choices%
set "z=[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms"); $f=New-Object System.Windows.Forms.Form"
set "y=[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing"); $fminsize=New-Object System.Drawing.Size(320,32)"
set "x=$r=(Get-ItemProperty $p).$n; if($r -ne $null){$opt=$r.split(",")}else{$opt=$def.split(",")}; function CLK(){ $v=@()"
set "w=;foreach($x in $cb){if($x.Checked){$v+=$x.Text}}; New-ItemProperty -Path $p -Name $n -Value $($v -join ",") -Force }"
set "v=$BCLK=@(0,{CLK},{foreach($z in $cb){$z.Checked=$false;if($def.split(",") -contains $z.Text){$z.Checked=$true}};CLK})"
set "u=$i=1;$cb=foreach($l in $all.split(",")){ $c=New-Object System.Windows.Forms.CheckBox; $c.Name="c$i"; $c.AutoSize=$true"
set "t=;$c.Text=$l; $c.Location=New-Object System.Drawing.Point(($pad*2.5),(16+(($i-1)*24))); $c.BackColor="Transparent""
set "s=;$c.add_Click({CLK}); $f.Controls.Add($c); $c; $i++; }; foreach($s in $cb){if($opt -contains $s.Text){$s.Checked=$true}}"
set "r=$j=1;$bn=@("OK","Reset"); foreach($t in $bn){ $b=New-Object System.Windows.Forms.Button; $b.Name="b$j""
set "q=;$b.Text=$t; $b.Location=New-Object System.Drawing.Point(($pad*2+($j-1)*$pad*3),(32+(($i-1)*24))); $b.add_Click($BCLK[$j])"
set "p=;if ($t -eq "OK"){$b.DialogResult=[System.Windows.Forms.DialogResult]::OK}; $f.Controls.Add($b); $j++; }"
set "o=$f.Text=$n; $f.BackColor="DarkRed"; $f.Forecolor="White"; $f.FormBorderStyle="Fixed3D"; $f.StartPosition="CenterScreen""
set "n=$f.MaximizeBox=$false; $f.MinimumSize=$fminsize; $f.AutoSize=$true; $f.AutoSizeMode='GrowAndShrink'"
set "m=$f.Add_Shown({$f.Activate()}); $result=$f.ShowDialog(); if ($result -ne [System.Windows.Forms.DialogResult]::OK){"
set "l=Remove-ItemProperty -Path $p -Name $n -Force -erroraction 'silentlycontinue' | out-null}"
set "ps_choices_s=%z%;%y%;%x%;%w%;%v%;%u%;%t%;%s%;%r%;%q%;%p%;%o%;%n%;%m%;%l%;" & call set "ps_choices=%%ps_choices_s:"=\"%%"
powershell -c "$n='%~3 choices'; $all='%~4'; $def='%~5'; $p='HKCU:\Environment'; $pad=32; %ps_choices%" &rem >nul 2>nul
call :reg_query "HKCU\Environment" "%~3 choices" CHOICES
endlocal & set "CHOICES=%CHOICES%" & exit/b                   &rem AveYo:" GUI dialog with autosize checkboxes - outputs %CHOICES% "

::----------------------------------------------------------------------------------------------------------------------------------
:: Utility functions
::----------------------------------------------------------------------------------------------------------------------------------
:set_steam outputs %STEAMPATH% %STEAMDATA% %STEAMID%
set "STEAMPATH=D:\Steam"                                                            &rem AveYo:" Override detection here if needed "
if not exist "%STEAMPATH%\Steam.exe" call :reg_query "HKCU\SOFTWARE\Valve\Steam" "SteamPath" STEAMPATH
set "STEAMDATA=" & if defined STEAMPATH for %%# in ("%STEAMPATH:/=\%") do set "STEAMPATH=%%~dpnx#"    &rem  / pathsep on Windows lul
if not exist "%STEAMPATH%\Steam.exe" call :end ! Cannot find SteamPath in registry
call :reg_query "HKCU\SOFTWARE\Valve\Steam\ActiveProcess" "ActiveUser" ACTIVEUSER & set/a "STEAMID=ACTIVEUSER" >nul 2>nul
if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
if not defined STEAMDATA for /f "delims=" %%# in ('dir "%STEAMPATH%\userdata" /b/o:d/t:w/s 2^>nul') do set "ACTIVEUSER=%%~dp#"
if not defined STEAMDATA for /f "delims=\" %%# in ("%ACTIVEUSER:*\userdata\=%") do set "STEAMID=%%#"
if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
exit/b

:set_dota outputs %STEAMAPPS% %DOTA% %CONTENT%
set "DOTA=D:\Games\steamapps\common\dota 2 beta\game"                               &rem AveYo:" Override detection here if needed "
if exist "%DOTA%\dota\maps\dota.vpk" set "STEAMAPPS=%DOTA:\common\dota 2 beta=%" & exit/b
set "libfilter=LibraryFolders { TimeNextStatsReport ContentStatsID }"
if not exist "%STEAMPATH%\SteamApps\libraryfolders.vdf" call :end ! Cannot find "%STEAMPATH%\SteamApps\libraryfolders.vdf"
for /f usebackq^ delims^=^"^ tokens^=4 %%s in (`findstr /v "%libfilter%" "%STEAMPATH%\SteamApps\libraryfolders.vdf"`) do (
 if exist "%%s\steamapps\appmanifest_570.acf" if exist "%%s\steamapps\common\dota 2 beta\game\dota\maps\dota.vpk" set "libfs=%%s" )
set "STEAMAPPS=%STEAMPATH%\steamapps" & if defined libfs set "STEAMAPPS=%libfs:\\=\%\steamapps"
if not exist "%STEAMAPPS%\common\dota 2 beta\game\dota\maps\dota.vpk" call :end ! Cannot find "%STEAMAPPS%\common\dota 2 beta\game"
set "DOTA=%STEAMAPPS%\common\dota 2 beta\game" & set "CONTENT=%STEAMAPPS%\common\dota 2 beta\content"
exit/b

:set_tools outputs %compiler% %decompiler% %vpk% %js_engine%                          &rem AveYo:" Does not require Workshop Tools!"
if not exist "%~dpn0.js" call :end ! %~n0.js missing! Did you unpack the whole .zip package?
if not exist "%~dp0tools\*" call :end ! tools subfolder missing! Did you unpack the whole .zip package?
set "decompiler="%~dp0tools\ValveResourceFormat\Decompiler.exe""
if not exist %decompiler% call :end ! tools\ValveResourceFormat\Decompiler.exe missing! Did you unpack the whole .zip package?
set "vpk="%~dp0tools\Steam\SourceFilmmaker\game\bin\vpk.exe""
if not exist %vpk% call :end ! tools\Steam\SourceFilmmaker\bin\vpk.exe missing! Did you unpack the whole .zip package?
set "nodejs="%~dp0tools\Node.js\node.exe""
if exist %nodejs% for /f "delims=" %%i in ('%nodejs% -e process.execArgv[0] -p') do if not "%%i"=="-e" set "nodejs="
if not exist %nodejs% set "nodejs="
if defined nodejs ( set "js_engine=%nodejs% "%~dpn0.js"" ) else set "js_engine=cscript //E:JScript //nologo "%~dpn0.js""
exit/b

rem Batch hybrid engine - do not remove */
/* 2>nul || goto init "No-Bling DOTA mod builder"
:: v2019.08.20: TI9
:: - vpktool: fixed folder pak; include pak01_dir subfolder (if it exists) for manual overrides when modding 
:: - revised filters, alternative styles, loadout and taunt animations support, minimap icons 
:: - improved autoupdate, prevent find gnu tools conflict, build folder CUSTOM instead of very long %CHOICES% 
:: - making use of VPKMOD tool [compiled as needed from included source] for in-memory processing with minimal file i/o
:: - auto-update script from github on launch if needed
:: - language independent mod launch option -tempcontent with dota_tempcontent mod root folder
::------------------------------------------------------------------------------------------------------------------------------
:main No-Bling DOTA G l a n c e V a l u e restoration mod builder                                             edited in SynWrite
::------------------------------------------------------------------------------------------------------------------------------
:: Mod builder gui choices - no need to edit defaults here, script shows a graphical dialog for easier selection
set/a Hats=1                       &rem  1 = hide cosmetic particles spam - slowly turning into TF2..                 CORE BUILD
set/a Couriers=1                   &rem  1 = hide courier particles - would be fine.. except some abuse gems on hats
set/a Wards=1                      &rem  1 = hide ward particles on a couple workshop items
set/a Terrain=1                    &rem  1 = tweak ancients, towers, effigies, shrines, bundled weather

set/a Abilities=1                  &rem  1 = revert penguin Frostbite and stuff like that..                           MAIN BUILD
set/a Seasonal=1                   &rem  1 = tweak the International custom tp, blink, vials etc.

set/a AbiliTweak=1                 &rem  1 = revert Rubick Arcana stolen spells, trim effects                         FULL BUILD
set/a HeroTweak=1                  &rem  1 = hide some default hero particles, helps potato pc
set/a Menu=1                       &rem  1 = tweak main menu - ui, hero loadout and preview, treasure opening

set/a Taunts=1                     &rem  1 = ceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeb and dota+                         ++
set/a Glance=1                     &rem  1 = gabening intensifies..

set/a @update=1                    &rem  1 = update script from github on launch,                 0 = stay on outdated script
set/a @refresh=0                   &rem  1 = remove old builds and logs, recompile vpkmod         0 = keep old builds and logs
set/a @verbose=0                   &rem  1 = log detailed per-hero item lists ~8k small files,    0 = skip detailed item lists
::------------------------------------------------------------------------------------------------------------------------------
:: Extra script choices - not available in gui so set them here if needed
set/a @install=1                   &rem  1 = auto-install closes Dota and Steam,                  0 = can't add launch options!
set/a @timers=1                    &rem  1 = total and per tasks accurate timers,                 0 = no reason to disable them
set/a @dialog=1                    &rem  1 = show choices gui dialog,                             0 = use hardcoded values above
set "MOD_FILE=pak01_dir.vpk"       &rem  ? = override here if having multiple mods and needing another name like pak02_dir.vpk
set "all_choices=Hats,Couriers,Wards,Terrain,Abilities,Seasonal,AbiliTweak,HeroTweak,Menu,Taunts,Glance"
set "def_choices=Hats,Couriers,Wards,Terrain,Abilities,Seasonal,AbiliTweak,HeroTweak,Menu"
set "version=2019.08.20"

title AveYo's No-Bling DOTA mod builder v%version%
set a = free script so no bitching! & for /f delims^=^ eol^= %%. in (
        "  ,,,,,, ,,,,,,,,,     , ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, ,,     :_"
        " ,,:.................:,,,,,,,,,:.........:,,,,,,:............:,,:.......:,    :_"
        " ,,:......................................:,,:.......................:,,  :_"
        " ,,,:.............................................................:,,,  :_"
        " ,,,:.............................................................:,,,  :_"
        " ,,,:.............................................................:,,,  :_"
        ",,,,:........:,,,,:................................:,,,:..............:,,,  :_"
        " ,,:........:,,,,,,,:.......................:,,,,,,,,,,,,:.............:,,, :_"
        ",,,:..........:,,,,,,,,:.....................:,,, ,    ,,,:............:,,, :_"
        " ,,:............:,,,  ,,,,,:....................:,,,,  ,,:.............:,,  :_"
        ",,,:..............:,,,  ,,,,,,:...................:,,,,,,:.............:,,  :_"
        " ,,,:...............:,,    ,,,,,:....................:,,,:............:,,,  :_"
        "  ,,:................:,,,       ,,,,:..............................:,,    :_"
        "  ,,:..................:,,,,      ,,,,,:..........................:,,,    :_"
        "  ,,:....................:,,,       , ,,,:.........................:,,,   :_"
        "  ,,:......................:,,,         ,,,,:.......................:,,   :_"
        "  ,,,:.......................:,,,,        ,,,,,:....................:,,,  :_"
        " ,,,:..........................:,,,           ,,,,:.................:,,,  :_"
        " ,,:.............................:,,,            ,,,,:..............:,,,  :_"
        " ,,:..............................:,,,,            ,,,,,:............:,,  :_"
        " ,,:...........:,,:...................:,,,,             ,,,,,:.........:,,, :_"
        " ,,,:.........:,,,,,:....................:,,,               ,,:........:,,  :_"
        "   ,,:.......:,,, ,,,,:...................:,,,,            ,,,:........:,,, :_"
        "  ,,,:.......:,,,    ,,,:...................:,,,,          ,,:.........:,,, :_"
        " ,,,:.......:,,,      ,,,,:...................:,,,        ,,:..........:,,  :_"
        " ,,:.........:,,,     ,,,,,,:...................:,,,, ,  ,,,:..........:,, ,:_"
        " ,,:...........:,,,,,,,,,:......................:,,,,,,,:...........:,,,    :_"
        " ,,:...............................................................:,,, :_"
        " ,,:...............................................................:,,, :_"
        ",,,:...............................                       .........:,, ,:_"
        " ,,:...............................:  No-: Bling : DOTA mod  :.........:,,, :_"
        ",,,,:..............................                       .........:, , :_"
        " ,,,,,,,,,,,,,,,,,,,,,,,,,:..:,,,:.............................:,,,,:..:,,, :_"
        "    , ,,, ,,,, , , ,,,,,,,,, ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  ,,,,   _"
) do set "_=%%~."
set "D=$logo=''; foreach ($l in '%_:" "=%'.split('_')){ $logo += ' ' * 24 + $l + \"`n\" }; $bling=$logo.split(':');"
set "O=foreach ($i in $bling) { $fc='Cyan'; $bc='Black'; if($i.Contains('.')){$fc='Red'}; if($i.Contains(',')){$fc='DarkRed'};"
set "T=if($i.Contains('Bling')){$fc='Black';$bc='Cyan'};$i=$i.replace('.','#').replace(',','`');"
set "A=write-host $i -BackgroundColor $bc -ForegroundColor $fc -NoNewLine }"
powershell -noprofile -c "%D%;%O%;%T%;%A%"           &REM comment this line to -commit heresy- skip the awesome ascii art logo

:: Parse Script options - rather complicated back & forth define - undefine, but it gets the job done!
for %%o in (@update @refresh @verbose @install @dialog @timers) do call set "%%o=%%%%o:0=%%"
if defined @timers ( set "@time=%TIME: =0%" & set "TIMER=call :timer" ) else set "TIMER=call :noop"
set "@choices="
if defined @dialog set "all_choices=%all_choices%,@update,@refresh,@verbose" & set "def_choices=%def_choices%,@update"
for %%o in (%all_choices%) do call set "%%o=%%%%o:0=%%"                 &REM undefine any option equal to 0, easier script usage
for %%o in (%all_choices%) do if defined %%o (if defined @choices (call set @choices=%%@choices%%,%%o) else set @choices=%%o)

:: Auto-update script from github - can fail on naked Windows 7 without TLS 1.2 hotfix and ps 5.1
::------------------------------------------------------------------------------------------------------------------------------
if not defined @update goto skip_update
set "URL=https://github.com/No-Bling/DOTA/raw/master"
set "URL=https://raw.githubusercontent.com/No-Bling/DOTA/master"
set "FILE=No-Bling DOTA mod builder"
:: Check online .version
set/a online=1 & set/a offline=%version:.=%+0
cd/d "%~dp0" & del /f/q .version >nul 2>nul
set "wc=$wc=new-object System.Net.WebClient"
set "wc=%wc%;$wc.Headers.Add('user-agent','Mozilla/5.0 (compatible, MSIE 11, Windows NT 6.3; Trident/7.0; rv:11.0) like Gecko')"
powershell -noprofile -c "%wc%; $wc.DownloadFile('%URL%/.version','%~dp0.version');"
if not exist .version certutil -URLCache -split -f "%URL%/.version"
rem >nul 2>nul                   &REM naked Windows 7 workaround
if not exist .version goto skip_update                                                                         &REM still failed..
if exist .version for /f "tokens=1,2,3 delims=." %%i in ('type .version') do set/a online=%%i%%j%%k+0
if %offline% LSS %online% (set "outdated=1") else set "outdated=" & goto skip_update
:: Only download builder.zip if local script is outdated
cd/d "%~dp0" & del /f/q "%FILE%.zip" >nul 2>nul
powershell -noprofile -c "%wc%; $wc.DownloadFile('%URL%/%FILE%.zip','%~dp0%FILE%.zip');" >nul 2>nul
if not exist "%~dp0%FILE%.zip" certutil -URLCache -split -f "%URL%/%FILE%.zip" >nul 2>nul        &REM naked Windows 7 workaround
if not exist "%~dp0%FILE%.zip" goto skip_update                                                                &REM still failed..
:: UnZip overwriting local files (except No-Bling-filters-personal.txt) and start the updated script
set "UNZIP=$s=new-object -com shell.application;foreach($i in $s.NameSpace($zip).items()){$s.Namespace($dir).copyhere($i,0x14)}"
set "UPDATE=$dir='%~dp0'; $zip='%~dp0%FILE%.zip'; %UNZIP%; start '%FILE%.bat'"
start powershell -noprofile -WindowStyle Hidden -c "%UPDATE%" &exit
::------------------------------------------------------------------------------------------------------------------------------
:skip_update

:: Check DOTA, tools and environment
cd/d "%~dp0"
set "ROOT=%CD%"
set "MOD_FOLDER=dota_tempcontent" & set "MOD_OPTIONS=-tempcontent"
if not defined MOD_FILE set "MOD_FILE=pak01_dir.vpk"
call :set_steam & call :set_dota & call :set_tools

:: Check DOTA launch options
if defined STEAMDATA cd/d "%STEAMDATA%\config" & if exist localconfig.vdf (
 for /f "delims=" %%a in ('cscript //E:JScript //nologo "%~dpn0.js" LOptions localconfig.vdf "_" -read') do set "LOPTIONS=%%a"
)

:: Patch Anticipation Station - quick and dirty check for new DOTA patch (no pointless particles extraction from vpk each run)
for /f usebackq^ delims^=^"^ tokens^=4 %%a in (`findstr LastUpdated "%STEAMAPPS%\appmanifest_570.acf"`) do set/a "UPDATED=%%a+0"
mkdir "%DOTA%\%MOD_FOLDER%" >nul 2>nul & cd/d "%DOTA%\%MOD_FOLDER%" & set "NEWPATCH=" & set/a "LASTUPDATED=0"
echo @set/a "LASTUPDATED=%UPDATED%" ^&exit/b>pas_updated.bat & if exist last_updated.bat call last_updated.bat
if %UPDATED% GTR %LASTUPDATED% set "NEWPATCH=yes"
if not defined NEWPATCH ( call :color 03 " old patch " ) else call :color 0b " new patch " &rem set "@refresh=1"

:: Show dialog to pick choices
if defined @dialog call :choices MOD_CHOICES "%all_choices%" "%def_choices%" "No-Bling choices" 14 DarkRed Snow
:: Process dialog result
if defined @dialog if not defined MOD_CHOICES call :end ! No choices selected!
if not defined MOD_CHOICES set "MOD_CHOICES=%@choices%"
:: Force complementary particles options if (\_/) selected
set "gabening=%MOD_CHOICES:Glance=%"
if "%gabening%" NEQ "%MOD_CHOICES%" for %%o in (Hats,Couriers,Wards) do call :unselect %%o MOD_CHOICES
if "%gabening%" NEQ "%MOD_CHOICES%" set "MOD_CHOICES=Hats,Couriers,Wards,%MOD_CHOICES%"
for %%o in (%all_choices%) do set "%%o="                                                       &REM undefine all initial choices
for %%o in (%MOD_CHOICES%) do set "%%o=1"                                                  &REM then redefine selected ones to 1

:: Clear script-only temporary options and export choices to registry (including @update value)
for %%o in (@refresh,@verbose) do call :unselect %%o MOD_CHOICES
reg add "HKCU\Environment" /v "No-Bling choices" /t REG_SZ /d "%MOD_CHOICES%" /f >nul 2>nul
call :unselect @update MOD_CHOICES
:: Force @refresh and @install options on if refactored script is running for the first time
::if not exist "%CONTENT%\no-bling\pak01_dir.vpk.manifest.txt" set/a @refresh=1 & set/a @install=1

:: Print configuration
%LABEL% " Configuration "
echo  Mod choices    = %MOD_CHOICES%
echo  Mod file       = %DOTA%\%MOD_FOLDER%\%MOD_FILE%
echo  Mod options    = %MOD_OPTIONS%
echo  User profile   = %STEAMDATA%
echo  User options   = %LOPTIONS%
echo  Script options = @update:%@update%  @refresh:%@refresh%  @verbose:%@verbose%  @install:%@install%  @dialog:%@dialog%
echo  Script version = v%version%  Online version = v%online%  -  https://github.com/No-Bling/DOTA
echo.

:: Prepare directories
if defined @refresh del /f /q %vpkmod% 2>nul & call :build_csc_vpkmod 
call :color 0e " Preparing directories, please wait ... "
cd/d "%ROOT%"
::set "BUILDS=%CD%\BUILDS\%MOD_CHOICES:,=_%"
set "BUILDS=%CD%\BUILDS\CUSTOM"
mkdir "%BUILDS%" >nul 2>nul & mkdir "%ROOT%\log" >nul 2>nul
set ".="%ROOT%\src""
if defined @refresh set ".=%.% "%DOTA%\%MOD_FOLDER%" "%BUILDS%""               &REM clear content only @refresh
if defined @refresh if defined @verbose set ".=%.%  "%ROOT%\log""              &REM clear ~8k log files each @verbose + @refresh
for %%i in (%.%) do ( del /f/s/q "%%~i" & rmdir /s/q "%%~i" & mkdir "%%~i" ) >nul 2>nul
call :clearline 3

%LABEL% " Extracting lists from dota\pak01_dir.vpk ... "
%vpkmod% -i "%DOTA%\dota\pak01_dir.vpk" -l "%ROOT%\src\particles.lst" -e "vpcf_c" -s >nul 2>nul
%vpkmod% -i "%DOTA%\dota\pak01_dir.vpk" -l "%ROOT%\src\models.lst" -e "vmdl_c" -s >nul 2>nul
%vpkmod% -i "%DOTA%\dota\pak01_dir.vpk" -l "%ROOT%\src\anim.lst" -e "vanim_c" -s >nul 2>nul
%vpkmod% -i "%DOTA%\dota\pak01_dir.vpk" -o "%ROOT%\src" -e "txt" -p "scripts/mod_textures.txt" -s >nul 2>nul
%vpkmod% -i "%DOTA%\dota\pak01_dir.vpk" -o "%ROOT%\src" -e "txt" -p "scripts/items/items_game.txt"
mkdir "%ROOT%\src\scripts\npc" >nul 2>nul
copy /y "%DOTA%\dota\scripts\npc\npc_heroes.txt" "%ROOT%\src\scripts\npc" >nul 2>nul
copy /y "%DOTA%\dota\scripts\npc\npc_units.txt" "%ROOT%\src\scripts\npc" >nul 2>nul

call :mcolor 70 " Processing items_game.txt and particles.lst ... " c0. " ETA: 10-60s "
if defined @verbose echo Writing per-hero / category slice logs and verbose no_bling.txt to log folder...
if defined @verbose ( set ".=>"%ROOT%\log\no_bling.txt"" ) else set ".= "
cd/d "%ROOT%"
%TIMER%
%js_engine% No_Bling "%MOD_CHOICES%" "%@verbose%" "%@timers%" %.%
if defined MOD_CHOICES if not exist "%ROOT%\src\src.lst" %TIMER% & call :done ! Processing failed, src.lst missing..
:: Verify VDF parser
if defined @verbose cd/d "%ROOT%\src\scripts\items" &echo n|comp items_game.txt "%ROOT%\log\items_game.txt" 2>nul
if defined @verbose call :clearline 1
:: Sort particle?mod definitions for each src category
cd/d "%ROOT%\src" & for %%a in (*.ini src.lst) do sort "%%a" /o "%%a"
:: Show per category file count
set/a Other=1                                                             &REM forced category for stuff like particle snapshots
for %%a in ("%ROOT%\src\*.ini") do if defined %%~na (
 for /f "tokens=3" %%B in ('findstr /v /c "" "%%a" 2^>nul^|findstr /i "%%a" 2^>nul') do call :color 0a " %%~na " &echo : %%B files
)
%TIMER%

:: Skip content if only @verbose was selected
if defined @verbose if not defined MOD_CHOICES echo.& %INFO%  No mod choices selected, just detailed logs exported & goto done

:: Update changed content cache
::if defined @refresh del /f /q "%CONTENT%\no-bling\pak01_dir.vpk.manifest.txt" >nul 2>nul
cd/d "%DOTA%\%MOD_FOLDER%"
if exist pas_updated.bat ( copy /y pas_updated.bat last_updated.bat & del /f /q pas_updated.bat ) >nul 2>nul

:: Override minimap_hero_sheet_psd_3529892a.vtex_c to revert hero icons 
if not defined Glance goto skip_icons
set "icons1=%ROOT%\pak01_dir\materials\vgui\hud\minimap_hero_sheet_psd_3529892a.vtex_c"
set "icons2=%ROOT%\minimap_hero_sheet_psd_3529892a.vtex_c"
if not exist "%icons1%" if not exist "%icons2%" (set "missing_icons=1") else set "missing_icons="
if defined missing_icons (%WARN%  Missing minimap_hero_sheet, you must extract all files in builder.zip) else ( 
 mkdir "%ROOT%\pak01_dir\materials\vgui\hud" >nul 2>nul & copy /y "%icons2%" "%icons1%" >nul 2>nul 
)
:skip_icons

:: In-memory file replacement mod using nothing but unaltered Valve authored files (custom vpkmod tool exclusive feature)
call :mcolor 70 " Deploying selected No-Bling choices ... " c0. " ETA: 10-30s "
%TIMER%
cd/d "%ROOT%"
%vpkmod% -i "%DOTA%\dota\pak01_dir.vpk" -o "%BUILDS%\pak01_dir.vpk" -m "%ROOT%\src\src.lst" -s
%TIMER%

:: Generate readme
cd/d "%BUILDS%"
set .="%BUILDS%\No-Bling DOTA mod readme.txt"
 >%.% echo  No-Bling DOTA mod v%version% choices:
>>%.% echo  %MOD_CHOICES%
>>%.% echo --------------------------------------------------------------------------------
>>%.% echo We all know where we are headed looking at the Immortals spam in the last three years...
>>%.% echo.
>>%.% echo  About
>>%.% echo --------------------------------------------------------------------------------
>>%.% echo Simply a competent companion to Settings -- Video -- Effects Quality with the main focus on GlanceValue.
>>%.% echo No-Bling DOTA mod is economy-friendly, gracefully disabling particle spam while leaving hats model untouched.
>>%.% echo Might say it even helps differentiate great artistic work, shadowed by the particle effects galore Valve slaps on top
>>%.% echo.
>>%.% echo  How to manually install No-Bling DOTA mod builds in 2019
>>%.% echo --------------------------------------------------------------------------------
>>%.% echo - CREATE FOLDER \steamapps\common\dota 2 beta\game\dota_tempcontent
>>%.% echo - COPY pak01_dir.vpk TO dota_tempcontent FOLDER
>>%.% echo - ADD LAUNCH OPTIONS: -tempcontent
>>%.% echo.
>>%.% echo  Mod details
>>%.% echo --------------------------------------------------------------------------------
for %%a in (%MOD_CHOICES:,= %) do if exist "%ROOT%\src\%%a.ini" type "%ROOT%\src\%%a.ini" >>%.%

:: Print No-Bling mod manual install instructions
call :mcolor 70 "       How to manually install No-Bling DOTA mod builds in 2019       "
call :mcolor 70 " " 07 "                                                                    " 70 " "
call :mcolor 70 " " 07 "  CREATE FOLDER \steamapps\common\dota 2 beta\game\" 0d "dota_tempcontent" 07 " " 70 " "
call :mcolor 70 " " 07 "  COPY " 0a "pak01_dir.vpk" 07 " TO " 0d "dota_tempcontent" 07 " FOLDER                     " 70 " "
call :mcolor 70 " " 07 "  ADD LAUNCH OPTION: " 0b "-tempcontent" 07 "                                   " 70 " "
call :mcolor 70 " " 07 "                                                                    " 70 " "
call :mcolor 70. "                                                                      " 07. " "

:: Auto-Install No-Bling DOTA mod
if not defined @install call :color 0e. " To apply No-Bling mod enable @install option. " & goto done
:: Create the necessary mod folder and copy the current build of pak01_dir.vpk to it
mkdir "%DOTA%\%MOD_FOLDER%" >nul 2>nul
copy /y "%BUILDS%\pak01_dir.vpk" "%DOTA%\%MOD_FOLDER%\%MOD_FILE%" >nul 2>nul
copy /y "%BUILDS%\No-Bling DOTA mod readme.txt" "%DOTA%\%MOD_FOLDER%\" >nul 2>nul
:: Supress AnimResource warnings
set autocfg="%DOTA%\dota\cfg\autoexec.cfg"
findstr /b /c:"log_verbosity AnimResource off" %autocfg% >nul 2>nul || (
 echo.
 echo/log_verbosity AnimResource off ^| grep %%
) >>%autocfg%
:: End task to allow launch option adding
if exist %~dp0zip\* goto done
set "@endtask=" & tasklist /FI "IMAGENAME eq STEAM.EXE" | findstr /i "STEAM.EXE" >nul 2>nul && set "@endtask=1"
if defined @endtask call :color 0e " Press Alt+F4 to stop auto-install from closing Dota & Steam in 10s ..."
if defined @endtask timeout /t 10 >nul 2>nul
if defined @endtask call :clearline 3
if defined @endtask taskkill /f /im dota2.exe /im steam.exe /t >nul 2>nul & timeout /t 2 >nul
:: Create the necessary mod folder and copy the current build of pak01_dir.vpk to it (2nd try)
mkdir "%DOTA%\%MOD_FOLDER%" >nul 2>nul
copy /y "%BUILDS%\pak01_dir.vpk" "%DOTA%\%MOD_FOLDER%\%MOD_FILE%" >nul 2>nul
copy /y "%BUILDS%\No-Bling DOTA mod readme.txt" "%DOTA%\%MOD_FOLDER%\" >nul 2>nul
:: Add launch options for Dota 2 directly in the config file [ does not update if Steam is running hence the @endtask option ]
if not defined STEAMDATA goto done
cd/d "%STEAMDATA%\config" & copy /y localconfig.vdf localconfig.vdf.bak >nul
::%js_engine% LOptions "localconfig.vdf" "-lv,-language x,-textlanguage x,+cl_language x" -remove     &REM clear old mod options
%js_engine% LOptions "localconfig.vdf" "%MOD_OPTIONS%" -add
:: Relaunch Steam with fast options       PSA: you can add l1 and l2 options to your Steam shorcut at the end of the Target line
if defined @endtask del /f /q "%STEAMPATH%\.crash" >nul 2>nul
set l1=-silent -console -forceservice -single_core -windowed -manuallyclearframes 0 -nodircheck -norepairfiles -noverifyfiles
set l2=-nocrashmonitor -nocrashdialog -vrdisable -nofriendsui -skipstreamingdrivers +"@AllowSkipGameUpdate 1 -
if defined @endtask start "Steam" "%STEAMPATH%\Steam.exe" %l1% %l2%

:done                                                                                                   Gaben shall not prevail!
call :mcolor 0b " G " 03 " L " 0b " A " 03 " N " 0b " C "  03 " E " 3b " V " 03 " A " 0b " L " 03 " U " 0b " E " 03. " ++"
call :end  Done!
exit/b

::------------------------------------------------------------------------------------------------------------------------------
:init Console preferences                                           sets color table and prevents mouseclicks pausing the script
::------------------------------------------------------------------------------------------------------------------------------
@echo off &setlocal &set "BackClr=0"&set "TextClr=7"&set "Columns=40" &set "Lines=120" &set "Buff=9999" &call :clearline 2 2>nul
if not "%1"=="init" set/a SColors=0x%BackClr%%TextClr% & set/a WSize=Columns*256*256+Lines & set/a SBSize=Buff*256*256+Lines
if not "%1"=="init" for %%# in ("HKCU\Console\init" ) do (
 reg add %%# /v QuickEdit /d 0 /t REG_DWORD /f &reg add %%# /v CtrlKeyShortcutsDisabled /d 0 /t REG_DWORD /f
 reg add %%# /v LineWrap /d 0 /t REG_DWORD /f &reg add %%# /v LineSelection /d 1 /t REG_DWORD /f
 reg add %%# /v FaceName /d "Lucida Console" /t REG_SZ /f &reg add %%# /v FontSize /d 0xe0008 /t REG_DWORD /f
 reg add %%# /v ScreenBufferSize /d %SBSize% /t REG_DWORD /f &reg add %%# /v WindowSize /d %WSize% /t REG_DWORD /f
 reg add %%# /v ScreenColors /d %SColors% /t REG_DWORD /f &reg add HKCU\Console /v ForceV2 /d 1 /t REG_DWORD /f
 reg add %%# /v ColorTable00 /d 0x000000 /t REG_DWORD /f &reg add %%# /v ColorTable08 /d 0x808080 /t REG_DWORD /f &REM black  dg
 reg add %%# /v ColorTable01 /d 0x800000 /t REG_DWORD /f &reg add %%# /v ColorTable09 /d 0xff0000 /t REG_DWORD /f &REM blue   lb
 reg add %%# /v ColorTable02 /d 0x008000 /t REG_DWORD /f &reg add %%# /v ColorTable10 /d 0x00ff00 /t REG_DWORD /f &REM green  lg
 reg add %%# /v ColorTable03 /d 0x808000 /t REG_DWORD /f &reg add %%# /v ColorTable11 /d 0xffff00 /t REG_DWORD /f &REM cyan   lc
 reg add %%# /v ColorTable04 /d 0x000080 /t REG_DWORD /f &reg add %%# /v ColorTable12 /d 0x0000ff /t REG_DWORD /f &REM red    lr
 reg add %%# /v ColorTable05 /d 0x800080 /t REG_DWORD /f &reg add %%# /v ColorTable13 /d 0xff00ff /t REG_DWORD /f &REM purple lp
 reg add %%# /v ColorTable06 /d 0x008080 /t REG_DWORD /f &reg add %%# /v ColorTable14 /d 0x00ffff /t REG_DWORD /f &REM yellow ly
 reg add %%# /v ColorTable07 /d 0xc0c0c0 /t REG_DWORD /f &reg add %%# /v ColorTable15 /d 0xffffff /t REG_DWORD /f &REM lgray  wh
) >nul 2>nul
cls & if not "%1"=="init" ( start "init" "%~f0" init & exit/b ) else goto main            &REM " Self-restart or return to :main "

::------------------------------------------------------------------------------------------------------------------------------
:: Core functions
::------------------------------------------------------------------------------------------------------------------------------
:set_macros [OUTPUTS] %[BS]%=BackSpace %[CR]%=CarriageReturn %[GL]%=Glue/NonBreakingSpace %[DEL]%=DelChar %[DEL7]%=DelCharX7
cd/d "%TEMP%" & echo=WSH.Echo(String.fromCharCode(160))>` & for /f %%# in ('cscript //E:JScript //nologo `') do set "[GL]=%%#"
for /f %%# in ('echo prompt $H ^| cmd') do set "[BS]=%%#" & for /f %%# in ('copy /z "%~dpf0" nul') do set "[CR]=%%#"
for /f "tokens=2 delims=1234567890" %%# in ('shutdown /?^|findstr /bc:"E"') do set "[TAB]=%%#"
set/p "=-"<nul>` &set "ECHOP=<nul set/p =%[BS]%" &set "[DEL]=%[BS]%%[GL]%%[BS]%" &call set "[DEL3]=%%[DEL]%%%%[DEL]%%%%[DEL]%%"
set "[L]=-%[DEL]%\..\%[DEL3]%"&set "[J]=-%[DEL]%/..\%[DEL3]%"&set "[DEL6]=%[DEL3]%%[DEL3]%" &set "LABEL=echo. &call :color 70. "
set "INFO=call :color b0 " INFO " &echo" & set "WARN=call :color e0 " WARN " &echo" & set "ERROR=call :color cf " ERROR " &echo"
exit/b                                       &REM AveYo - :clearline and :color depend on this, initialize with call :set_macros

:clearline Number[how many lines above to delete - macro designed for Windows 10 but adjusted to work under 7 too]
( if not defined [DEL] call :set_macros ) &setlocal enableDelayedExpansion & set "[LINE]=%[CR]%" & set "[LINE7]=" & set "[COL]="
for /f "skip=4 tokens=2 delims=:" %%a in ('mode con') do for %%c in (%%a) do if not defined [COL] call set "[COL]=%%c"
set/a "[C7]=2+(%[COL]%+7)/8"&for /l %%i in (1,1,%[COL]%) do call set "[CLR]=%%[CLR]%%%[GL]%"&call set "[LINE]=%[DEL]%%%[LINE]%%"
for /L %%a in (1,1,%[C7]%) do call set "[LINE7]=%%[LINE7]%%%[BS]%"
ver | findstr "10." >nul & if errorlevel 1 ( for /L %%i in (1,1,%1) do echo;%[TAB]%%[LINE7]%%[CLR]% & echo;%[TAB]%%[LINE7]%
) else (for /l %%i in (1,1,%1) do <nul set/p "=![LINE]!" )
endlocal & exit/b                                                                                  &REM Usage: call :clearline 2

:color BgFg.[one or both of hexpair can be _ as defcolor, optional . use newline] text["text with spaces"]
setlocal enableDelayedExpansion &set "bf=%~1"&set "tx=%~2"&set "tx=-%[BS]%!tx:\=%[L]%!"&set "tx=!tx:/=%[J]%!"&set "tx=!tx:"=\"!"
set "bf=!bf: =!" &set "bc=!bf:~0,1!" &set "fc=!bf:~1,1!" &set "nl=!bf:~2,1!"&set "bc=!bc:_=%BackClr%!"&set "fc=!fc:_=%TextClr%!"
pushd "%TEMP%" & findstr /p /r /a:!bc!!fc! "^^-" "!tx!\..\`" nul &<nul set/p "=%[DEL]%%[DEL6]%" &popd &if defined nl echo/%[GL]%
endlocal & exit/b                    &REM AveYo - Usage: call :color fc Hello & call :color _c " fancy " & call :color cf. World

:mcolor BgFg. "only-quoted-text1" BgFg. "only-quoted-text2" etc.
set "-mc~=" & for %%C in (%*) do if "%%C"=="%%~C" (call set "-mc~=%%-mc~%% & call :color %%C") else call set "-mc~=%%-mc~%% %%C"
echo. %-mc~% & exit/b                                       &REM AveYo - Usage: call :mcolor fc "Hello" _c " fancy " cf. "World"

:end Message[Delayed termination with status message - prefix with ! to signal failure]
if exist "%ROOT%\~TMP" del /f/s/q "%ROOT%\~TMP\*.*" >nul 2>nul & rmdir /s/q "%ROOT%\~TMP" >nul 2>nul
echo. & (if defined @time call :timer "%@time%" &call :timer ) & if "%~1"=="!" (%ERROR% %* ) else %INFO%  %*
pause>nul & exit

:noop [does_nothing]
exit/b

:reg_query [USAGE] call :reg_query ResultVar "HKCU\KeyName" "ValueName"
(for /f "skip=2 delims=" %%s in ('reg query "%~2" /v "%~3" /z 2^>nul') do set ".=%%s" & call set "%~1=%%.:*)    =%%") & exit/b

:timer [USAGE] call :timer input[optional] nodisplay[optional]
if not defined timer_set ( if not "%~1"=="" ( call set "timer_set=%~1" ) else set "timer_set=%TIME: =0%" ) & exit/b
( if not "%~1"=="" ( call set "timer_end=%~1" ) else set "timer_end=%TIME: =0%" ) & setlocal EnableDelayedExpansion
for /f "tokens=1-6 delims=0123456789" %%i in ("%timer_end%%timer_set%") do set "CE=%%i"&set "DE=%%k" &set "CS=%%l"&set "DS=%%n"
set "TE=!timer_end:%DE%=%%100)*100+1!" & set "TS=!timer_set:%DS%=%%100)*100+1!"
set/A "T=((((10!TE:%CE%=%%100)*60+1!%%100)-((((10!TS:%CS%=%%100)*60+1!%%100)" & set/A "T=!T:-=8640000-!"
set/A "cc=T%%100+100,T/=100,ss=T%%60+100,T/=60,mm=T%%60+100,hh=T/60+100"
set "value=!hh:~1!%CE%!mm:~1!%CE%!ss:~1!%DE%!cc:~1!" & if "%~2"=="" echo/!value!
endlocal & set "timer_end=%value%" & set "timer_set=" & exit/b   &REM AveYo:" Result printed second-call, saved to %timer_end% "

:unselect [USAGE] call :unselect choice variable[containing a list of choices separated by , comma]
if not defined %~2 exit/b
setlocal & call set "ops=%%%~2%%" & call set "ops=%%ops:,%~1=%%" & call set "ops=%%ops:%~1,=%%" & call set "ops=%%ops:%~1=%%"
endlocal & call set "%~2=%ops%" & exit/b

:choices [USAGE] call :choices ResultVar "all,&choices" "default,choices" [OPTIONAL] "title" "textsize" "backcolor" "textcolor"
(set "params=" & for %%s in (%*) do call set "params=%%params%% '%%~s'") & if not defined ps_? for /f delims^=^ eol^= %%. in (
"function Choices($ov='', $all, $def, $n='Choices', [byte]$sz=12, $bc='MidnightBlue', $fc='Snow', $saved='HKCU:\Environment'){"
"[void][System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms'); $f=New-Object System.Windows.Forms.Form;"
"$i=1; $j=1; $a=$all.split(','); $s=$def.split(','); $reg=(Get-ItemProperty $saved).$n; if($reg.length){$s=$reg.split(',') };"
"function rst(){$cb | foreach{$_.Checked=0; if($s -contains $_.Text){$_.Checked=1 } } }; $f.Add_Shown({rst; $f.Activate()});"
"$cb=@(); $a | foreach{$c=New-Object System.Windows.Forms.CheckBox;$c.Name=$i;$c.Text=$_;$c.MinimumSize='240,14';$c.AutoSize=1;"
"$c.Margin='8,4,8,4';$c.Location='128,'+($sz*$i*2);$c.Font='Arial,'+$sz;$c.Cursor='Hand';$f.Controls.Add($c);$cb+=$c;$i++};"
"$bt=@(); @('OK','Reset','Cancel') | foreach{$b=New-Object System.Windows.Forms.Button;  $b.Text=$_; $b.AutoSize=1;"
"$b.Margin='0,0,72,20';$b.Location=''+(64*$j)+','+(($sz+1)*$i*2);$b.Font='Tahoma,'+$sz; $f.Controls.Add($b);$bt+=$b;$j+=2};"
"$v=@(); $f.AcceptButton=$bt[0]; $f.CancelButton=$bt[2]; $bt[0].DialogResult=1; $bt[1].add_Click({$s=$def.split(',');rst});"
"$f.Text=$n; $f.BackColor=$bc; $f.ForeColor=$fc; $f.StartPosition=4; $f.AutoSize=1; $f.AutoSizeMode=0; $f.FormBorderStyle=3;"
"$f.MaximizeBox=0; $r=$f.ShowDialog(); if($r -eq 1){$cb | foreach{if($_.Checked){$v+=$_.Text}}; $val=$v -join ',';"
"$null=New-ItemProperty -Path $saved -Name $n -Value $val -Force; return $val } }") do set "/=%%~." &call set "ps_?=%%/:" "=%%"
(for /f "delims=" %%s in ('powershell -noprofile -c "%ps_?%; Choices %params%;"') do set "%1=%%s") &exit/b      snippet by AveYo

::------------------------------------------------------------------------------------------------------------------------------
:: Utility functions
::------------------------------------------------------------------------------------------------------------------------------
:set_steam [OUTPUTS] STEAMPATH STEAMDATA STEAMID                                      AveYo : Override detection below if needed
set "STEAMPATH=D:\Steam"
if not exist "%STEAMPATH%\Steam.exe" call :reg_query STEAMPATH "HKCU\SOFTWARE\Valve\Steam" "SteamPath"
set "STEAMDATA=" & if defined STEAMPATH for %%# in ("%STEAMPATH%") do set "STEAMPATH=%%~dpnx#"
if not exist "%STEAMPATH%\Steam.exe" call :end ! Cannot find SteamPath in registry
call :reg_query ACTIVEUSER "HKCU\SOFTWARE\Valve\Steam\ActiveProcess" "ActiveUser" & set/a "STEAMID=ACTIVEUSER" >nul 2>nul
if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
if not defined STEAMDATA for /f "delims=" %%# in ('dir "%STEAMPATH%\userdata" /b/o:d/t:w/s 2^>nul') do set "ACTIVEUSER=%%~dp#"
if not defined STEAMDATA for /f "delims=\" %%# in ("%ACTIVEUSER:*\userdata\=%") do set "STEAMID=%%#"
if exist "%STEAMPATH%\userdata\%STEAMID%\config\localconfig.vdf" set "STEAMDATA=%STEAMPATH%\userdata\%STEAMID%"
exit/b

:set_dota [OUTPUTS] STEAMAPPS DOTA CONTENT                                            AveYo : Override detection below if needed
set "DOTA=D:\Games\steamapps\common\dota 2 beta\game"
if exist "%DOTA%\dota\maps\dota.vpk" set "STEAMAPPS=%DOTA:\common\dota 2 beta=%" & exit/b
set "libfilter=LibraryFolders { TimeNextStatsReport ContentStatsID }"
if not exist "%STEAMPATH%\SteamApps\libraryfolders.vdf" call :end ! Cannot find "%STEAMPATH%\SteamApps\libraryfolders.vdf"
for /f usebackq^ delims^=^"^ tokens^=4 %%s in (`findstr /v "%libfilter%" "%STEAMPATH%\SteamApps\libraryfolders.vdf"`) do (
if exist "%%s\steamapps\appmanifest_570.acf" if exist "%%s\steamapps\common\dota 2 beta\game\dota\dota.fgd" set "libfs=%%s")
set "STEAMAPPS=%STEAMPATH%\steamapps" & if defined libfs set "STEAMAPPS=%libfs:\\=\%\steamapps"
if not exist "%STEAMAPPS%\common\dota 2 beta\game\dota\maps\dota.vpk" call :end ! Missing "%STEAMAPPS%\common\dota 2 beta\game"
set "DOTA=%STEAMAPPS%\common\dota 2 beta\game" & set "CONTENT=%STEAMAPPS%\common\dota 2 beta\content"
exit/b

:set_tools [OUTPUTS] filters decompiler vpk js_engine                                   AveYo : Does not require Workshop Tools!
if not exist "%ROOT%\%~n0.js" call :end ! %~n0.js missing! Did you unpack the whole .zip package?
::if not exist "%ROOT%\tools\*" call :end ! tools subfolder missing! Did you unpack the whole .zip package?
set "PATH=%PATH%;%ROOT%\tools\"
set "vpkmod="%ROOT%\vpkmod.exe""
for /f "usebackq" %%v in (`wmic datafile where "name='%ROOT:\=\\%\\vpkmod.exe'" get version /value 2^>nul`) do set V%%v >nul 2>nul
if "%VVersion%"=="2019.5.21.0 " del /f /q %vpkmod%
if not exist %vpkmod% call :build_csc_vpkmod
if not exist %vpkmod% call :end ! vpkmod.exe missing! Try to compile it manually from [tools\build vpkmod.zip]
set "nodejs="%ROOT%\tools\node.exe""
if not exist %nodejs% ( set "nodejs=" ) else pushd "%ROOT%\tools"
if defined nodejs for /f "delims=" %%i in ('node.exe -e process.execArgv[0] -p') do if not "%%i"=="-e" set "nodejs="
if defined nodejs set "js_engine=%nodejs% "%~dpn0.js"" & popd
if not defined nodejs set "js_engine="%WINDIR%\System32\cscript.exe" //E:JScript //nologo "%~dpn0.js""
exit/b

:build_csc_vpkmod
for /f "tokens=* delims=" %%v in ('dir /b /s /a:-d /o:-n "%Windir%\Microsoft.NET\Framework\*csc.exe"') do set "csc=%%v"
cd/d %~dp0 & "%csc%" /out:vpkmod.exe /target:exe /platform:anycpu /optimize /nologo "%~f0"
if not exist vpkmod.exe call :end ! Failed compiling VPKMOD C# snippet! .net framework 3.5+ / VS2008 compiler needed
exit/b VPKMOD C# source */
// v1.2: fixed folder pak; include pak01_dir subfolder (if it exists) for manual overrides when modding 
// v1.1: Mod.lst : can use "mod?.nix" lines to replace "mod" with a 0-byte file; update ValvePak
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using SteamDatabase.ValvePak;
using VPKMOD;

[assembly:AssemblyTitle("VPKMOD")]
[assembly:AssemblyCompanyAttribute("AveYo")]
[assembly: AssemblyCopyright("AveYo / SteamDatabase")]
[assembly:AssemblyVersionAttribute("2019.08.20")]

namespace SteamDatabase.ValvePak
{
    // [assembly: AssemblyTitle("Valve Pak Library")]
    // [assembly: AssemblyDescription("Library to work with Valve Pak archives")]
    // [assembly: AssemblyCompany("SteamDatabase")]
    // [assembly: AssemblyProduct("ValvePak")]
    // [assembly: AssemblyCopyright("Copyright c SteamDatabase 2016")]
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // PackageEntry.cs
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public class PackageEntry
    {
        /// <summary>
        /// Gets or sets file name of this entry.
        /// </summary>
        public string FileName { get; set; }

        /// <summary>
        /// Gets or sets the name of the directory this file is in.
        /// '/' is always used as a dictionary separator in Valve's implementation.
        /// Directory names are also always lower cased in Valve's implementation.
        /// </summary>
        public string DirectoryName { get; set; }

        /// <summary>
        /// Gets or sets the file extension.
        /// If the file has no extension, this is an empty string.
        /// </summary>
        public string TypeName { get; set; }

        /// <summary>
        /// Gets or sets the CRC32 checksum of this entry.
        /// </summary>
        public uint CRC32 { get; set; }

        /// <summary>
        /// Gets or sets the length in bytes.
        /// </summary>
        public uint Length { get; set; }

        /// <summary>
        /// Gets or sets the offset in the package.
        /// </summary>
        public uint Offset { get; set; }

        /// <summary>
        /// Gets or sets which archive this entry is in.
        /// </summary>
        public ushort ArchiveIndex { get; set; }

        /// <summary>
        /// Gets the length in bytes by adding Length and length of SmallData.
        /// </summary>
        public uint TotalLength
        {
            get
            {
                var totalLength = Length;

                if (SmallData != null)
                {
                    totalLength += (uint)SmallData.Length;
                }

                return totalLength;
            }
        }

        /// <summary>
        /// Gets or sets the preloaded bytes.
        /// </summary>
        public byte[] SmallData { get; set; }

        /// <summary>
        /// Returns the file name and extension.
        /// </summary>
        /// <returns>File name and extension.</returns>
        public string GetFileName()
        {
            var fileName = FileName;

            if (TypeName == " ")
            {
                return fileName;
            }

            return fileName + "." + TypeName;
        }

        /// <summary>
        /// Returns the absolute path of the file in the package.
        /// </summary>
        /// <returns>Absolute path.</returns>
        public string GetFullPath()
        {
            if (DirectoryName == " ")
            {
                return GetFileName();
            }

            return DirectoryName + Package.DirectorySeparatorChar + GetFileName();
        }

        public override string ToString()
        {
            //return $"{GetFullPath()} crc=0x{CRC32:x2} metadatasz={SmallData.Length} fnumber={ArchiveIndex} ofs=0x{Offset:x2} sz={Length}";
            return String.Format("{0} crc=0x{1:x2} metadatasz={2} fnumber={3} ofs=0x{4:x2} sz={5}", GetFullPath(), CRC32, SmallData.Length, ArchiveIndex, Offset, Length);
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // ArchiveMD5SectionEntry.cs
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// VPK_ArchiveMD5SectionEntry
    /// </summary>
    public class ArchiveMD5SectionEntry
    {
        /// <summary>
        /// Gets or sets the CRC32 checksum of this entry.
        /// </summary>
        public uint ArchiveIndex { get; set; }

        /// <summary>
        /// Gets or sets the offset in the package.
        /// </summary>
        public uint Offset { get; set; }

        /// <summary>
        /// Gets or sets the length in bytes.
        /// </summary>
        public uint Length { get; set; }

        /// <summary>
        /// Gets or sets the expected Checksum checksum.
        /// </summary>
        public byte[] Checksum { get; set; }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // StreamHelpers.cs
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    internal static class StreamHelpers
    {
        /// <summary>
        /// Reads a null terminated string.
        /// </summary>
        /// <returns>String.</returns>
        /// <param name="stream">Stream.</param>
        /// <param name="encoding">Encoding.</param>
        public static string ReadNullTermString(this BinaryReader stream, Encoding encoding)
        {
            var characterSize = encoding.GetByteCount("e");

            using (var ms = new MemoryStream())
            {
                while (true)
                {
                    var data = new byte[characterSize];
                    stream.Read(data, 0, characterSize);

                    if (encoding.GetString(data, 0, characterSize) == "\0")
                    {
                        break;
                    }

                    ms.Write(data, 0, data.Length);
                }

                return encoding.GetString(ms.ToArray());
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Crc32.cs
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// A utility class to compute CRC32.
    /// </summary>
    internal static class Crc32
    {
        /// <summary>
        /// CRC polynomial 0xEDB88320.
        /// </summary>
        private static readonly uint[] Table =
        {
            0x00000000, 0x77073096, 0xEE0E612C, 0x990951BA, 0x076DC419,
            0x706AF48F, 0xE963A535, 0x9E6495A3, 0x0EDB8832, 0x79DCB8A4,
            0xE0D5E91E, 0x97D2D988, 0x09B64C2B, 0x7EB17CBD, 0xE7B82D07,
            0x90BF1D91, 0x1DB71064, 0x6AB020F2, 0xF3B97148, 0x84BE41DE,
            0x1ADAD47D, 0x6DDDE4EB, 0xF4D4B551, 0x83D385C7, 0x136C9856,
            0x646BA8C0, 0xFD62F97A, 0x8A65C9EC, 0x14015C4F, 0x63066CD9,
            0xFA0F3D63, 0x8D080DF5, 0x3B6E20C8, 0x4C69105E, 0xD56041E4,
            0xA2677172, 0x3C03E4D1, 0x4B04D447, 0xD20D85FD, 0xA50AB56B,
            0x35B5A8FA, 0x42B2986C, 0xDBBBC9D6, 0xACBCF940, 0x32D86CE3,
            0x45DF5C75, 0xDCD60DCF, 0xABD13D59, 0x26D930AC, 0x51DE003A,
            0xC8D75180, 0xBFD06116, 0x21B4F4B5, 0x56B3C423, 0xCFBA9599,
            0xB8BDA50F, 0x2802B89E, 0x5F058808, 0xC60CD9B2, 0xB10BE924,
            0x2F6F7C87, 0x58684C11, 0xC1611DAB, 0xB6662D3D, 0x76DC4190,
            0x01DB7106, 0x98D220BC, 0xEFD5102A, 0x71B18589, 0x06B6B51F,
            0x9FBFE4A5, 0xE8B8D433, 0x7807C9A2, 0x0F00F934, 0x9609A88E,
            0xE10E9818, 0x7F6A0DBB, 0x086D3D2D, 0x91646C97, 0xE6635C01,
            0x6B6B51F4, 0x1C6C6162, 0x856530D8, 0xF262004E, 0x6C0695ED,
            0x1B01A57B, 0x8208F4C1, 0xF50FC457, 0x65B0D9C6, 0x12B7E950,
            0x8BBEB8EA, 0xFCB9887C, 0x62DD1DDF, 0x15DA2D49, 0x8CD37CF3,
            0xFBD44C65, 0x4DB26158, 0x3AB551CE, 0xA3BC0074, 0xD4BB30E2,
            0x4ADFA541, 0x3DD895D7, 0xA4D1C46D, 0xD3D6F4FB, 0x4369E96A,
            0x346ED9FC, 0xAD678846, 0xDA60B8D0, 0x44042D73, 0x33031DE5,
            0xAA0A4C5F, 0xDD0D7CC9, 0x5005713C, 0x270241AA, 0xBE0B1010,
            0xC90C2086, 0x5768B525, 0x206F85B3, 0xB966D409, 0xCE61E49F,
            0x5EDEF90E, 0x29D9C998, 0xB0D09822, 0xC7D7A8B4, 0x59B33D17,
            0x2EB40D81, 0xB7BD5C3B, 0xC0BA6CAD, 0xEDB88320, 0x9ABFB3B6,
            0x03B6E20C, 0x74B1D29A, 0xEAD54739, 0x9DD277AF, 0x04DB2615,
            0x73DC1683, 0xE3630B12, 0x94643B84, 0x0D6D6A3E, 0x7A6A5AA8,
            0xE40ECF0B, 0x9309FF9D, 0x0A00AE27, 0x7D079EB1, 0xF00F9344,
            0x8708A3D2, 0x1E01F268, 0x6906C2FE, 0xF762575D, 0x806567CB,
            0x196C3671, 0x6E6B06E7, 0xFED41B76, 0x89D32BE0, 0x10DA7A5A,
            0x67DD4ACC, 0xF9B9DF6F, 0x8EBEEFF9, 0x17B7BE43, 0x60B08ED5,
            0xD6D6A3E8, 0xA1D1937E, 0x38D8C2C4, 0x4FDFF252, 0xD1BB67F1,
            0xA6BC5767, 0x3FB506DD, 0x48B2364B, 0xD80D2BDA, 0xAF0A1B4C,
            0x36034AF6, 0x41047A60, 0xDF60EFC3, 0xA867DF55, 0x316E8EEF,
            0x4669BE79, 0xCB61B38C, 0xBC66831A, 0x256FD2A0, 0x5268E236,
            0xCC0C7795, 0xBB0B4703, 0x220216B9, 0x5505262F, 0xC5BA3BBE,
            0xB2BD0B28, 0x2BB45A92, 0x5CB36A04, 0xC2D7FFA7, 0xB5D0CF31,
            0x2CD99E8B, 0x5BDEAE1D, 0x9B64C2B0, 0xEC63F226, 0x756AA39C,
            0x026D930A, 0x9C0906A9, 0xEB0E363F, 0x72076785, 0x05005713,
            0x95BF4A82, 0xE2B87A14, 0x7BB12BAE, 0x0CB61B38, 0x92D28E9B,
            0xE5D5BE0D, 0x7CDCEFB7, 0x0BDBDF21, 0x86D3D2D4, 0xF1D4E242,
            0x68DDB3F8, 0x1FDA836E, 0x81BE16CD, 0xF6B9265B, 0x6FB077E1,
            0x18B74777, 0x88085AE6, 0xFF0F6A70, 0x66063BCA, 0x11010B5C,
            0x8F659EFF, 0xF862AE69, 0x616BFFD3, 0x166CCF45, 0xA00AE278,
            0xD70DD2EE, 0x4E048354, 0x3903B3C2, 0xA7672661, 0xD06016F7,
            0x4969474D, 0x3E6E77DB, 0xAED16A4A, 0xD9D65ADC, 0x40DF0B66,
            0x37D83BF0, 0xA9BCAE53, 0xDEBB9EC5, 0x47B2CF7F, 0x30B5FFE9,
            0xBDBDF21C, 0xCABAC28A, 0x53B39330, 0x24B4A3A6, 0xBAD03605,
            0xCDD70693, 0x54DE5729, 0x23D967BF, 0xB3667A2E, 0xC4614AB8,
            0x5D681B02, 0x2A6F2B94, 0xB40BBE37, 0xC30C8EA1, 0x5A05DF1B,
            0x2D02EF8D
        };

        /// <summary>
        /// Compute a checksum for a given array of bytes.
        /// </summary>
        /// <param name="buffer">The array of bytes to compute the checksum for.</param>
        /// <returns>The computed checksum.</returns>
        public static uint Compute(byte[] buffer)
        {
            uint crc = 0xFFFFFFFF;

            for (var i = 0; i < buffer.Length; i++)
            {
                crc = (crc >> 8) ^ Table[buffer[i] ^ (crc & 0xff)];
            }

            return ~crc;
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // AsnKeyParser.cs
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
This code is licenced under MIT

// The MIT License
//
// Copyright (c) 2006-2008 TinyVine Software Limited.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

Portions of this software are Copyright of Simone Chiaretta
Portions of this software are Copyright of Nate Kohari
Portions of this software are Copyright of Alex Henderson
*/
    internal sealed class BerDecodeException : Exception
    {
        private readonly int _position;

        public BerDecodeException(string message, int position)
            : base(message)
        {
            _position = position;
        }

        public BerDecodeException(string message, int position, Exception ex)
            : base(message, ex)
        {
            _position = position;
        }

        public override string Message
        {
            get
            {
                var sb = new StringBuilder(base.Message);

                sb.AppendFormat(" (Position {0}){1}",
                                _position, Environment.NewLine);

                return sb.ToString();
            }
        }
    }

    internal sealed class AsnKeyParser
    {
        private readonly AsnParser _parser;

        public AsnKeyParser(ICollection<byte> contents)
        {
            _parser = new AsnParser(contents);
        }

        public static byte[] TrimLeadingZero(byte[] values)
        {
            byte[] r;
            if ((0x00 == values[0]) && (values.Length > 1))
            {
                r = new byte[values.Length - 1];
                Array.Copy(values, 1, r, 0, values.Length - 1);
            }
            else
            {
                r = new byte[values.Length];
                Array.Copy(values, r, values.Length);
            }

            return r;
        }

        public static bool EqualOid(byte[] first, byte[] second)
        {
            if (first.Length != second.Length)
            {
                return false;
            }

            for (int i = 0; i < first.Length; i++)
            {
                if (first[i] != second[i])
                {
                    return false;
                }
            }

            return true;
        }

        public RSAParameters ParseRSAPublicKey()
        {
            var parameters = new RSAParameters();

            // Current value

            // Sanity Check

            // Checkpoint
            int position = _parser.CurrentPosition();

            // Ignore Sequence - PublicKeyInfo
            int length = _parser.NextSequence();
            if (length != _parser.RemainingBytes())
            {
                var sb = new StringBuilder("Incorrect Sequence Size. ");
                sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                length.ToString(CultureInfo.InvariantCulture),
                                _parser.RemainingBytes().ToString(CultureInfo.InvariantCulture));
                throw new BerDecodeException(sb.ToString(), position);
            }

            // Checkpoint
            position = _parser.CurrentPosition();

            // Ignore Sequence - AlgorithmIdentifier
            length = _parser.NextSequence();
            if (length > _parser.RemainingBytes())
            {
                var sb = new StringBuilder("Incorrect AlgorithmIdentifier Size. ");
                sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                length.ToString(CultureInfo.InvariantCulture),
                                _parser.RemainingBytes().ToString(CultureInfo.InvariantCulture));
                throw new BerDecodeException(sb.ToString(), position);
            }

            // Checkpoint
            position = _parser.CurrentPosition();
            // Grab the OID
            byte[] value = _parser.NextOID();
            byte[] oid = { 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01 };
            if (!EqualOid(value, oid))
            {
                throw new BerDecodeException("Expected OID 1.2.840.113549.1.1.1", position);
            }

            // Optional Parameters
            if (_parser.IsNextNull())
            {
                _parser.NextNull();
                // Also OK: value = _parser.Next();
            }
            else
            {
                // Gracefully skip the optional data
                _parser.Next();
            }

            // Checkpoint
            position = _parser.CurrentPosition();

            // Ignore BitString - PublicKey
            length = _parser.NextBitString();
            if (length > _parser.RemainingBytes())
            {
                var sb = new StringBuilder("Incorrect PublicKey Size. ");
                sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                length.ToString(CultureInfo.InvariantCulture),
                                _parser.RemainingBytes().ToString(CultureInfo.InvariantCulture));
                throw new BerDecodeException(sb.ToString(), position);
            }

            // Checkpoint
            position = _parser.CurrentPosition();

            // Ignore Sequence - RSAPublicKey
            length = _parser.NextSequence();
            if (length < _parser.RemainingBytes())
            {
                var sb = new StringBuilder("Incorrect RSAPublicKey Size. ");
                sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                length.ToString(CultureInfo.InvariantCulture),
                                _parser.RemainingBytes().ToString(CultureInfo.InvariantCulture));
                throw new BerDecodeException(sb.ToString(), position);
            }

            parameters.Modulus = TrimLeadingZero(_parser.NextInteger());
            parameters.Exponent = TrimLeadingZero(_parser.NextInteger());

            return parameters;
        }
    }

    internal sealed class AsnParser
    {
        private readonly int _initialCount;
        private readonly List<byte> _octets;

        public AsnParser(ICollection<byte> values)
        {
            _octets = new List<byte>(values.Count);
            _octets.AddRange(values);

            _initialCount = _octets.Count;
        }

        public int CurrentPosition()
        {
            return _initialCount - _octets.Count;
        }

        public int RemainingBytes()
        {
            return _octets.Count;
        }

        private int GetLength()
        {
            int length = 0;

            // Checkpoint
            int position = CurrentPosition();

            try
            {
                byte b = GetNextOctet();

                if (b == (b & 0x7f))
                {
                    return b;
                }

                int i = b & 0x7f;

                if (i > 4)
                {
                    var sb = new StringBuilder("Invalid Length Encoding. ");
                    sb.AppendFormat("Length uses {0} _octets",
                                    i.ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                while (0 != i--)
                {
                    // shift left
                    length <<= 8;

                    length |= GetNextOctet();
                }
            }
            catch (ArgumentOutOfRangeException ex)
            {
                throw new BerDecodeException("Error Parsing Key", position, ex);
            }

            return length;
        }

        public byte[] Next()
        {
            int position = CurrentPosition();

            try
            {
#pragma warning disable 168
#pragma warning disable 219
                byte b = GetNextOctet();
#pragma warning restore 219
#pragma warning restore 168

                int length = GetLength();
                if (length > RemainingBytes())
                {
                    var sb = new StringBuilder("Incorrect Size. ");
                    sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                    length.ToString(CultureInfo.InvariantCulture),
                                    RemainingBytes().ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                return GetOctets(length);
            }
            catch (ArgumentOutOfRangeException ex)
            {
                throw new BerDecodeException("Error Parsing Key", position, ex);
            }
        }

        private byte GetNextOctet()
        {
            int position = CurrentPosition();

            if (0 == RemainingBytes())
            {
                var sb = new StringBuilder("Incorrect Size. ");
                sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                1.ToString(CultureInfo.InvariantCulture),
                                RemainingBytes().ToString(CultureInfo.InvariantCulture));
                throw new BerDecodeException(sb.ToString(), position);
            }

            byte b = GetOctets(1)[0];

            return b;
        }

        private byte[] GetOctets(int octetCount)
        {
            int position = CurrentPosition();

            if (octetCount > RemainingBytes())
            {
                var sb = new StringBuilder("Incorrect Size. ");
                sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                octetCount.ToString(CultureInfo.InvariantCulture),
                                RemainingBytes().ToString(CultureInfo.InvariantCulture));
                throw new BerDecodeException(sb.ToString(), position);
            }

            var values = new byte[octetCount];

            try
            {
                _octets.CopyTo(0, values, 0, octetCount);
                _octets.RemoveRange(0, octetCount);
            }
            catch (ArgumentOutOfRangeException ex)
            {
                throw new BerDecodeException("Error Parsing Key", position, ex);
            }

            return values;
        }

        public bool IsNextNull()
        {
            return _octets[0] == 0x05;
        }

        public int NextNull()
        {
            int position = CurrentPosition();

            try
            {
                byte b = GetNextOctet();
                if (0x05 != b)
                {
                    var sb = new StringBuilder("Expected Null. ");
                    sb.AppendFormat("Specified Identifier: {0}", b.ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                // Next octet must be 0
                b = GetNextOctet();
                if (0x00 != b)
                {
                    var sb = new StringBuilder("Null has non-zero size. ");
                    sb.AppendFormat("Size: {0}", b.ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                return 0;
            }
            catch (ArgumentOutOfRangeException ex)
            {
                throw new BerDecodeException("Error Parsing Key", position, ex);
            }
        }

        public int NextSequence()
        {
            int position = CurrentPosition();

            try
            {
                byte b = GetNextOctet();
                if (0x30 != b)
                {
                    var sb = new StringBuilder("Expected Sequence. ");
                    sb.AppendFormat("Specified Identifier: {0}",
                                    b.ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                int length = GetLength();
                if (length > RemainingBytes())
                {
                    var sb = new StringBuilder("Incorrect Sequence Size. ");
                    sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                    length.ToString(CultureInfo.InvariantCulture),
                                    RemainingBytes().ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                return length;
            }
            catch (ArgumentOutOfRangeException ex)
            {
                throw new BerDecodeException("Error Parsing Key", position, ex);
            }
        }

        public int NextBitString()
        {
            int position = CurrentPosition();

            try
            {
                byte b = GetNextOctet();
                if (0x03 != b)
                {
                    var sb = new StringBuilder("Expected Bit String. ");
                    sb.AppendFormat("Specified Identifier: {0}", b.ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                int length = GetLength();

                // We need to consume unused bits, which is the first
                //   octet of the remaing values
                b = _octets[0];
                _octets.RemoveAt(0);
                length--;

                if (0x00 != b)
                {
                    throw new BerDecodeException("The first octet of BitString must be 0", position);
                }

                return length;
            }
            catch (ArgumentOutOfRangeException ex)
            {
                throw new BerDecodeException("Error Parsing Key", position, ex);
            }
        }

        public byte[] NextInteger()
        {
            int position = CurrentPosition();

            try
            {
                byte b = GetNextOctet();
                if (0x02 != b)
                {
                    var sb = new StringBuilder("Expected Integer. ");
                    sb.AppendFormat("Specified Identifier: {0}", b.ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                int length = GetLength();
                if (length > RemainingBytes())
                {
                    var sb = new StringBuilder("Incorrect Integer Size. ");
                    sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                    length.ToString(CultureInfo.InvariantCulture),
                                    RemainingBytes().ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                return GetOctets(length);
            }
            catch (ArgumentOutOfRangeException ex)
            {
                throw new BerDecodeException("Error Parsing Key", position, ex);
            }
        }

        public byte[] NextOID()
        {
            int position = CurrentPosition();

            try
            {
                byte b = GetNextOctet();
                if (0x06 != b)
                {
                    var sb = new StringBuilder("Expected Object Identifier. ");
                    sb.AppendFormat("Specified Identifier: {0}",
                                    b.ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                int length = GetLength();
                if (length > RemainingBytes())
                {
                    var sb = new StringBuilder("Incorrect Object Identifier Size. ");
                    sb.AppendFormat("Specified: {0}, Remaining: {1}",
                                    length.ToString(CultureInfo.InvariantCulture),
                                    RemainingBytes().ToString(CultureInfo.InvariantCulture));
                    throw new BerDecodeException(sb.ToString(), position);
                }

                var values = new byte[length];

                for (int i = 0; i < length; i++)
                {
                    values[i] = _octets[0];
                    _octets.RemoveAt(0);
                }

                return values;
            }
            catch (ArgumentOutOfRangeException ex)
            {
                throw new BerDecodeException("Error Parsing Key", position, ex);
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Package.cs
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
 * Read() function was mostly taken from Rick's Gibbed.Valve.FileFormats,
 * which is subject to this license:
 *
 * Copyright (c) 2008 Rick (rick 'at' gibbed 'dot' us)
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 *
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 *
 * 3. This notice may not be removed or altered from any source
 * distribution.
 */
    public class Package : IDisposable
    {
        public const int MAGIC = 0x55AA1234;

        /// <summary>
        /// Always '/' as per Valve's vpk implementation.
        /// </summary>
        public const char DirectorySeparatorChar = '/';

        private BinaryReader Reader;
        private bool IsDirVPK;
        private uint HeaderSize;

        /// <summary>
        /// Gets the File Name
        /// </summary>
        public string FileName { get; private set; }

        /// <summary>
        /// Gets the VPK version.
        /// </summary>
        public uint Version { get; private set; }

        /// <summary>
        /// Gets the size in bytes of the directory tree.
        /// </summary>
        public uint TreeSize { get; private set; }

        /// <summary>
        /// Gets how many bytes of file content are stored in this VPK file (0 in CSGO).
        /// </summary>
        public uint FileDataSectionSize { get; private set; }

        /// <summary>
        /// Gets the size in bytes of the section containing MD5 checksums for external archive content.
        /// </summary>
        public uint ArchiveMD5SectionSize { get; private set; }

        /// <summary>
        /// Gets the size in bytes of the section containing MD5 checksums for content in this file.
        /// </summary>
        public uint OtherMD5SectionSize { get; private set; }

        /// <summary>
        /// Gets the size in bytes of the section containing the public key and signature.
        /// </summary>
        public uint SignatureSectionSize { get; private set; }

        /// <summary>
        /// Gets the MD5 checksum of the file tree.
        /// </summary>
        public byte[] TreeChecksum { get; private set; }

        /// <summary>
        /// Gets the MD5 checksum of the archive MD5 checksum section entries.
        /// </summary>
        public byte[] ArchiveMD5EntriesChecksum { get; private set; }

        /// <summary>
        /// Gets the MD5 checksum of the complete package until the signature structure.
        /// </summary>
        public byte[] WholeFileChecksum { get; private set; }

        /// <summary>
        /// Gets the public key.
        /// </summary>
        public byte[] PublicKey { get; private set; }

        /// <summary>
        /// Gets the signature.
        /// </summary>
        public byte[] Signature { get; private set; }

        /// <summary>
        /// Gets the package entries.
        /// </summary>
        public Dictionary<string, List<PackageEntry>> Entries { get; private set; }

        /// <summary>
        /// Gets the archive MD5 checksum section entries. Also known as cache line hashes.
        /// </summary>
        public List<ArchiveMD5SectionEntry> ArchiveMD5Entries { get; private set; }

        /// <summary>
        /// Releases binary reader.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing && Reader != null)
            {
                //Reader.Dispose();
                ((IDisposable)Reader).Dispose();
                Reader = null;
            }
        }

        /// <summary>
        /// Sets the file name.
        /// </summary>
        /// <param name="fileName">Filename.</param>
        public void SetFileName(string fileName)
        {
            if (fileName.EndsWith(".vpk", StringComparison.Ordinal))
            {
                fileName = fileName.Substring(0, fileName.Length - 4);
            }

            if (fileName.EndsWith("_dir", StringComparison.Ordinal))
            {
                IsDirVPK = true;

                fileName = fileName.Substring(0, fileName.Length - 4);
            }

            FileName = fileName;
        }

        /// <summary>
        /// Opens and reads the given filename.
        /// The file is held open until the object is disposed.
        /// </summary>
        /// <param name="filename">The file to open and read.</param>
        public void Read(string filename)
        {
            SetFileName(filename);

            //var fs = new FileStream($"{FileName}{(IsDirVPK ? "_dir" : string.Empty)}.vpk", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            var fs = new FileStream(String.Format("{0}{1}.vpk", FileName,(IsDirVPK ? "_dir" : string.Empty)), FileMode.Open, FileAccess.Read, FileShare.ReadWrite);

            Read(fs);
        }

        /// <summary>
        /// Reads the given <see cref="Stream"/>.
        /// </summary>
        /// <param name="input">The input <see cref="Stream"/> to read from.</param>
        public void Read(Stream input)
        {
            if (FileName == null)
            {
                throw new InvalidOperationException("If you call Read() directly with a stream, you must call SetFileName() first.");
            }

            Reader = new BinaryReader(input);

            if (Reader.ReadUInt32() != MAGIC)
            {
                throw new InvalidDataException("Given file is not a VPK.");
            }

            Version = Reader.ReadUInt32();
            TreeSize = Reader.ReadUInt32();

            if (Version == 1)
            {
                // Nothing else
            }
            else if (Version == 2)
            {
                FileDataSectionSize = Reader.ReadUInt32();
                ArchiveMD5SectionSize = Reader.ReadUInt32();
                OtherMD5SectionSize = Reader.ReadUInt32();
                SignatureSectionSize = Reader.ReadUInt32();
            }
            else
            {
                throw new InvalidDataException(string.Format("Bad VPK version. ({0})", Version));
            }

            HeaderSize = (uint)input.Position;

            ReadEntries();

            if (Version == 2)
            {
                // Skip over file data, if any
                input.Position += FileDataSectionSize;

                ReadArchiveMD5Section();
                ReadOtherMD5Section();
                ReadSignatureSection();
            }
        }

        /// <summary>
        /// Searches for a given file entry in the file list.
        /// </summary>
        /// <param name="filePath">Full path to the file to find.</param>
        public PackageEntry FindEntry(string filePath)
        {
            if (filePath == null)
            {
                //throw new ArgumentNullException(nameof(filePath));
                throw new ArgumentNullException("filePath");
            }

            filePath = filePath.Replace('\\', DirectorySeparatorChar);

            var lastSeparator = filePath.LastIndexOf(DirectorySeparatorChar);
            var directory = lastSeparator > -1 ? filePath.Substring(0, lastSeparator) : string.Empty;
            var fileName = filePath.Substring(lastSeparator + 1);

            return FindEntry(directory, fileName);
        }

        /// <summary>
        /// Searches for a given file entry in the file list.
        /// </summary>
        /// <param name="directory">Directory to search in.</param>
        /// <param name="fileName">File name to find.</param>
        public PackageEntry FindEntry(string directory, string fileName)
        {
            if (directory == null)
            {
                //throw new ArgumentNullException(nameof(directory));
                throw new ArgumentNullException("directory");
            }

            if (fileName == null)
            {
                //throw new ArgumentNullException(nameof(fileName));
                throw new ArgumentNullException("fileName");
            }

            var dot = fileName.LastIndexOf('.');
            string extension;

            if (dot > -1)
            {
                extension = fileName.Substring(dot + 1);
                fileName = fileName.Substring(0, dot);
            }
            else
            {
                // Valve uses a space for missing extensions
                extension = " ";
            }

            return FindEntry(directory, fileName, extension);
        }

        /// <summary>
        /// Searches for a given file entry in the file list.
        /// </summary>
        /// <param name="directory">Directory to search in.</param>
        /// <param name="fileName">File name to find, without the extension.</param>
        /// <param name="extension">File extension, without the leading dot.</param>
        public PackageEntry FindEntry(string directory, string fileName, string extension)
        {
            if (directory == null)
            {
                //throw new ArgumentNullException(nameof(directory));
                throw new ArgumentNullException("directory");
            }

            if (fileName == null)
            {
                //throw new ArgumentNullException(nameof(fileName));
                throw new ArgumentNullException("fileName");
            }

            if (extension == null)
            {
                //throw new ArgumentNullException(nameof(extension));
                throw new ArgumentNullException("extension");
            }

            if (!Entries.ContainsKey(extension))
            {
                return null;
            }

            // We normalize path separators when reading the file list
            // And remove the trailing slash
            directory = directory.Replace('\\', DirectorySeparatorChar).Trim(DirectorySeparatorChar);

            // If the directory is empty after trimming, set it to a space to match Valve's behaviour
            if (directory.Length == 0)
            {
                directory = " ";
            }

            return Entries[extension].Find(x => x.DirectoryName == directory && x.FileName == fileName);
        }

        /// <summary>
        /// Reads the entry from the VPK package.
        /// </summary>
        /// <param name="entry">Package entry.</param>
        /// <param name="output">Output buffer.</param>
        /// <param name="validateCrc">If true, CRC32 will be calculated and verified for read data.</param>
        public void ReadEntry(PackageEntry entry, out byte[] output)
        {
            ReadEntry(entry, out output, true);
        }
        public void ReadEntry(PackageEntry entry, out byte[] output, bool validateCrc)
        {
            output = new byte[entry.SmallData.Length + entry.Length];

            if (entry.SmallData.Length > 0)
            {
                entry.SmallData.CopyTo(output, 0);
            }

            if (entry.Length > 0)
            {
                Stream fs = null;

                try
                {
                    var offset = entry.Offset;

                    if (entry.ArchiveIndex != 0x7FFF)
                    {
                        if (!IsDirVPK)
                        {
                            throw new InvalidOperationException("Given VPK is not a _dir, but entry is referencing an external archive.");
                        }

                        //var fileName = $"{FileName}_{entry.ArchiveIndex:D3}.vpk";
                        var fileName = String.Format("{0}_{1:d3}.vpk",FileName,entry.ArchiveIndex);

                        fs = new FileStream(fileName, FileMode.Open, FileAccess.Read);
                    }
                    else
                    {
                        fs = Reader.BaseStream;

                        offset += HeaderSize + TreeSize;
                    }

                    fs.Seek(offset, SeekOrigin.Begin);
                    fs.Read(output, entry.SmallData.Length, (int)entry.Length);
                }
                finally
                {
                    if (entry.ArchiveIndex != 0x7FFF)
                    {
                        //fs?.Close();
                        fs.Close();
                    }
                }
            }

            if (validateCrc && entry.CRC32 != Crc32.Compute(output))
            {
                throw new InvalidDataException("CRC32 mismatch for read data.");
            }
        }

        private void ReadEntries()
        {
            var typeEntries = new Dictionary<string, List<PackageEntry>>();

            // Types
            while (true)
            {
                var typeName = Reader.ReadNullTermString(Encoding.UTF8);

                //if (typeName?.Length == 0)
                if (typeName.Length == 0)
                {
                    break;
                }

                var entries = new List<PackageEntry>();

                // Directories
                while (true)
                {
                    var directoryName = Reader.ReadNullTermString(Encoding.UTF8);

                    //if (directoryName?.Length == 0)
                    if (directoryName.Length == 0)
                    {
                        break;
                    }

                    // Files
                    while (true)
                    {
                        var fileName = Reader.ReadNullTermString(Encoding.UTF8);

                        //if (fileName?.Length == 0)
                        if (fileName.Length == 0)
                        {
                            break;
                        }

                        var entry = new PackageEntry
                        {
                            FileName = fileName,
                            DirectoryName = directoryName,
                            TypeName = typeName,
                            CRC32 = Reader.ReadUInt32(),
                            SmallData = new byte[Reader.ReadUInt16()],
                            ArchiveIndex = Reader.ReadUInt16(),
                            Offset = Reader.ReadUInt32(),
                            Length = Reader.ReadUInt32()
                        };

                        if (Reader.ReadUInt16() != 0xFFFF)
                        {
                            throw new FormatException("Invalid terminator.");
                        }

                        if (entry.SmallData.Length > 0)
                        {
                            Reader.Read(entry.SmallData, 0, entry.SmallData.Length);
                        }

                        entries.Add(entry);
                    }
                }

                typeEntries.Add(typeName, entries);
            }

            Entries = typeEntries;
        }

        /// <summary>
        /// Verify checksums and signatures provided in the VPK
        /// </summary>
        public void VerifyHashes()
        {
            if (Version != 2)
            {
                throw new InvalidDataException("Only version 2 is supported.");
            }

            using (var md5 = MD5.Create())
            {
                Reader.BaseStream.Position = 0;

                var hash = md5.ComputeHash(Reader.ReadBytes((int)(HeaderSize + TreeSize + FileDataSectionSize + ArchiveMD5SectionSize + 32)));

                if (!hash.SequenceEqual(WholeFileChecksum))
                {
                    //throw new InvalidDataException($"Package checksum mismatch ({BitConverter.ToString(hash)} != expected {BitConverter.ToString(WholeFileChecksum)})");
                    throw new InvalidDataException(String.Format("Package checksum mismatch ({0} != expected {1})", BitConverter.ToString(hash), BitConverter.ToString(WholeFileChecksum)));
                }

                Reader.BaseStream.Position = HeaderSize;

                hash = md5.ComputeHash(Reader.ReadBytes((int)TreeSize));

                if (!hash.SequenceEqual(TreeChecksum))
                {
                    //throw new InvalidDataException($"File tree checksum mismatch ({BitConverter.ToString(hash)} != expected {BitConverter.ToString(TreeChecksum)})");
                    throw new InvalidDataException(String.Format("File tree checksum mismatch ({0} != expected {1})", BitConverter.ToString(hash), BitConverter.ToString(TreeChecksum)));
                }

                Reader.BaseStream.Position = HeaderSize + TreeSize + FileDataSectionSize;

                hash = md5.ComputeHash(Reader.ReadBytes((int)ArchiveMD5SectionSize));

                if (!hash.SequenceEqual(ArchiveMD5EntriesChecksum))
                {
                    //throw new InvalidDataException($"Archive MD5 entries checksum mismatch ({BitConverter.ToString(hash)} != expected {BitConverter.ToString(ArchiveMD5EntriesChecksum)})");
                    throw new InvalidDataException(String.Format("Archive MD5 entries checksum mismatch ({0} != expected {1})", BitConverter.ToString(hash), BitConverter.ToString(ArchiveMD5EntriesChecksum)));
                }

                // TODO: verify archive checksums
            }

            if (PublicKey == null || Signature == null)
            {
                return;
            }

            if (!IsSignatureValid())
            {
                throw new InvalidDataException("VPK signature is not valid.");
            }
        }

        /// <summary>
        /// Verifies the RSA signature.
        /// </summary>
        /// <returns>True if signature is valid, false otherwise.</returns>
        public bool IsSignatureValid()
        {
            Reader.BaseStream.Position = 0;

            var keyParser = new AsnKeyParser(PublicKey);

            //var rsa = RSA.Create();
            //rsa.ImportParameters(keyParser.ParseRSAPublicKey());

            //var data = Reader.ReadBytes((int)(HeaderSize + TreeSize + FileDataSectionSize + ArchiveMD5SectionSize + OtherMD5SectionSize));

            //return rsa.VerifyData(data, Signature, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

            var rsa = new RSACryptoServiceProvider();
            rsa.ImportParameters(keyParser.ParseRSAPublicKey());

            var deformatter = new RSAPKCS1SignatureDeformatter(rsa);
            deformatter.SetHashAlgorithm("SHA256");

            var hash = new SHA256Managed().ComputeHash(Reader.ReadBytes((int)(HeaderSize + TreeSize + FileDataSectionSize + ArchiveMD5SectionSize + OtherMD5SectionSize)));

            return deformatter.VerifySignature(hash, Signature);
        }

        private void ReadArchiveMD5Section()
        {
            ArchiveMD5Entries = new List<ArchiveMD5SectionEntry>();

            if (ArchiveMD5SectionSize == 0)
            {
                return;
            }

            var entries = ArchiveMD5SectionSize / 28; // 28 is sizeof(VPK_MD5SectionEntry), which is int + int + int + 16 chars

            for (var i = 0; i < entries; i++)
            {
                ArchiveMD5Entries.Add(new ArchiveMD5SectionEntry
                {
                    ArchiveIndex = Reader.ReadUInt32(),
                    Offset = Reader.ReadUInt32(),
                    Length = Reader.ReadUInt32(),
                    Checksum = Reader.ReadBytes(16)
                });
            }
        }

        private void ReadOtherMD5Section()
        {
            if (OtherMD5SectionSize != 48)
            {
                //throw new InvalidDataException($"Encountered OtherMD5Section with size of {OtherMD5SectionSize} (should be 48)");
                throw new InvalidDataException(String.Format("Encountered OtherMD5Section with size of {0} (should be 48)", OtherMD5SectionSize));
            }

            TreeChecksum = Reader.ReadBytes(16);
            ArchiveMD5EntriesChecksum = Reader.ReadBytes(16);
            WholeFileChecksum = Reader.ReadBytes(16);
        }

        private void ReadSignatureSection()
        {
            if (SignatureSectionSize == 0)
            {
                return;
            }

            var publicKeySize = Reader.ReadInt32();
            PublicKey = Reader.ReadBytes(publicKeySize);

            var signatureSize = Reader.ReadInt32();
            Signature = Reader.ReadBytes(signatureSize);
        }
    }
}

namespace VPKMOD
{
    public class Options
    {
        public string Input = string.Empty;
        public bool Recursive = false;
        public string Output = string.Empty;
        public List<string> ExtFilter = new List<string>();
        public List<string> PathFilter = new List<string>();
        public string FilterList = string.Empty;
        public string ModList = string.Empty;
        public bool OutputVPKDir = false;
        public bool CachedManifest = false;
        public bool VerifyVPKChecksums = false;
        public bool Silent = false;
        public bool Help = false;
        public Options()
        {
            Parsed = new Dictionary< string, List<string> >();
        }
        public IDictionary< string, List<string> > Parsed { get; private set; }
        public bool Find(string key)
        {
            return Find(key, false);
        }
        public bool Find(string key, bool keyonly)
        {
            if (Parsed.ContainsKey(key))
            {
                if (keyonly) return true;
                if (Parsed[key].Count != 0) return true;
                Console.Error.WriteLine("VPKMOD ERROR! Missing argument for: -{0}", key);
            }
            return false;
        }
        public void Parse(string[] args)
        {
            var key = "";
            List<string> values = new List<string>();
            foreach (string arg in args)
            {
                if (arg.StartsWith("-"))
                {
                    if (key != "") Parsed[key] = values;
                    values =  new List<string>();
                    key = arg.Substring(1);
                }
                else if (key == "") Parsed[arg] = new List<string>();
                else values = new List<string>(arg.Split(','));
            }
            if (key != "") Parsed[key] = values;

            if (Find("i"))
            {
                Input = Parsed["i"].FirstOrDefault();
                Console.WriteLine("VPKMOD -i Input:      {0}", Input);
            }
            if (Find("r", true))
            {
                Recursive = true;
                Console.WriteLine("VPKMOD -r Recursive:  {0} (if input is a folder)", Recursive);
            }
            if (Find("o"))
            {
                Output = Parsed["o"].FirstOrDefault();
                Console.WriteLine("VPKMOD -o Output:     {0}", Output);
            }
            if (Find("e"))
            {
                ExtFilter = Parsed["e"];
                Console.WriteLine("VPKMOD -e ExtFilter:  {0}", string.Join(", ", ExtFilter.ToArray()));
            }
            if (Find("p"))
            {
                PathFilter = Parsed["p"];
                Console.WriteLine("VPKMOD -p PathFilter: {0}", string.Join(", ", PathFilter.ToArray()));
            }
            if (Find("l"))
            {
                FilterList = Parsed["l"].FirstOrDefault();
                Console.WriteLine("VPKMOD -l Filter.lst: {0}", FilterList);
            }
            if (Find("m"))
            {
                ModList = Parsed["m"].FirstOrDefault();
                Console.WriteLine("VPKMOD -m Mod.lst:    {0}", ModList);
            }
            if (Find("d", true))
            {
                OutputVPKDir = true;
                Console.WriteLine("VPKMOD -d OutputVPKDir: {0}", OutputVPKDir);
            }
            if (Find("c", true))
            {
                CachedManifest = true;
                Console.WriteLine("VPKMOD -c CachedManifest: {0}", CachedManifest);
            }
            if (Find("v", true))
            {
                VerifyVPKChecksums = true;
                Console.WriteLine("VPKMOD -v VerifyVPKChecksums: {0}", VerifyVPKChecksums);
            }
            if (Find("s", true))
            {
                Silent = true;
                //Console.WriteLine("VPKMOD -s Silent:     {0}", Silent);
            }
            if (Find("h", true) || args.Length == 0)
            {
                Console.WriteLine("VPKMOD v1.1 \t AveYo / SteamDatabase");
                Console.WriteLine(" -i  Input VPK file (unpak) or directory (pak)");
                Console.WriteLine(" -r  Process all files in subdirectories (pak)");
                Console.WriteLine(" -o  Output directory (unpak) or file.vpk (pak)");
                Console.WriteLine(" -e  Extension(s) filter, example: \"vcss_c,vjs_c,vxml_c\"");
                Console.WriteLine(" -p  Path(s) filter, example: \"particles/,models/\"");
                Console.WriteLine(" -l  Import filters from external.lst,");
                Console.WriteLine("     if -e or -p are also used, export filters");
                Console.WriteLine(" -m  Import mod?src definitions from external.lst");
                Console.WriteLine("     allowing in-memory unpak-rename-pak modding");
                Console.WriteLine("     [if src = \".nix\" - replace with 0-byte file]");
                Console.WriteLine(" -d  Export VPK directory of files and their CRC");
                Console.WriteLine(" -c  Use cached VPK manifest - only changed files get written to disk");
                Console.WriteLine(" -v  Verify checksums and signatures");
                Console.WriteLine(" -s  Silent processing");
                Console.WriteLine(" -h  This help screen");
                Console.WriteLine("Press ENTER to quit");
                Console.ReadLine();
                Environment.Exit(0);
            }
        }
    }

    public class Tree<TKey, TValue> : Dictionary<TKey, TValue> {}
    public class Tree<TKey1, TKey2, TValue> : Dictionary<TKey1, Tree<TKey2, TValue>> {}
    public class Tree<TKey1, TKey2, TKey3, TValue> : Dictionary<TKey1, Tree<TKey2, TKey3, TValue>> {}
    public static class TreeExtensions
    {
        public static Tree<TKey2, TValue> New<TKey1, TKey2, TValue>(this Tree<TKey1, TKey2, TValue> dictionary)
        {
            return new Tree<TKey2, TValue>();
        }
        public static Tree<TKey2, TKey3, TValue> New<TKey1,TKey2,TKey3,TValue>(this Tree<TKey1,TKey2,TKey3,TValue> dictionary)
        {
            return new Tree<TKey2, TKey3, TValue>();
        }
    }

    class Program
    {
        private static readonly object ConsoleWriterLock = new object();
        private static Options Options;
        private static int CurrentFile = 0;
        private static int TotalFiles = 0;
        private static Dictionary<string, uint> OldPakManifest = new Dictionary<string, uint>();
        private static Dictionary<string, Dictionary<string, bool>> ModSrc = new Dictionary<string, Dictionary<string, bool>>();
        private static Dictionary<string, string> SrcMod = new Dictionary<string, string>();
        private static List<string> FileFilter = new List<string>();
        private static List<string> ExtFilter = new List<string>();
        private static bool ExportFilter = false;

        public static void Main(string[] args)
        {
            Options = new Options();
            Options.Parse(args);

            if (String.IsNullOrEmpty(Options.Input))
            {
                Echo("Missing -i input parameter!", ConsoleColor.Red);
                return;
            }
            Options.Input = FixPathSlashes(Path.GetFullPath(Options.Input));

            if (!String.IsNullOrEmpty(Options.Output))
            {
                Options.Output = FixPathSlashes(Path.GetFullPath(Options.Output));
            }

            if (!String.IsNullOrEmpty(Options.ModList))
            {
                Options.ModList = FixPathSlashes(Path.GetFullPath(Options.ModList));
                if (File.Exists(Options.ModList))
                {
                    var file = new StreamReader(Options.ModList);
                    string line, ext, mod, src;
                    Dictionary<string, bool> m = new Dictionary<string, bool>();
                    while ((line = file.ReadLine()) != null)
                    {
                        var split = line.Split(new[] { '?' }, 2);
                        if (split.Length == 2)
                        {
                            mod = FixPathSlashes(split[0]);
                            src = FixPathSlashes(split[1]);
                            FileFilter.Add(src);
                            ext = Path.GetExtension(src);
                            if (ext.Length > 1) ExtFilter.Add(ext.Substring(1));

                            SrcMod[src] =  mod;

                            if (!ModSrc.ContainsKey(src))
                                ModSrc.Add(src, new Dictionary<string, bool> { {mod , false} });
                            else
                              ModSrc[src].Add(mod, false);
                        }
                    }
                    file.Close();
                }
            }
            else if (!String.IsNullOrEmpty(Options.FilterList))
            {
                Options.FilterList = FixPathSlashes(Path.GetFullPath(Options.FilterList));
                if (File.Exists(Options.FilterList))
                {
                    var file = new StreamReader(Options.FilterList);
                    string line, ext;
                    while ((line = file.ReadLine()) != null)
                    {
                        FileFilter.Add(FixPathSlashes(line));
                        ext = Path.GetExtension(line);
                        if (ext.Length > 1) ExtFilter.Add(ext.Substring(1));
                    }
                    file.Close();
                }
                if (Options.PathFilter.Count > 0 || Options.ExtFilter.Count > 0)
                {
                     ExportFilter = true;
                }
            }

            if (Options.PathFilter.Count > 0)
            {
                foreach (string filter in Options.PathFilter.ToList())
                {
                    int index = Options.PathFilter.IndexOf(filter);
                    if (index != -1) Options.PathFilter[index] = FixPathSlashes(filter);
                }
            }

            var paths = new List<string>();

            if (Directory.Exists(Options.Input))
            {
                if (Path.GetExtension(Options.Output).ToLower() != ".vpk")
                {
                    Echo(String.Format("Input \"{0}\" is a directory while Output \"{1}\" is not a VPK.", Options.Input, Options.Output), ConsoleColor.Red);
                    return;
                }
                paths.AddRange(Directory.GetFiles(Options.Input, "*.*", Options.Recursive ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly));
                if (paths.Count == 0)
                {
                    Echo(String.Format("No such file \"{0}\" or directory is empty. Did you mean to include -r (recursive) parameter?", Options.Input), ConsoleColor.Red);
                    return;
                }
                WriteVPK(paths, false); // pak directory into output.vpk
            }
            else if (File.Exists(Options.Input))
            {
                if (Path.GetExtension(Options.Input).ToLower() != ".vpk")
                {
                    Echo(String.Format("Input \"{0}\" is not a VPK.", Options.Input), ConsoleColor.Red);
                    return;
                }
                paths.Add(Options.Input);
                if (Path.GetExtension(Options.Output).ToLower() != ".vpk")
                {
                    ReadVPK(Options.Input); // unpak input.vpk into output dir
                }
                else
                {
                    WriteVPK(paths, true); // mod input.vpk into output.vpk
                }
            }

            CurrentFile = 0;
            TotalFiles = paths.Count;
        }

        private static void ReadVPK(string path)
        {
            Echo(String.Format("--- Listing files in package \"{0}\"", path), ConsoleColor.Green);
            var sw = Stopwatch.StartNew();
            var package = new Package();
            try
            {
                package.Read(path);
            }
            catch (Exception e)
            {
                Echo(e.ToString(), ConsoleColor.Yellow);
            }

            if (Options.VerifyVPKChecksums)
            {
                try
                {
                    package.VerifyHashes();

                    Console.WriteLine("VPK verification succeeded");
                }
                catch (Exception)
                {
                    Echo("Failed to verify checksums and signature of given VPK:", ConsoleColor.Red);
                }
                return;
            }

            if (!String.IsNullOrEmpty(Options.Output) && !Options.OutputVPKDir)
            {
              //Console.WriteLine("--- Reading VPK files...");
                var manifestPath = string.Concat(path, ".manifest.txt");
                if (Options.CachedManifest && File.Exists(manifestPath))
                {
                    var file = new StreamReader(manifestPath);
                    string line;
                    while ((line = file.ReadLine()) != null)
                    {
                        var split = line.Split(new[] { ' ' }, 2);
                        if (split.Length == 2)
                        {
                            OldPakManifest.Add(split[1], uint.Parse(split[0]));
                        }
                    }
                    file.Close();
                }

                foreach (var type in package.Entries)
                {
                    if (ExtFilter.Count > 0 && !ExtFilter.Contains(type.Key))
                    {
                        continue;
                    }
                    else if (Options.ExtFilter.Count > 0 && !Options.ExtFilter.Contains(type.Key))
                    {
                        continue;
                    }
                    DumpVPK(package, type.Key);
                }

                if (Options.CachedManifest)
                {
                    using (var file = new StreamWriter(manifestPath))
                    {
                        foreach (var hash in OldPakManifest)
                        {
                            if (package.FindEntry(hash.Key) == null)
                            {
                                Console.WriteLine("\t{0} no longer exists in VPK", hash.Key);
                            }
                            file.WriteLine("{0} {1}", hash.Value, hash.Key);
                        }
                    }
                }
            }

            if (Options.OutputVPKDir)
            {
                foreach (var type in package.Entries)
                {
                    foreach (var file in type.Value)
                    {
                        Console.WriteLine(file);
                    }
                }
            }

            if (ExportFilter)
            {
                using (var filter = new StreamWriter(Options.FilterList))
                {
                    foreach (var type in package.Entries)
                    {
                        if (Options.ExtFilter.Count > 0 && !Options.ExtFilter.Contains(type.Key))
                        {
                            continue;
                        }
                        foreach (var file in type.Value)
                        {
                            var ListPath = FixPathSlashes(file.GetFullPath());
                            if (Options.PathFilter.Count > 0)
                            {
                                var found = false;
                                foreach (string pathfilter in Options.PathFilter)
                                {
                                    if (ListPath.StartsWith(pathfilter, StringComparison.Ordinal)) found = true;
                                }
                                if (!found) continue;
                            }
                            filter.WriteLine(ListPath);
                            if (!Options.Silent) Console.WriteLine(ListPath);
                        }
                    }
                }
            }

            sw.Stop();

            Echo(String.Format("--- Processed in {0}s", sw.Elapsed.TotalSeconds), ConsoleColor.Cyan);
        }

        private static void WriteVPK(List<string> paths, bool modding)
        {

            if (modding) Echo("--- Exporting filtered input", ConsoleColor.Green);
            else Echo("--- Paking input folder", ConsoleColor.Green);
            string dir = Options.Input;
            TotalFiles = paths.Count;
            var sw = Stopwatch.StartNew();
            Encoding iso = Encoding.GetEncoding("ISO-8859-1");
            Encoding utf = Encoding.UTF8;
            byte[] data = new byte[0];
            int Signature = 0x55AA1234;
            uint Version = 1;
            uint TreeSize = 0;
            uint HeaderSize = 4 * 3;
            var excluded = new List<string> { "zip", "reg", "rar", "msi", "exe", "dll", "com", "cmd", "bat", "vbs" };
            var tree = new Tree<string, string, string, byte[]>();
            var package = new Package();

            if (modding)
            {
                try
                {
                    package.Read(Options.Input);
                }
                catch (Exception e)
                {
                    Echo(e.ToString(), ConsoleColor.Yellow);
                }
                foreach (var type in package.Entries)
                {
                    if (ExtFilter.Count > 0 && !ExtFilter.Contains(type.Key))
                    {
                        continue;
                    }
                    else if (Options.ExtFilter.Count > 0 && !Options.ExtFilter.Contains(type.Key))
                    {
                        continue;
                    }

                    var entries = package.Entries[type.Key];

                    foreach (var file in entries)
                    {
                        var filePath = string.Format("{0}.{1}", file.FileName, file.TypeName);
                        if (file.DirectoryName.Length > 0)
                        {
                            filePath = Path.Combine(file.DirectoryName, filePath);
                        }
                        filePath = FixPathSlashes(filePath);

                        bool found = false;
                        if (FileFilter.Count > 0)
                        {
                            foreach (string filter in FileFilter)
                            {
                              //if (filePath.StartsWith(filter)) found = true;
                                if (filePath == filter) found = true;
                            }
                            if (!found) continue;
                        }
                        else if (Options.PathFilter.Count > 0)
                        {
                            foreach (string filter in Options.PathFilter)
                            {
                              if (filePath.StartsWith(filter, StringComparison.Ordinal)) found = true;
                            }
                            if (!found) continue;
                        }
                        string root = string.Empty;
                        var ext = file.TypeName; //Path.GetExtension(root).TrimStart('.');
                        if (ext == string.Empty)
                        {
                            ext = " ";
                            if (!Options.Silent) Echo("  missing extension!", ConsoleColor.Red);
                            //continue;
                        }
                        if (excluded.Contains(ext))
                        {
                            if (!Options.Silent) Echo("  illegal extension!", ConsoleColor.Red);
                            continue;
                        }
                        var filename = file.FileName; //Path.GetFileNameWithoutExtension(root);
                        if (filename == string.Empty)
                        {
                            filename = " ";
                            if (!Options.Silent) Echo("  missing name!", ConsoleColor.Red);
                            //continue;
                        }
                        var rel = file.DirectoryName; //Path.GetDirectoryName(root).Replace('\\', '/');

                        byte[] output;
                        package.ReadEntry(file, out output);

                        if (ModSrc.ContainsKey(filePath))
                        {
                            if (!Options.Silent) Console.WriteLine("MOD: {0}", filePath);
                            foreach (var m in ModSrc[filePath])
                            {
                                if (!Options.Silent) Console.WriteLine("   >>{0}", m);
                                filePath = m.Key;
                                ext = Path.GetExtension(m.Key).TrimStart('.');
                                filename = Path.GetFileNameWithoutExtension(m.Key);
                                rel = Path.GetDirectoryName(m.Key).Replace('\\', '/');
                                if (rel == string.Empty) {
                                    rel = " ";
                                }
                                if (!tree.ContainsKey(ext)) {
                                    tree[ext] = tree.New();
                                }
                                if (!tree[ext].ContainsKey(rel)) {
                                    tree[ext][rel] = tree[ext].New();
                                }
                                tree[ext][rel][filename] = output; //File.ReadAllBytes(path);
                            }
                        }
                        else
                        {
                            if (rel == string.Empty) {
                                rel = " ";
                            }
                            if (!tree.ContainsKey(ext)) {
                                tree[ext] = tree.New();
                            }
                            if (!tree[ext].ContainsKey(rel)) {
                                tree[ext][rel] = tree[ext].New();
                            }
                          //package.ReadEntry(file, out output);
                            tree[ext][rel][filename] = output; //File.ReadAllBytes(path);
                        }

                    }
                }

                // mod size optimization: replace res with zero-byte file if mod?src pair has src=".nix"
                string nix = ".nix";
                if (ModSrc.ContainsKey(nix))
                {
                    if (!Options.Silent) Console.WriteLine("MOD: {0}", ".nix [ 0-byte file ]");
                    foreach (var m in ModSrc[nix])
                    {
                        if (!Options.Silent) Console.WriteLine("   >>{0}", m);
                        var ext = Path.GetExtension(m.Key).TrimStart('.');
                        var filename = Path.GetFileNameWithoutExtension(m.Key);
                        var rel = Path.GetDirectoryName(m.Key).Replace('\\', '/');
                        if (rel == string.Empty) {
                            rel = " ";
                        }
                        if (!tree.ContainsKey(ext)) {
                            tree[ext] = tree.New();
                        }
                        if (!tree[ext].ContainsKey(rel)) {
                            tree[ext][rel] = tree[ext].New();
                        }
                        tree[ext][rel][filename] = new byte[0];
                    }
                }
            }
            
            // include pak01_dir subfolder (if it exists) for manual overrides when modding
            if (modding && Directory.Exists("pak01_dir"))
            {
                dir = "pak01_dir";
                paths = new List<string>();
                paths.AddRange(Directory.GetFiles(dir, "*.*", SearchOption.AllDirectories));
                if (paths.Count != 0)
                {
                   modding = false;
                }
            }

            if (!modding)
            {
                foreach (var path in paths)
                {
                    if (!Options.Silent) Console.WriteLine("[{0}/{1}] {2}", ++CurrentFile, TotalFiles, path);
                    byte[] latin = Encoding.Convert(utf, iso, utf.GetBytes(path.Substring(dir.Length+1)));
                    string root = iso.GetString(latin).ToLower();
                    var ext = Path.GetExtension(root).TrimStart('.');
                    if (ext == string.Empty)
                    {
                        ext = " ";
                        if (!Options.Silent) Echo("  missing extension!", ConsoleColor.Red);
                        //continue;
                    }
                    if (excluded.Contains(ext))
                    {
                        if (!Options.Silent) Echo("  illegal extension!", ConsoleColor.Red);
                        continue;
                    }
                    var filename = Path.GetFileNameWithoutExtension(root);
                    if (filename == string.Empty)
                    {
                        filename = " ";
                        if (!Options.Silent) Echo("  missing name!", ConsoleColor.Red);
                        //continue;
                    }
                    var rel = Path.GetDirectoryName(root).Replace('\\', '/');
                    if (rel == string.Empty) {
                        rel = " ";
                    }
                    if (!tree.ContainsKey(ext)) {
                        tree[ext] = tree.New();
                    }
                    if (!tree[ext].ContainsKey(rel)) {
                        tree[ext][rel] = tree[ext].New();
                    }
                    tree[ext][rel][filename] = File.ReadAllBytes(path);
                }
            }

            foreach (var ext in tree)
            {
                TreeSize += (uint)ext.Key.Length + 2;
              //Console.WriteLine("[ {0} ]",ext.Key);
                foreach (var relpath in tree[ext.Key]) {
                    TreeSize += (uint)relpath.Key.Length + 2;
                  //Console.WriteLine("[ --- {0}", relpath.Key);
                    foreach (var filename in tree[ext.Key][relpath.Key]) {
                        TreeSize += (uint)filename.Key.Length + 1 + 18;
                      //Console.WriteLine("[ --- : ---> {0}.{1}", filename.Key, ext.Key);
                    }
                }
            }
            TreeSize += 1;
            using (var input = new MemoryStream())
            {
                input.Write(BitConverter.GetBytes(Signature), 0, 4);
                input.Write(BitConverter.GetBytes(Version), 0, 4);
                input.Write(BitConverter.GetBytes(TreeSize), 0, 4);
                HeaderSize = (uint)input.Position;
                var data_offset = HeaderSize + TreeSize;
                foreach (var ext in tree) {
                  input.Write(Encoding.UTF8.GetBytes(ext.Key), 0, ext.Key.Length);
                  input.Write(new byte[] { 0x0 }, 0, 1);
                  foreach (var relpath in tree[ext.Key]) {
                    input.Write(Encoding.UTF8.GetBytes(relpath.Key), 0, relpath.Key.Length);
                    input.Write(new byte[] { 0x0 }, 0, 1);
                    foreach (var filename in tree[ext.Key][relpath.Key]) {
                      input.Write(Encoding.UTF8.GetBytes(filename.Key), 0, filename.Key.Length);
                      input.Write(new byte[] { 0x0 }, 0, 1);
                      var metadata_offset = (uint)input.Position;
                      var file_offset = data_offset;
                      uint checksum = 0;
                      input.Position = data_offset;
                      var file = tree[ext.Key][relpath.Key][filename.Key];
                    //if (modding) checksum = package.FindEntry(relpath.Key, filename.Key, ext.Key).CRC32;
                    //else checksum = Crc32.Compute(file);
                      checksum = Crc32.Compute(file);
                      input.Write(file, 0, file.Length);
                      data_offset = (uint)input.Position;
                      var file_length = data_offset - file_offset;
                      input.Position = metadata_offset;
                      input.Write(BitConverter.GetBytes(checksum & 0xFFffFFff), 0, 4);
                      input.Write(new byte[] { 0x0, 0x0 }, 0, 2);
                      input.Write(BitConverter.GetBytes(0x7fff), 0, 2);
                      input.Write(BitConverter.GetBytes(file_offset - TreeSize - HeaderSize), 0, 4);
                      input.Write(BitConverter.GetBytes(file_length), 0, 4);
                      input.Write(BitConverter.GetBytes(0xffff), 0, 2);
                    }
                    // next relpath
                    input.Write(new byte[] { 0x0 }, 0, 1);
                  }
                  // next ext
                  input.Write(new byte[] { 0x0 }, 0, 1);
                }
                // end of file tree
                input.Write(new byte[] { 0x0 }, 0, 1);
                data = input.ToArray();
            }
            DumpFile(Options.Output, data);
            sw.Stop();
            Echo(String.Format("--- Processed in {0}s", sw.Elapsed.TotalSeconds), ConsoleColor.Cyan);
        }

        private static void DumpVPK(Package package, string type)
        {
            var entries = package.Entries[type];

            foreach (var file in entries)
            {
                var filePath = string.Format("{0}.{1}", file.FileName, file.TypeName);

                if (!String.IsNullOrEmpty(file.DirectoryName))
                {
                    filePath = Path.Combine(file.DirectoryName, filePath);
                }

                filePath = FixPathSlashes(filePath);

                bool found = false;
                if (FileFilter.Count > 0)
                {
                    foreach (string filter in FileFilter)
                    {
                      if (filePath.StartsWith(filter, StringComparison.Ordinal)) found = true;
                    }
                    if (!found) continue;
                }
                else if (Options.PathFilter.Count > 0)
                {
                    foreach (string filter in Options.PathFilter)
                    {
                      if (filePath.StartsWith(filter, StringComparison.Ordinal)) found = true;
                    }
                    if (!found) continue;
                }

                if (!String.IsNullOrEmpty(Options.Output))
                {
                    uint oldCrc32;
                    if (Options.CachedManifest && OldPakManifest.TryGetValue(filePath, out oldCrc32) && oldCrc32 == file.CRC32)
                    {
                        continue;
                    }
                    OldPakManifest[filePath] = file.CRC32;
                }

                byte[] output;
                package.ReadEntry(file, out output);

                if (!String.IsNullOrEmpty(Options.Output))
                {
                    DumpFile(filePath, output);
                }
            }
        }

        private static void DumpFile(string path, byte[] data)
        {
            var outputFile = Path.Combine(Options.Output, path);
            Directory.CreateDirectory(Path.GetDirectoryName(outputFile));
            File.WriteAllBytes(outputFile, data);
            if (!Options.Silent) Console.WriteLine("--- Dump written to \"{0}\"", outputFile);
        }

        private static string FixPathSlashes(string path)
        {
            path = path.Replace('\\', '/');
//          if (Path.DirectorySeparatorChar != '/')
//          {
//              path = path.Replace('/', Path.DirectorySeparatorChar);
//          }
            return path;
        }

        public static void Echo(string msg, ConsoleColor clr)
        {
            lock (ConsoleWriterLock)
            {
                Console.ForegroundColor = clr;
                Console.Error.WriteLine(msg);
                Console.ResetColor();
            }
        }

    }
}

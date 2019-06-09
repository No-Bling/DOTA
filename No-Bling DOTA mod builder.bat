@goto init "No-Bling DOTA mod builder"
:: v2019.06.09: GL HF
:: - revised categories
:: - loadout and taunt animations support
:: - making use of VPKMOD tool for very fast in-memory processing with minimal file i/o
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
set/a Taunts=1                     &rem  1 = ceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeb
set/a Glance=1                     &rem  1 = gabening intensifies..

set/a @update=1                    &rem  1 = update script from github on launch,                 0 = stay on outdated script
set/a @refresh=0                   &rem  1 = remove old builds and logs,                          0 = keep old builds and logs
set/a @verbose=0                   &rem  1 = log detailed per-hero item lists ~8k small files,    0 = skip detailed item lists
::------------------------------------------------------------------------------------------------------------------------------
:: Extra script choices - not available in gui so set them here if needed
set/a @install=1                   &rem  1 = auto-install closes Dota and Steam,                  0 = can't add launch options!
set/a @timers=1                    &rem  1 = total and per tasks accurate timers,                 0 = no reason to disable them
set/a @dialog=1                    &rem  1 = show choices gui dialog,                             0 = use hardcoded values above
set "MOD_FILE=pak01_dir.vpk"       &rem  ? = override here if having multiple mods and needing another name like pak02_dir.vpk
set "all_choices=Hats,Couriers,Wards,Terrain,Abilities,Seasonal,AbiliTweak,HeroTweak,Menu,Taunts,Glance"
set "def_choices=Hats,Couriers,Wards,Terrain,Abilities,Seasonal,AbiliTweak,HeroTweak,Menu"
set "version=2019.06.09"

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
if not defined @update goto noupdate
set "URL=https://github.com/No-Bling/DOTA/raw/master"
set "URL=https://raw.githubusercontent.com/No-Bling/DOTA/master"
set "FILE=No-Bling DOTA mod builder"
:: Check online .version
set/a online=1 & set/a offline=%version:.=%+0
pushd "%~dp0" & del /f/q .version >nul 2>nul
powershell -noprofile -c "(new-object System.Net.WebClient).DownloadFile('%URL%/.version','%~dp0.version');" >nul 2>nul
if not exist .version certutil -URLCache -split -f "%URL%/.version" >nul 2>nul                   &REM naked Windows 7 workaround
if not exist .version goto noupdate                                                                          &REM still failed..
if exist .version for /f "tokens=1,2,3 delims=." %%i in ('type .version') do set/a online=%%i%%j%%k+0
if "%online%"=="20181224" reg delete "HKCU\Environment" /v "No-Bling choices" /f >nul 2>nul   &REM choices have to be reset once
if %offline% LSS %online% (set "outdated=1") else set "outdated=" & goto noupdate
:: Only download builder.zip if local script is outdated
pushd "%~dp0" & del /f/q "%FILE%.zip" >nul 2>nul
powershell -noprofile -c "(new-object System.Net.WebClient).DownloadFile('%URL%/%FILE%.zip','%~dp0%FILE%.zip');" >nul 2>nul
if not exist "%~dp0%FILE%.zip" certutil -URLCache -split -f "%URL%/%FILE%.zip" >nul 2>nul        &REM naked Windows 7 workaround
if not exist "%~dp0%FILE%.zip" goto noupdate                                                                 &REM still failed..
:: UnZip overwriting local files (except No-Bling-filters-personal.txt) and start the updated script
set "UNZIP=$s=new-object -com shell.application;foreach($i in $s.NameSpace($zip).items()){$s.Namespace($dir).copyhere($i,0x14)}"
set "UPDATE=$dir='%~dp0'; $zip='%~dp0%FILE%.zip'; %UNZIP%; start '%FILE%.bat'"
start powershell -noprofile -WindowStyle Hidden -c "%UPDATE%" &exit
::------------------------------------------------------------------------------------------------------------------------------
:noupdate

:: Check DOTA, tools and environment
pushd "%~dp0"
set "ROOT=%CD%"
set "MOD_FOLDER=dota_tempcontent" & set "MOD_OPTIONS=-tempcontent"
if not defined MOD_FILE set "MOD_FILE=pak01_dir.vpk"
call :set_steam & call :set_dota & call :set_tools

:: Check DOTA launch options
if defined STEAMDATA pushd "%STEAMDATA%\config" & if exist localconfig.vdf (
 for /f "delims=" %%a in ('cscript //E:JScript //nologo "%~dpn0.js" LOptions localconfig.vdf "_" -read') do set "LOPTIONS=%%a"
)

:: Patch Anticipation Station - quick and dirty check for new DOTA patch (no pointless particles extraction from vpk each run)
mkdir "%CONTENT%\no-bling" >nul 2>nul                              &REM Should be \steamapps\common\dota 2 beta\content\no-bling
for /f usebackq^ delims^=^"^ tokens^=4 %%a in (`findstr LastUpdated "%STEAMAPPS%\appmanifest_570.acf"`) do set/a "UPDATED=%%a+0"
pushd "%CONTENT%\no-bling" & set "NEWPATCH=" & set/a "LASTUPDATED=0" & if exist last_updated.bat call last_updated.bat
echo @set/a "LASTUPDATED=%UPDATED%" ^&exit/b>pas_updated.bat &if %UPDATED% GTR %LASTUPDATED% set "NEWPATCH=yes"
if not defined NEWPATCH ( call :color 03 " old patch " ) else call :color 0b " new patch " &rem set "@refresh=1"

:: Show dialog to pick choices
if defined @dialog call :choices MOD_CHOICES "%all_choices%" "%def_choices%" "No-Bling choices" 14 DarkRed Snow
:: Process dialog result
if defined @dialog if not defined MOD_CHOICES call :end ! No choices selected!
if not defined MOD_CHOICES set "MOD_CHOICES=%@choices%"
:: Force complementary particles options if (\_/) selected
set "gabening=%MOD_CHOICES:Glance=%"
if "%gabening%" NEQ "%MOD_CHOICES%" for %%o in (Hats,Couriers,Wards,Abilities) do call :unselect %%o MOD_CHOICES
if "%gabening%" NEQ "%MOD_CHOICES%" set "MOD_CHOICES=Hats,Couriers,Wards,Abilities,%MOD_CHOICES%"
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
echo  Content cache  = %CONTENT%\no-bling
echo  Script options = @update:%@update%  @refresh:%@refresh%  @verbose:%@verbose%  @install:%@install%  @dialog:%@dialog%
echo  Script version = v%version%  Online version = v%online%  -  https://github.com/No-Bling/DOTA
echo.

:: Prepare directories
call :color 0e " Preparing directories, please wait ... "
pushd "%ROOT%"
set "BUILDS=%CD%\BUILDS\%MOD_CHOICES:,=_%"
mkdir "%BUILDS%" >nul 2>nul & mkdir "%ROOT%\log" >nul 2>nul
set ".="%ROOT%\src" "%TEMP%\no-bling""
if defined @refresh set ".=%.% "%CONTENT%\no-bling" "%ROOT%\src" "%ROOT%\BUILDS""               &REM clear content only @refresh
if defined @refresh if defined @verbose set ".=%.%  "%ROOT%\log""              &REM clear ~8k log files each @verbose + @refresh
for %%i in (%.%) do ( del /f/s/q "%%~i" & rmdir /s/q "%%~i" & mkdir "%%~i" ) >nul 2>nul
call :clearline 3

%LABEL% " Extracting lists from dota\pak01_dir.vpk ... "
vpkmod -i "%DOTA%\dota\pak01_dir.vpk" -l "%ROOT%\src\particles.lst" -e "vpcf_c" -s >nul 2>nul
vpkmod -i "%DOTA%\dota\pak01_dir.vpk" -l "%ROOT%\src\models.lst" -e "vmdl_c" -s >nul 2>nul
vpkmod -i "%DOTA%\dota\pak01_dir.vpk" -l "%ROOT%\src\anim.lst" -e "vanim_c" -s >nul 2>nul
vpkmod -i "%DOTA%\dota\pak01_dir.vpk" -o "%ROOT%\src" -e "txt" -p "scripts/items/items_game.txt"
mkdir "%ROOT%\src\scripts\npc" >nul 2>nul
copy "%DOTA%\dota\scripts\npc\npc_heroes.txt" "%ROOT%\src\scripts\npc" >nul 2>nul
copy "%DOTA%\dota\scripts\npc\npc_units.txt" "%ROOT%\src\scripts\npc" >nul 2>nul

call :mcolor 70 " Processing items_game.txt and particles.lst ... " c0. " ETA: 10-60s "
if defined @verbose echo Writing per-hero / category slice logs and verbose no_bling.txt to log folder...
if defined @verbose ( set ".=>"%ROOT%\log\no_bling.txt"" ) else set ".= "
pushd "%ROOT%"
%TIMER%
%js_engine% No_Bling "%MOD_CHOICES%" "%@verbose%" "%@timers%" %.%
if defined MOD_CHOICES if not exist "%ROOT%\src\src.lst" %TIMER% & call :done ! Processing failed, src.lst missing..
:: Verify VDF parser
if defined @verbose pushd "%ROOT%\src\scripts\items" &echo n|comp items_game.txt "%ROOT%\log\items_game.txt" 2>nul
if defined @verbose call :clearline 1
:: Sort particle?mod definitions for each src category
pushd "%ROOT%\src" & for %%a in (*.ini src.lst) do sort "%%a" /o "%%a"
:: Show per category file count
set/a Other=1                                                             &REM forced category for stuff like particle snapshots
for %%a in ("%ROOT%\src\*.ini") do if defined %%~na (
 for /f "tokens=3" %%B in ('find /v /c "" "%%a" 2^>nul ^| find /i "%%a" 2^>nul') do call :color 0a " %%~na " & echo : %%B files
)
%TIMER%

:: Skip content if only @verbose was selected
if defined @verbose if not defined MOD_CHOICES echo.& %INFO%  No mod choices selected, just detailed logs exported & goto done

:: Update changed content cache
if defined @refresh del /f /q "%CONTENT%\no-bling\pak01_dir.vpk.manifest.txt" >nul 2>nul
pushd "%CONTENT%\no-bling"
if exist pas_updated.bat ( copy /y pas_updated.bat last_updated.bat & del /f /q pas_updated.bat ) >nul 2>nul

:: In-memory file replacement mod using nothing but unaltered Valve authored files (custom vpkmod tool exclusive feature)
call :mcolor 70 " Deploying selected No-Bling choices ... " c0. " ETA: 10-20s "
%TIMER%
vpkmod -i "%DOTA%\dota\pak01_dir.vpk" -o "%BUILDS%\pak01_dir.vpk" -m "%ROOT%\src\src.lst" -s
%TIMER%

:: Generate readme
pushd "%BUILDS%"
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
findstr /b /c:"log_verbosity AnimResource off" %autocfg% >nul || echo/log_verbosity AnimResource off ^| grep %%>>%autocfg%
:: End task to allow launch option adding
set "@endtask=" & tasklist /FI "IMAGENAME eq STEAM.EXE" | findstr /i "STEAM.EXE" >nul 2>nul && set "@endtask=1"
if defined @endtask call :color 0e " Press Alt+F4 to stop auto-install from closing Dota & Steam in 10s ..."
if defined @endtask timeout /t 10 >nul 2>nul
if defined @endtask call :clearline 3
::if defined @endtask taskkill /f /im dota2.exe /im steam.exe /t >nul 2>nul & timeout /t 2 >nul
:: Create the necessary mod folder and copy the current build of pak01_dir.vpk to it (2nd try)
mkdir "%DOTA%\%MOD_FOLDER%" >nul 2>nul
copy /y "%BUILDS%\pak01_dir.vpk" "%DOTA%\%MOD_FOLDER%\%MOD_FILE%" >nul 2>nul
copy /y "%BUILDS%\No-Bling DOTA mod readme.txt" "%DOTA%\%MOD_FOLDER%\" >nul 2>nul
:: Add launch options for Dota 2 directly in the config file [ does not update if Steam is running hence the @endtask option ]
if not defined STEAMDATA goto done
pushd "%STEAMDATA%\config" & copy /y localconfig.vdf localconfig.vdf.bak >nul
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
@echo off &setlocal &set "BackClr=0"&set "TextClr=7"&set "Columns=40" &set "Lines=120" &set "Buff=9999" &call :clearline 1 2>nul
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
if not "%1"=="init" ( start "init" "%~f0" init & exit/b ) else goto main                &REM " Self-restart or return to :main "

::------------------------------------------------------------------------------------------------------------------------------
:: Core functions
::------------------------------------------------------------------------------------------------------------------------------
:set_macros [OUTPUTS] %[BS]%=BackSpace %[CR]%=CarriageReturn %[GL]%=Glue/NonBreakingSpace %[DEL]%=DelChar %[DEL7]%=DelCharX7
pushd "%TEMP%" & echo=WSH.Echo(String.fromCharCode(160))>` & for /f %%# in ('cscript //E:JScript //nologo `') do set "[GL]=%%#"
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
ver | find "10." >nul & if errorlevel 1 (for /L %%i in (1,1,%1) do echo;%[TAB]%%[LINE7]%%[CLR]% & echo;%[TAB]%%[LINE7]% ) else (
for /l %%i in (1,1,%1) do <nul set/p "=![LINE]!" )
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
if not exist "%ROOT%\tools\*" call :end ! tools subfolder missing! Did you unpack the whole .zip package?
set "PATH=%PATH%;%ROOT%\tools\"
set "vpkmod="%ROOT%\tools\vpkmod.exe""
if not exist %vpkmod% call :end ! tools\vpkmod.exe missing! Did you unpack the whole .zip package?
set "nodejs="%ROOT%\tools\node.exe""
if not exist %nodejs% ( set "nodejs=" ) else pushd "%ROOT%\tools"
if defined nodejs for /f "delims=" %%i in ('node.exe -e process.execArgv[0] -p') do if not "%%i"=="-e" set "nodejs="
if defined nodejs set "js_engine=%nodejs% "%~dpn0.js"" & popd
if not defined nodejs set "js_engine="%WINDIR%\System32\cscript.exe" //E:JScript //nologo "%~dpn0.js""
exit/b

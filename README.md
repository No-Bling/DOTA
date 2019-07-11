## No-Bling DOTA "GlanceValue" restoration mod  
#### We all know where we are headed looking at the Immortals spam in the last three years...  

### Glance  
<table>  
  <tr>  
    <td><img src="https://i.imgur.com/ys2KKhM.png"></td>  
    <td><img src="https://i.imgur.com/JShyXKs.png"></td>  
  </tr>  
  <tr>  
    <td><img src="https://i.imgur.com/yeN2UfR.png"></td>  
    <td><img src="https://i.imgur.com/JtihgLz.png"></td>  
  </tr>  
</table>  

### About  
A competent companion to *Settings -- Video -- Effects Quality* with the main focus on GlanceValue.  
No-Bling<sup>tm</sup> mod is economy-friendly, gracefully disabling particle spam while leaving hats model untouched.  
Might say it even helps differentiate great artistic work, shadowed by the particle effects galore Valve slaps on top.  

#### Before you ask about VAC:  
Don't worry, this is a perfectly safe, well intended, hats friendly, good behaviour cosmetic-only mod,  
optimally swapping just original Valve authored files with no 3^rd party content alteration whatsoever,  
and whitelist-able at a glance...  

#### What's new in v2019.07.11:  Treasure III when?  
~ revised categories  
~ loadout and taunt animations support  
~ BAT: __making use of in-house VPKMOD tool for very fast in-memory processing with minimal file i/o__  
~ BAT: auto-update script from github on launch  
~ BAT: language independent mod launch option `-tempcontent` with `dota_tempcontent` mod root folder  
~ JS: decoupled manual filters into *No-Bling-filters.txt*  
~ JS: output unified `src.lst` for in-memory modding via VPKMOD tool  

### [No-Bling DOTA mod builder.bat](https://github.com/No-Bling/DOTA/blob/master/No-Bling%20DOTA%20mod%20builder.zip) available!  
1. Download latest `No-Bling DOTA mod builder.zip`, unpack all files, run the included batch script, select build choices  
   Builder script features auto-updating from github on launch so no further manual downloads and unpacking is needed!  
2. Profit! It will create a custom build in the proper location, and add the now simplified launch options automatically!  
*Tested on Windows 7 & 10 (x86 & x64). Does not need Workshop Tools DLC installed.*  

#### No-Bling DOTA mod builder choices:  
Category       | GlanceValue | Description                                                              | Pre-made as:  
-------------- | ----------- | ------------------------------------------------------------------------ | ----------  
Hats           | **++++**    | - Workshop Hats: cosmetic particles spam - slowly turning into TF2..     |   CORE BUILD  
Couriers       | **+++**     | - Custom Couriers: these are fine.. until ~~Fy~~ someone abuses gems on hats |  
Wards          | **++**      | - Custom Wards: only a few make the ward and the sentry item similar     |  
Terrain        | **++**      | - tweak ancients, towers, effigies, shrines, bundled weather             |  
.            . | .         . | .                                                                      . | .       .  
Abilities      | **+++++**   | - Custom Spells: penguin Frostbite and stuff like that..                 |   MAIN BUILD  
Seasonal       | **+++**     | - Event Rewards: the International custom tp, blink etc.                 |  
.            . | .         . | .                                                                      . | .       .  
AbiliTweak     | **++++**    | - revert Rubick Arcana stolen spells, trim effects                       |   FULL BUILD  
HeroTweak      | **+/-**     | - Default Hats: hero-bundled effects  - helps potato pc                  |  
Menu           | **+**       | - Menu - ui, hero loadout and preview, treasure opening                  |  
Taunts         | **++**      | - ceeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeb and dota+                       |  
Glance         | **+++++++** | - (\\_/) gabening intensifies..                                          |  
.            . | .         . | .                                                                      . | .      .  
*@update*      |             | *auto-update script from github - can be skipped*                        |  
*@verbose*     |             | *print file names and export detailed per-hero item lists*               |  
*@endtask*     |             | *auto-install closes Dota and Steam - needed once to add launch options* |  
*@refresh*     |             | *refresh lastupdated and clear mod directories - usually not needed*     |  

*choices are remembered between runs.*  

#### DOTA Updates  
- Simply run the builder script again, it will detect any updates and force a refresh - it only takes a minute or two  
- New patch detection is generally reliable. If having any issues, select *@refresh* choice to force local cache update  

#### Troubleshooting builder batch script issues  
~ Right-click and run the script as administrator to overcome `Program Files\Steam` permission issues.  
~ Script generally works on a default Windows 7 install without needing extra .net framework libraries.  
~ Try to recompile the vpkmod.exe utility via `tools\build vpkmod.zip` - .bat / .sln provided for .net 3.5+ / VS2008+.  

#### What about Linux or Mac / issues with the builder batch script?  
Use the pre-made releases in the __[BUILDS](https://github.com/No-Bling/DOTA/tree/master/BUILDS)__ folder via manual install  

#### How to manually install No-Bling DOTA mod builds in 2019:  
   ~ CREATE FOLDER `\steamapps\common\dota 2 beta\game\dota_tempcontent`  
   ~ COPY `pak01_dir.vpk` IN `\steamapps\common\dota 2 beta\game\dota_tempcontent`  
   ~ ADD LAUNCH OPTION: `-tempcontent`  

#### How to quickly restore default particle spam DOTA?  
Simply remove / rename the `-tempcontent` launch option and restart the game!  

### Hints:  
If using manual install, supress AnimResource warnings by adding to your autoexec.cfg: `log_verbosity AnimResource off | grep %`  
It is recommended to set _Effects Quality_ option to _Low_ for Potato PC's as it decreases the nr of particles for certain spells  

Manual filters have been decoupled from the .js script into `No-Bling-filters.txt`  
_To auto-update script without overwriting changes, make a `No-Bling-filters-personal.txt` copy and edit that instead!_  
These suppliment _items_game.txt_ auto-replacing rules with per category file replacement vdf modifier-asset pairs:  

Modifier     | Asset or wildcard | Description  
------------ | ----------------- | -----------  
"path/file1" | "path/file2"      | replace "file1" modifier with "file2" asset from dota/pak01_dir.vpk  
"path/file"  | "+"               | replace "file" with empty-asset _(short for "particles/dev/empty_particle.vpcf")_  
"path/file"  | "++"              | replace all modifiers having asset "file" with empty-asset (reverse lookup)  
"path/file"  | "-"               | keep "file" _(i.e. remove "file" from auto-generated lists)_  
"path/file"  | "--"              | keep all modifiers having asset "file" (reverse-lookup)  
"meepo"      | "@"               | keep all modifiers having hero "hero"  
"8958"       | "#"               | keep all modifiers having item id "number"  
"arcana"     | "$"               | keep all modifiers having rarity "rarity"  

__How can I manually allow certain effects, like a Halo on Omni's Crown of Sacred Light?__ question from /u/malistev:  
Run the script once with the __@verbose__ choice, as it will generate a log folder with all/most items by category.  
File explorer to `\log\Wearables\omniknight` - it should contain _Crown_of_Sacred_Light_8958_head.txt_  
Number represents the __id__, that you can add in `No-Bling-filters.txt` file after the _"Hats"_ and  _{_ lines:  
`"8958" "#"`  
Most immortals have multiple effects (not the case here). To keep specific ones you can read the log file above  
and look for _"modifier" "particles/ ... .vpcf"_ entries, then add them as specific filters:  
`"particles/econ/items/omniknight/omni_sacred_light_head/omni_ambient_sacred_light.vpcf" "-"`  
Not all specific effects are mentioned in `items_game.txt` so you might need to identify the involved particles in-game,  
by demo-ing the item, opening console, and list particles with:  
`clear;cl_particle_log_creates 1;dumpparticlelist | grep [^0\s][\d]*,[\s]flags;`  
Also check `log\no_bling.txt` as it shows some of the logic in categorizing, as well as `src\src.lst` and `.ini` files.  

### The future  
Small steps towards multi-platform support, but don't ask for ETA..  

Published under [MIT](LICENSE) license.  

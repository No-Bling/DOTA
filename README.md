## No-Bling DOTA "GlanceValue" restoration mod  
#### We all know where we are headed looking at the Immortals spam in the last two years...  
  
### Glance  
<table>  
	<tr>  
		<td><img src="https://i.imgur.com/ys2KKhM.png"></td>  	
		<td><img src="https://i.imgur.com/JShyXKs.png"></td>  
	</tr>  
	<tr>  
		<td><img src="https://i.imgur.com/yeN2UfR.png"></td>  
		<td><img src="https://i.imgur.com/kUIQ7Jh.png"></td>  
	</tr>  
</table>  
  
### About  
A competent companion to *Settings -- Video -- Effects Quality* with the main focus on GlanceValue.  
No-Bling<sup>tm</sup> mod is economy-friendly, gracefully disabling particle spam while leaving hats model untouched.  
Might say it even helps differentiate great artistic work, shadowed by the particle effects galore Valve slaps on top.  
  
### Before you ask about VAC:  
Don't worry, this is a perfectly safe, well intended, hats friendly, good behaviour particles-only mod,  
optimally swapping just original files with no content alteration whatsoever, and whitelist-able at a glance...  
  
### [No-Bling DOTA mod builder.bat](https://github.com/No-Bling/DOTA/blob/master/No-Bling%20DOTA%20mod%20builder.zip) released!  
1. Download latest `No-Bling DOTA mod builder.zip`, unpack all files, run the included batch script, select build choices  
2. Profit! It will create a custom build in the proper location, and add the now complicated launch options automatically!  
*Tested on Windows 7 & 10 x64. Does not need Workshop Tools DLC installed.*  
  
### No-Bling DOTA mod builder choices:  
Category       | GlanceValue | Description                                                              | FPS Gain  
-------------- | ----------- | ------------------------------------------------------------------------ | ----------  
Abilities      | **+++++**   | Custom Spells: penguin Frostbite and stuff like that..                   |  Low  
Hats           | **+++**     | Workshop Hats: cosmetic particles spam - slowly turning into TF2..       |   
Couriers       | **+++**     | Custom Couriers: these are fine.. until  ̶F̶y̶ someone abuses gems on hats   |  
Wards          | **++**      | Custom Wards: only a few make the ward and the sentry item similar       |  
Seasonal       | **++++**    | Event Rewards: the International 7 custom tp, blink, contest towers      |  
.            . | .         . | .                                                                      . | .       .  
HEROES         | **-**       | Default Heroes: model particles, helps potato pc, glancevalue can drop   |  Medium  
.            . | .         . | .                                                                      . | .       .  
Base           | **++**      | Tweak map base buildings - ancients, barracks, towers                    |  
Effigies       | **+++**     | Tweak map effigies                                                       |  
Shrines        | **+**       | Tweak map shrines v2                                                     |  
Props          | **+**       | Tweak map props - fountains, terrain-bundled weather                     |  
Menu           | **+**       | Tweak main menu - ui, hero preview                                       |  High  
.            . | .         . | .                                                                      . | .       .  
*@verbose*     |             | *print file names and export detailed per-hero item lists*               |  
*@endtask*     |             | *auto-install closes Dota and Steam - needed once to add launch options* |  
*@refresh*     |             | *recompile mod instead of reusing cached files - usually not needed*     | *dynamic*  
  
*@refresh is shown only if a new patch is detected or source file is missing; choices are remembered between runs.*  
  
### DOTA Updates  
- Simply run the builder script again, it will detect any updates and force a refresh - it only takes a minute or two  
- A local cache will be created directly from game files so repeated runs are very fast!  
- New patch detection is generally reliable. If having any issues, select *@refresh* choice to force local cache update  

### Troubleshooting builder batch script issues  
~ Right-click and run the script as administrator to overcome `Program Files\Steam` permission issues.  
~ Script generally works on a default Windows 7 install without needing extra libraries but you might be missing some.  
Try to launch manually the Decompiler.exe utility from `tools\ValveResourceFormat` - it should ask for any needed libs.  

## What about non-Windows OS / issues with the builder batch script?  
Use the pre-made releases in the [BUILDS](https://github.com/No-Bling/DOTA/tree/master/BUILDS) folder via manual install  
  
## How to manually install the .vpk builds after 7.07:  
   Instructions for English language (default)  
   ~ CREATE FOLDER `\steamapps\common\dota 2 beta\game\dota_english%`  
   ~ COPY `pak01_dir.vpk` IN `\steamapps\common\dota 2 beta\game\dota_english%`  
   ~ ADD LAUNCH OPTIONS: `-language english% -textlanguage english +cl_language english`  
   Yes there is a percent sign after `english` as a workaround to keep feed updates  
  
   Instructions for Russian language (same steps for Koreana and Schinese)  
   IF NOT EXISTS `\steamapps\common\dota 2 beta\game\dota_russian\pak01_dir.vpk`  
   ~ COPY `pak01_dir.vpk` IN `\steamapps\common\dota 2 beta\game\dota_russian`  
   IF EXISTS `\steamapps\common\dota 2 beta\game\dota_russian\pak01_dir.vpk`  
   ~ RENAME `pak01_dir.vpk` TO `pak02_dir.vpk`  
   ~ MOVE `pak02_dir.vpk` TO `dota_russian\`  
   ~ ADD LAUNCH OPTION: `-language russian`  
  
   Instructions for German language (same steps for French, Spanish and others)  
   ~ COPY `pak01_dir.vpk` IN `\steamapps\common\dota 2 beta\game\dota_german`  
   ~ ADD LAUNCH OPTION: `-language german`  
  
### How to quickly restore default particle spam DOTA?  
Simply remove / rename the `-language x` launch option and restart the game!  
  
### Hints:  
It's recommended to set Effects Quality option to Low for Potato PC's as it decreases the nr of particles for certain spells  
Before reporting bugs, list particles in game console: `clear;dumpparticlelist | grep [^0\s][\d]*,[\s]flags;condump`  
then share the exported list from: `\Steam\steamapps\common\dota 2 beta\game\dota\condump0XX.txt`  
  
### What's new in v7.16:  
~ Add support for persistent language override. To define it, open a command prompt and enter: `setx NOBLING_LANGUAGE english`  
~ Add Menu filter for TI8 ui rays  

~ Keep filter applies to all categories, not just abilities heroes and hats  
~ Update ACTIVE_EVENT and re-enable expired TI7 effects  
~ Prevent STEAMPATH detection possible issue

~ Pudge Arcana made less underwhelming via manual filter  
~ Fixed unable to run script caused by multiple downloaded copies auto-renamed by windows and default extract (r2)  
~ Bumped version from v2.0 final to match game patch. Mod will use r1, r2 .. for revision numbers.  
~ Faster, more reliable, improved caching, less storage operations, long paths support, auto-install with current language  
~ Press Enter to accept No-Bling choices dialog, integrated endtask choice, clearline working in both Windows 7 and 10  
~ Seasonal category reinstated, as it's still useful for TI7 replays despite event being expired  
~ Extended manual filters to make certain items like arcana's less underwhelming, fix Gyro's call down Valve bug  
~ New Tweaks category - split into subcategories for more fine-tuning - effigies support, proper shrines, filtered portraits  
~ More reliable Dota_LOptions function and consistent verbose output in both Node.js and JScript engines  
~ Add emblem (previously called relic), re-enable expired TI7 Effects for event replays viewing  
  
## What happened in 7.07?  
__Valve removed -LV launch option. Looking at backend code, there might be some internal refactoring.__  
Other client-side modding methods were unaffected, so No-Bling switched to the `-language` method.  
No point on doing resource-compiling if `m_hLowViolenceDef` is unavailable, so that part is dumbed-down to file-replacing.  
Launch options gets complicated as it's language-dependant, unlike convenient, unified, stand-alone `-LV` _( RIP 2017-11-1 )_  
Working test builds using the `-language` method have been updated, while the script was pending a more in-dept rework.  
Months later, no sign of Valve working further on that refactoring - to be expected, really.  
  
## The future  
Integration with the GUI Effects Quality is technically possible. Valve is also slowly extending it to more spells.  
The Low, Med, High options could toggle 3 associated No-Bling choices, right from the Settings menu!  
But after the -LV unwarranted removal, it's better to save energy and keep using dumbed-down file-replacing.  
So you might notice more spewing about particles in the game console - it's safe to ignore.  
Do try to create github Issue tickets / contact on reddit about unintended visual bugs..  
  
Published under [MIT](LICENSE) license.  
  

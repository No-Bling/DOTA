## No-Bling DOTA "GlanceValue" restoration mod v2 
#### We all know where we are headed looking at the Immortals spam in the last two years...  
  
### Glance  
<table>  
	<tr>  
		<td><img src="http://i.imgur.com/QhB7BkT.jpg"></td>  
		<td><img src="http://i.imgur.com/hr0lFC4.jpg"></td>  
	</tr>  
	<tr>  
		<td><img src="http://i.imgur.com/kUIQ7Jh.png"></td>  
		<td><img src="http://i.imgur.com/JShyXKs.png"></td>  
	</tr>  
</table>  
  
## About  
A competent companion to *Settings -- Video -- Effects Quality* with the main focus on GlanceValue.  
No-Bling<sup>tm</sup> mod is economy-friendly, gracefully disabling particle spam while leaving hats model untouched.  
Might say it even helps differentiate great artistic work, shadowed by the particle effects galore Valve slaps on top.  

### Check the [BUILDS](https://github.com/No-Bling/DOTA/tree/master/BUILDS) folder for pre-made versions 

### How to manually install the .vpk / .zip builds after 7.07?  
   Instructions for English language (default)  
   ~ CREATE FOLDER `\steamapps\common\dota 2 beta\game\dota_english%`  
   ~ COPY/UNZIP `pak01_dir.vpk` IN `\steamapps\common\dota 2 beta\game\dota_english%`  
   ~ ADD LAUNCH OPTIONS: `-language english% -textlanguage english +cl_language english`  
   Yes there is a percent sign after `english` as a workaround to keep feed updates  
    
   Instructions for Russian language (same steps for Koreana and Schinese)  
   IF NOT EXISTS `\steamapps\common\dota 2 beta\game\dota_russian\pak01_dir.vpk`  
   ~ COPY/UNZIP `pak01_dir.vpk` IN `\steamapps\common\dota 2 beta\game\dota_russian`  
   IF EXISTS `\steamapps\common\dota 2 beta\game\dota_russian\pak01_dir.vpk`  
   ~ RENAME `pak01_dir.vpk` TO `pak02_dir.vpk`  
   ~ MOVE `pak02_dir.vpk` TO `dota_russian\`  
   ~ ADD LAUNCH OPTION: `-language russian`  
    
   Instructions for German language (same steps for French, Spanish and others)  
   ~ COPY/UNZIP `pak01_dir.vpk` IN `\steamapps\common\dota 2 beta\game\dota_german`  
   ~ ADD LAUNCH OPTION: `-language german`  
  
### How to quickly restore default particle spam DOTA?  
Simply remove / rename the launch options!  
  
### Before you ask about VAC:  
Don't worry, this is a perfectly safe, well intended, hats friendly, good behaviour particles-only mod,  
ingeniously and optimally using ̶t̶h̶e̶ ̶b̶u̶i̶l̶t̶-̶i̶n̶ ̶L̶o̶w̶V̶i̶o̶l̶e̶n̶c̶e̶ ̶i̶n̶t̶e̶r̶f̶a̶c̶e̶  file-replacement, and whitelist-able at a glance...  
  
## [No-Bling DOTA mod builder.bat](https://github.com/No-Bling/DOTA/blob/master/No-Bling%20DOTA%20mod%20builder.zip) released!  
1. Download `No-Bling DOTA mod builder.zip`, unpack all files, run the included batch script, select build choices  
2. Profit! It will create a custom build in the proper location, and add the now complicated launch options automatically! 
*Tested on Windows 7 & 10 x64. Does not need Workshop Tools DLC installed.*  
  
### No-Bling DOTA mod builder choices:  
Category       | GlanceValue | Description                                                              | Note  
-------------- | ----------- | ------------------------------------------------------------------------ | ----------  
Abilities      | **+++++**   | Custom Spells: penguin Frostbite and stuff like that..                   |  Low  
Hats           | **+++**     | Workshop Hats: cosmetic particles spam - slowly turning into TF2..       |  ..  
Couriers       | **+++**     | Custom Couriers: these are fine.. until someone abuses gems on hats      |  ..  
Wards          | **++**      | Custom Wards: only a few make the ward and the sentry item similar       |  ..  
Seasonal       | **++++**    | Event Rewards: the International 7 custom tp, blink etc.                 |  ..  
Heroes         | **-**       | Default Heroes: model particles, helps potato pc, glancevalue can drop   |  Medium  
Tweaks         | **+**       | Optimizations for potato pc: map buildings and lights, portraits         |  High  
:            : | :         : | :                                                                      : | :       :  
Towers         | +           | Penis Contest: just the tower particle effects, models remain unchanged  | expired  
Soundboard     | bonus       | Chatwheel Sounds: silence the annoying chatwheel sounds                  | expired  
-LowViolence   | +++         | Restore Blood: undo -lv launch option turning all blood into alien green | RIP  
*@verbose*     |             | *print file names and export detailed per-hero item lists*               |  
*@refresh*     |             | *recompile mod instead of reusing cached files - usually not needed*     | **dynamic**  
  
*@refresh is shown only if a new patch is detected or source file is missing; choices are remembered between runs.*  
  
## DOTA Updates  
- Simply run the builder script again, it will detect any updates and force a refresh - it only takes a minute or two  
- A local cache will be created directly from game files so repeated runs are very fast!  
- New patch detection is generally reliable. If having any issues, select *@refresh* choice to force local cache update   
  
### Notes:  
It's recommended to set Effects Quality option to Low for potato pc's as it decreases the nr of particles for certain spells  
  
## What happened in 7.07?  
#### Valve removed -LV launch option. Looking at backend code, there might be some internal refactoring.  
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
  

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
		<td><img src="https://i.imgur.com/JtihgLz.png"></td>  
	</tr>  
</table>  
  
### About  
A competent companion to *Settings -- Video -- Effects Quality* with the main focus on GlanceValue.  
No-Bling<sup>tm</sup> mod is economy-friendly, gracefully disabling particle spam while leaving hats model untouched.  
Might say it even helps differentiate great artistic work, shadowed by the particle effects galore Valve slaps on top.  

### Before you ask about VAC:  
Don't worry, this is a perfectly safe, well intended, hats friendly, good behaviour particles-only mod,  
optimally swapping just original Valve authored files with no content alteration whatsoever,  
and whitelist-able at a glance...  

### What's new in v2018.12.20:  
Batch script:  
~ Language independent mod launch option `-tempcontent` with `dota_tempcontent` mod root folder    
~ Minimal file io - only extract and cache the specific source files defined in `src.lst`  
JS script:
~ Generate unified src.lst for streamlined content update   
~ Revert Rubick Arcana custom abilities if using the HEROES option
~ Potato-optimized, less distracting FrostHaven supplies; enable via Props and Menu choices    
  
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
  
## How to manually install No-Bling DOTA mod builds in 2019:  
   ~ CREATE FOLDER `\steamapps\common\dota 2 beta\game\dota_tempcontent`  
   ~ COPY `pak01_dir.vpk` IN `\steamapps\common\dota 2 beta\game\dota_tempcontent`  
   ~ ADD LAUNCH OPTION: `-tempcontent`  
  
### How to quickly restore default particle spam DOTA?  
Simply remove / rename the `-tempcontent` launch option and restart the game!  
 
### Hints:  
It's recommended to set Effects Quality option to Low for Potato PC's as it decreases the nr of particles for certain spells  
Before reporting bugs, list particles in game console: `clear;dumpparticlelist | grep [^0\s][\d]*,[\s]flags;condump`  
then share the exported list from: `\Steam\steamapps\common\dota 2 beta\game\dota\condump0XX.txt`  
  
Question from /u/malistev: __How can I manually allow certain effects, like a Halo on Omni's Crown of Sacred Light?__  
There are several ways to help you add your own manual filters. If you read the code, it supports both item-wide filter (by number = id) and specific particle effects filters. For both it's easier to just run the script once with the __@verbose__ additional choice, as it will generate a log folder with all/most items involved, separated into categories.  
For this inquiry, it would be `-noblingscriptfolder-\log\Wearables\omniknight`. Atm it would contain _Adoring_Wingfall_7580.txt, Paragons_Rebuke_9748_head.txt and Crown_of_Sacred_Light_8958_head.txt_. The number represents the __id__, that you can add in the manual filters section from `No-Bling DOTA mod builder.js` _(beginning of file, there will be a list by hero name with all the manual filters)._ More exactly, add the following line after the _/* OMNIKNIGHT */_ entry (~script line 316):  
`KEEP_ITEM[8958]=0;` _// keep omni halo (number after equal sign does not matter)_  
Since most immortals have multiple effects (not the case here), to keep specific effects you can read the _Crown_of_Sacred_Light_8958_head.txt_ file and look for _"modifier" "particles/ ... .vpcf"_ entries, then add them as specific filters:  
`KEEP['particles/econ/items/omniknight/omni_sacred_light_head/omni_ambient_sacred_light.vpcf']=0;`  
Some stuff won't be available in the log folder because it's not part of items_game.txt, in that case, you identify the particles involved in-game, by demo-ing the respective item, opening in-game console, and list particles in game console as mentioned above under Hints. Also check out `log\no_bling.txt` as it shows some of the logic in categorizing, and the generated build readme.txt.  

## The future  
Small steps towards multi-platform support, but don't ask for ETA..  
  
Published under [MIT](LICENSE) license.  
  

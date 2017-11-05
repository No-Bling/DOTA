## What happened in 7.07?  
#### Valve removed -LV launch option. Looking at backend code, there might be some internal refactoring.  

Other client-side modding methods are unaffected, so No-Bling will use the `-language` method.  
No point on doing resource-compiling if `m_hLowViolenceDef` is unavailable, so that part is dumbed-down to file-replacing.  
Launch options gets complicated as it's language-dependant, unlike convenient, unified, stand-alone `-LV` _( RIP 2017-11-1 )_

Working test builds using the `-language` method have been updated, while the script is pending a more in-dept rework.  
Instructions below.

---

## No-Bling DOTA "GlanceValue" restoration mod  
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
A competent alternative to *Settings -- Video -- Effects Quality* with the main focus on GlanceValue.  
No-Bling<sup>tm</sup> mod is economy-friendly, gracefully disabling particle spam while leaving hats model untouched.  
Might say it even helps differentiate great artistic work, shadowed by the particle effects galore Valve slaps on top.  
  
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
ingeniously and optimally using the built-in LowViolence interface, and whitelist-able at a glance...  
  
## No-Bling DOTA mod builder.bat released!  
1. Download `No-Bling DOTA mod builder.zip`, unpack all files, run the included batch script, select build choices  
2. Profit!  
*Requires Windows x64. Does not need Workshop Tools DLC installed*~~, but runs better / faster / more reliable if you have it.~~  
  
### No-Bling DOTA mod builder choices:  
Category       | GlanceValue | Description                                                              | Note  
-------------- | ----------- | ------------------------------------------------------------------------ | ----------  
-LowViolence   | **+++**     | Restore Blood: undo -lv launch option turning all blood into alien green | **RIP**  
Events         | **++++**    | Event Rewards: the International 7 custom tp, blink etc.                 |  
Spells         | **+++++**   | Custom Spells: penguin Frostbite and stuff like that..                   |  
Hats           | **+++**     | Workshop Hats: cosmetic particles spam - slowly turning into TF2..       |  
Heroes!        | **-**       | Default Heroes: model particles, helps potato pc, glancevalue can drop   | **care!**  
Wards          | **++**      | Custom Wards: only a few make the ward and the sentry item similar       |  
Couriers       | **+++**     | Custom Couriers: these are fine.. until a dumber abuses gems on hats     | 
Towers         | **+**       | Penis Contest: just the tower particle effects, models remain unchanged  | **expired** 
Soundboard     | **bonus**   | Chatwheel Sounds: silence the annoying chatwheel sounds                  | **expired**
*@verbose*     |             | *print file names and export detailed per-hero item lists*               |  
*@refresh*     |             | *recompile mod instead of reusing cached files - usually not needed*     | **dynamic**  
  
*@refresh is shown only if a new patch is detected or source files missing; choices are remembered between runs.*  
  
## DOTA Updates  
~~With Workshop Tools DLC:~~  
- Simply run the builder script again to refresh the mod after major patches - it only takes a minute or two  
  
~~Without Workshop Tools DLC:~~  
- Builder script creates a local cache directly from game files that gets outdated - simply select @refresh choice  
  
### Notes:  
~~Due to -lv (lowviolence) being used, you might want to add to your autoexec.cfg:~~~  
~~violence_ablood 1; violence_agibs 1; violence_hblood 1; violence_hgibs 1;~~  
 
Published under [MIT](LICENSE) license.  
  

## No-Bling DOTA "GlanceValue" restoration mod  
#### We all know where we are headed looking at the Immortals spam in the last four years...  

### Glance  
<table>  
  <tr>  
    <td><img src="https://i.imgur.com/yeN2UfR.png"></td>  
    <td><img src="https://i.imgur.com/crjotHs.png"></td>  
  </tr>  
  <tr>  
    <td><img src="https://i.imgur.com/JShyXKs.png"></td>  
    <td><img src="https://i.imgur.com/vT1ihiw.png"></td>  
  </tr>  
</table>  

### About  
A competent companion to *Settings -- Video -- Effects Quality* with the main focus on GlanceValue.  
No-Bling<sup>tm</sup> mod is economy-friendly, gracefully disabling particle spam while leaving hats model untouched _by default_.  
Might say it even helps differentiate great artistic work, shadowed by the particle effects galore Valve slaps on top.  

#### Before you ask about VAC:  
Don't worry, this is a perfectly safe, well intended, hats friendly, good behaviour cosmetic-only mod,  
optimally swapping just original Valve authored files with no 3^rd party content alteration whatsoever,  
and whitelist-able at a glance...  

### How to use  
Get the repository as zip, unpack all files, run the `No-Bling-builder.bat` script on Windows or `No-Bling-builder.sh` on Linux.  
Then add launch option `-tempcontent` if not already present.  
Remember to run the script before launching DOTA to have an always up to date mod generated and prevent schema mismatch errors.  
For convenience, a desktop shortcut is created to run the builder quicker, without compiling and with previous choices selected.  

### Back in Beta  
Choices are a work in progress - not as feature-rich and complete as the old script, but we will get there..  
Filters on the other hand are more complex and useful.  

#### Getting started with user filters  
Script uses a rather block first, white-list later aproach, so various issues need to be corrected via hard-coded filters.  
Advanced users can define extra exceptions in a `No-Bling-filters.txt` file with the following vdf key-value format:  
```
"user-filters"
{
  // keep
  keep_rarity    "legendary,ancient"
  keep_slot      "head,voice"
  keep_hero      "npc_dota_hero_crystal_maiden,npc_dota_rattletrap_cog"
  keep_item      "12930,13456,12,38"
  keep_model     "4004,6054"
  keep_visuals   "4004"
  keep_ability   "7927"
  keep_ambient   "6694"

  // replace
  38 7385
  12 {
    "model_player"    "models/items/kunkka/kunkka_shadow_blade/kunkka_shadow_blade.vmdl"
    "visuals"
    {
      "asset_modifier0"
      {
        "type"    "particle"
        "asset"   "particles/units/heroes/hero_kunkka/kunkka_weapon_glow_ambient.vpcf"
        "modifier"    "particles/econ/items/kunkka/kunkka_weapon_shadow/kunkka_weapon_glow_shadow_ambient.vpcf"
      }
      "asset_modifier3"
      {
        "type"    "particle_create"
        "modifier"    "particles/units/heroes/hero_kunkka/kunkka_weapon_glow_ambient.vpcf"
      }
    }
  }
  246 { visuals{} }

  // Can also make use of the internal filters format at the end of `vpkmod.cs`:

  replace_item {
    247 { visuals{} }
  }
  replace_visuals {
    6972 5712
    npc_dota_hero_furion { weapon 4159 }
  }
  keep_asset {
    npc_dota_hero_warlock ability_ultimate
  }
  keep_modifier {
    npc_dota_hero_skywrath_mage weapon
    particles/units/heroes/hero_juggernaut/juggernaut_blade_generic.vpcf -
  }  
}
```
Most filters use item numbers (ids) from [items_game.txt](https://github.com/SteamDatabase/GameTracking-Dota2/blob/master/game/dota/pak01_dir/scripts/items/items_game.txt) but also generic hero and slot names or a mix of both.   

### TODO  
Expand choices; populate internal filters; fix visual issues; seek feedback;  thank you for your patience!  

Published under [MIT](LICENSE) license.  

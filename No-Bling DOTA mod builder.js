//                    No-Bling dota_lv mod builder by AveYo - version 1.0
//  This JS script is used internally by the main "No-Bling dota_lv mod builder.bat" launcher 

// AveYo: manual filters to supplement the auto generated ones by the No_Bling JS function - moved here on top, for convenience
var MOD='particles/error/null.vpcf', ADD_HAT={},REM_HAT={}, ADD_HERO={},REM_HERO={}, ADD_SPELL={},REM_SPELL={}, EXCLUDE={}
// WARNING! Don't touch before understanding the No_Bling function; comments with !!! means critical - expect glitches if removed
// ADD_... and REM_... adds / drops a single [modifier]=asset pair from auto generated lists - direct lookup
// EXCLUDE drops all modifiers using specified asset from auto generated lists - reverse lookup

ADD_HAT['particles/econ/items/juggernaut/jugg_arcana/jugg_arcana_haste.vpcf']=MOD;              // remove jugg arcana haste effect  
ADD_HAT['particles/econ/items/necrolyte/necro_sullen_harvest/necro_sullen_harvest_ambient_staff_event.vpcf']=MOD;   // necro trail
ADD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_gravemarker_lvl1.vpcf']=MOD;    // pa
ADD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_gravemarker_lvl2.vpcf']=MOD; // grave
ADD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_gravemarker_lvl3.vpcf']=MOD; // marks
//ADD_HAT['particles/econ/items/rubick/rubick_staff_wandering/rubick_staff_ambient_whset.vpcf']=MOD;       // harlequin jiggle !!!  
ADD_HERO['particles/units/heroes/hero_phantom_assassin/phantom_assassin_ambient_blade.vpcf']=MOD;         //  pa weapon glitch !!!
ADD_HERO['particles/units/heroes/hero_razor_reduced_flash/razor_ambient_main_reduced_flash.vpcf']=MOD;   // dota_hud_reduced_flash
ADD_HERO['particles/units/heroes/hero_razor_reduced_flash/razor_ambient_reduced_flash.vpcf']=MOD;        // dota_hud_reduced_flash
ADD_HERO['particles/units/heroes/hero_razor_reduced_flash/razor_whip_reduced_flash.vpcf']=MOD;            // razor whip jiggle !!!

REM_HAT['particles/econ/items/lina/lina_head_headflame/lina_flame_hand_dual_headflame.vpcf']='';   // keep lina arcana hands flame
REM_HAT['particles/econ/items/pudge/pudge_immortal_arm/pudge_immortal_arm_chain.vpcf']='';       // prevent pudge cloth jiggle !!!
REM_HAT['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail.vpcf']='';                  // keep sf arcana trail
//REM_HAT['particles/econ/items/templar_assassin/templar_assassin_focal/ta_focal_ambient.vpcf']='';
//REM_HAT['particles/econ/items/templar_assassin/templar_assassin_violet/templar_assassin_violet_shoulder_ambient.vpcf']='';
REM_HAT['particles/econ/items/terrorblade/terrorblade_horns_arcana/terrorblade_ambient_body_arcana_horns.vpcf']='';   // tb arcana
REM_HAT['particles/econ/items/terrorblade/terrorblade_horns_arcana/terrorblade_ambient_eyes_arcana_horns.vpcf']=''; // no holes in
//REM_HAT['particles/econ/items/techies/techies_arcana/techies_sign_ambient.vpcf']='';                   // keep techies arcana sign
//REM_HAT['particles/econ/items/zeus/arcana_chariot/zeus_arcana_chariot.vpcf']='';                         // keep zeus arcana cloud

REM_HERO['particles/econ/items/lina/lina_head_headflame/lina_flame_hand_dual_headflame.vpcf']='';   // keep lina arcana hands flame
REM_HERO['particles/econ/items/pudge/pudge_immortal_arm/pudge_immortal_arm_chain.vpcf']='';       // prevent pudge cloth jiggle !!!
REM_HERO['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail.vpcf']='';                  // keep sf arcana trail
REM_HERO['particles/units/heroes/hero_dark_seer/dark_seer_ambient_hands.vpcf']='';  //ds hands - without some think it's ricky !!!
REM_HERO['particles/units/heroes/hero_death_prophet/death_prophet_spirit_glow.vpcf']='';     // invisible ultimate spirits healing
REM_HERO['particles/units/heroes/hero_drow/drow_bowstring.vpcf']='';                                       // invisible bow string
REM_HERO['particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf']='';         // enigma body wormhole - recognizable without
REM_HERO['particles/units/heroes/hero_enigma/enigma_ambient_eyes.vpcf']='';                           // enigma iconic eyes effect
//REM_HERO['particles/units/heroes/hero_enigma/enigma_eidolon_ambient.vpcf']='';         // don't uncomment this one if you need fps
REM_HERO['particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf']='';           // invisible healing ward effect !!!
REM_HERO['particles/units/heroes/hero_lich/lich_ambient_frost.vpcf']='';           // lich ball - iconic, but recognizable without
REM_HERO['particles/units/heroes/hero_medusa/medusa_bow.vpcf']='';                                         // invisible bow string
REM_HERO['particles/units/heroes/hero_morphling/morphling_ambient_new.vpcf']='';     // morph iconic vortex - recognizable without
REM_HERO['particles/units/heroes/hero_pugna/pugna_ward_ambient.vpcf']='';                                    // invisible ward !!!
REM_HERO['particles/units/heroes/hero_techies/techies_sign_ambient_base.vpcf']='';                              // keep techies sign
REM_HERO['particles/units/heroes/hero_techies/techies_stasis_trap.vpcf']='';                                      // trap glitch ?
REM_HERO['particles/units/heroes/hero_templar_assassin/templar_assassin_ambient.vpcf']='';               // ta iconic hands effect
REM_HERO['particles/units/heroes/hero_tusk/tusk_frozen_sigil.vpcf']='';                                     // invisible sigil !!!
REM_HERO['particles/units/heroes/hero_windrunner/windrunner_bowstring.vpcf']='';                           // invisible bow string
REM_HERO['particles/units/heroes/hero_wisp/wisp_ambient.vpcf']='';                                           // invisible wisp !!!
REM_HERO['particles/units/heroes/hero_witchdoctor/witchdoctor_ward_skull.vpcf']='';                         // invisible ward head

REM_SPELL['particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_ring_arcana.vpcf']='';       // keep legion arcana duel
REM_SPELL['particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe.vpcf']='';         //  without trail effect
REM_SPELL['particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf']='';   // keep necro ti7 scythe
REM_SPELL['particles/econ/items/techies/techies_arcana/techies_sign_ambient.vpcf']='';                   // keep techies arcana sign
REM_SPELL['particles/econ/items/techies/techies_arcana/techies_stasis_trap_arcana.vpcf']='';               // arcana trap glitch ?

// Advanced_lookup_filter - KEEP prevents asset being removed from whatrules list by the No-Bling choices generic filter
//KEEP['particles/units/heroes/hero_razor_reduced_flash/razor_whip_reduced_flash.vpcf']=MOD;          // razor whip cloth jiggle !!!
EXCLUDE['particles/units/heroes/hero_phantom_assassin/phantom_assassin_ambient_blade.vpcf']='';       // pa lvl6 weapon glitch !!!
EXCLUDE['particles/units/heroes/hero_templar_assassin/templar_assassin_ambient.vpcf']='';               // ta iconic hands effect
EXCLUDE['particles/units/heroes/hero_windrunner/windrunner_bowstring.vpcf']='';
EXCLUDE['particles/units/heroes/hero_drow/drow_bowstring.vpcf']=''; 
// Advanced tip: while testing a hero, list loaded particles using console command: dumpparticlelist | grep partial_hero_name

//----------------------------------------------------------------------------------------------------------------------------------
// No_Bling JS main function
//----------------------------------------------------------------------------------------------------------------------------------
No_Bling=function(src_content,mod_dir,vpk_root,mod_choices,verbose,timers) {
  console.log('',run, ' @ ', engine, (jscript) ? ': Try the faster Node.js engine' : ''); console.log(' ------------------------');

  // AveYo: Parse arguments
  var SOURCE          = path.normalize(src_content);
  var OUTPUT          = path.normalize(mod_dir);
  var ROOT            = vpk_root;
  var CHOICES         = mod_choices.split(','); //if (LOG) console.log('CHOICES = ', mod_choices);
  var MOD_LV          = (mod_choices.indexOf('-LowViolence') > -1); // Undo -lv launch option turning all blood into alien green
  var MOD_EVENTS      = (mod_choices.indexOf('Events') > -1);       // The International 7 custom tp, blink etc.
  var MOD_SPELLS      = (mod_choices.indexOf('Spells') > -1);       // Penguin Frostbite and stuff like that..
  var MOD_HATS        = (mod_choices.indexOf('Hats') > -1);         // Cosmetic particles spam - slowly turning into TF2..
  var MOD_HEROES      = (mod_choices.indexOf('Heroes!') > -1);      // Model particles, helps potato pc's but glancevalue can suffer
  var MOD_WARDS       = (mod_choices.indexOf('Wards') > -1);        // Just a few of them make the ward and the sentry item similar
  var MOD_COURIERS    = (mod_choices.indexOf('Couriers') > -1);     // Couriers particles are fine.. until a dumber abuses gems   
  var MOD_TOWERS      = (mod_choices.indexOf('Towers') > -1);       // Just the particle effects, models remain unchanged
  var ACTIVE_EVENT_ID = 'EVENT_ID_INTERNATIONAL_2017' //current_event
  var LOG             = (verbose == '1'), LOGX = false;             // Exports detailed per-hero lists, useful for debugging mod
  var MEASURE         = (timers == '1'); if (!MEASURE) timer = function(f){return{end:function(){}}}; var t;

  // AveYo: initiate filter variables
  var MOD='particles/error/null.vpcf', q='"', used_by_heroes={}, whatrules={}, log_lv=[]; //, probably_hat={}, probably_spell={}, lookup_hat={}, silhouette ={};
  var logs={ 'Others':{},'Couriers':{},'Wards':{},'Events':{},'Heroes!':{},'Hats':{} }; 
  var mods={ 'Others':{},'Couriers':{},'Wards':{},'Events':{},'Heroes!':{},'Hats':{},'Spells':{},'Towers':{} };

  // Quit early if no choice selected
  if (!MOD_LV && !MOD_EVENTS && !MOD_SPELLS && !MOD_HATS && !MOD_HEROES && !MOD_WARDS && !MOD_COURIERS && !MOD_TOWERS && !LOG)
    w.quit();

  // AveYo: Read and vdf.parse items_game.txt and optionally export vdf.stringify result for verification purposes
  var file_src=path.normalize(OUTPUT+'\\scripts\\items\\items_game.txt');
  t=timer(' Read file');
  var file_read=fs.readFileSync(file_src, DEF_ENCODING);
  t.end();
  var vdf=ValveDataFormat();
  t=timer(' VDF.parse');
  var file_parse=vdf.parse(file_read);
  t.end();
  if (LOG) {
    t=timer(' VDF.stringify');
    var file_stringify=vdf.stringify(file_parse,true);
    t.end();
    var file_out=path.normalize(OUTPUT+'\\scripts\\items\\items_game_out.txt');
    t=timer(' Write file');
    fs.writeFileSync(file_out, file_stringify, DEF_ENCODING);
    t.end();
  }

  // AveYo: Loop trough generic asset_modifiers definitions in items_game.txt - these are mostly for custom Spells effects
  if (LOG) t=timer(' Check generic asset_modifiers');
  var asset_modifiers=file_parse.items_game.asset_modifiers;
  for (var a in asset_modifiers) {
    if (typeof asset_modifiers[a] != 'object') continue; // skip if not object
    for (var m in asset_modifiers[a]) {
      var generic=asset_modifiers[a][m];
      if (typeof generic.type == 'string' && generic.type == 'particle') {
        if (typeof generic.modifier == 'string' && generic.modifier.lastIndexOf('.vpcf') > -1) {
          mods['Spells'][generic.modifier]=MOD;
          if (typeof generic.asset == 'string' && generic.modifier.lastIndexOf('.vpcf') > -1)
            mods['Spells'][generic.modifier]=generic.asset;
          if (LOGX) console.log ('   spell', path.basename(generic.modifier));
        }
      }
    } // next m
  } // next a
  if (LOG) t.end();

  // AveYo: Loop trough all items, skipping over not selected / irrelevant categories and optionally generate accurate slice logs
  if (LOG) t=timer(' Check items');
  var items=file_parse.items_game.items;
  for (var i in items) {
    if (typeof items[i].prefab != 'string') continue; // skip if not .prefab - the hidden item #TF_Default_ItemDef
    var prefab=items[i].prefab || '', cat='', rarity=items[i].item_rarity || '', iname=items[i].item_name.split('#DOTA_Item_')[1];
    var expiration=(typeof items[i].expiration_date == 'string') ? items[i].expiration_date.split(' ')[0].split(/\-0|\-/g) : '';
    var expired=(expiration && Date.UTC(expiration[0],expiration[1],expiration[2]) - new Date().getTime() < 0);
    var hero='npc_dota'; if (typeof items[i].used_by_heroes == 'object') {
      for (var h in items[i].used_by_heroes) if (h.indexOf('_dota_') > -1) hero=h.split('_dota_')[1];
      if (hero.indexOf('hero_') > -1) { hero=h.split('hero_')[1]; } else { hero='npc_dota'; }    used_by_heroes[hero]='';
    }
    // AveYo: still in the item i loop above, check visuals section for asset_modifier*
    var cat='Others',has_particles=false, silhouette={}, probably_hat={}, probably_spell={}, probably_def={}, lookup_hat={};
    if (typeof items[i].visuals != 'object') continue; // skip if no .visuals object
    for (var f in items[i].visuals) {
      var visuals=items[i].visuals[f]; // .visuals object - don't use exact naming since vdf.parser auto-renamed duplicates
      var type=(typeof visuals.type == 'string' && visuals.type.indexOf('particle') == 0 ) ? visuals.type : '';
      if (!type || type == 'particle_control_point' || type == 'particle_combined') continue; // skip non particle / particle_create
      has_particles = true; // item i has particle definitions, so enable logging 
      var modifier=(typeof visuals.modifier == 'string' && visuals.modifier.lastIndexOf('.vpcf') > -1) ? visuals.modifier : '';
      //if (modifier.lastIndexOf('obsidian_destroyer_smoke.vpcf') > -1 ) continue; // the only modifier that can cause crashes!!!
      var asset=(typeof visuals.asset == 'string' && visuals.asset.lastIndexOf('.vpcf') > -1) ? visuals.asset : '';
      if (asset && asset.indexOf('particles/ability_modifier') > -1) continue; // skip dynamic references
      if (asset && asset.indexOf('particles/reftononexistent') > -1) continue; // skip dynamic references
      if (asset && asset in EXCLUDE) { if (LOGX) console.log('   Exclude', path.basename(asset)); continue; } // apply EXCLUDE list
      if (modifier == asset) continue; // skip if modifier and asset are the same
      if (!modifier && !asset) continue; // skip if both modifier and asset are not defined / not .vpcf particle files
      // AveYo: sort particles
      if (prefab == 'tool' || prefab == 'relic' || prefab == 'treasure_chest') {  // EVENT AND TOWERS
        if (items[i].event_id != ACTIVE_EVENT_ID) continue; // active event id is EVENT_ID_INTERNATIONAL_2017
        if (expired) continue; // skip expired events - sadly most don't have expiration_date set so this filter can't be used alone
        if (modifier && modifier.indexOf('particles/world_tower') > -1) {
          cat='Towers'; mods[cat][modifier]=(asset) ? asset : MOD;
        } else {
          cat='Events'; mods[cat][modifier]=(asset) ? asset : MOD;
        }
      } else if (prefab == 'wearable' || prefab == 'bundle') {  // SPELLS AND HATS
        cat='Hats';
        switch(type) {
          case 'particle':
            var odd=true; // expecting .asset
            if (modifier.indexOf('particles/econ/items') > -1) {
              // Spells mostly but in this case we can have Hats, too. Separating them is not simple, but Magic shall not prevail!
              cat='Hats'; probably_spell[modifier]=MOD; // probably_spell
              if (asset && asset.indexOf('particles/econ/items') == -1) { probably_spell[modifier]=asset; odd=false; }
              if (LOGX) console.log((odd) ? '!!! ' : '', '  ? spell', path.basename(modifier) );
            } else {
              cat='Others'; //mods[cat][modifier]=MOD;
              //if (asset) {mods[cat][modifier]=asset; odd=false; }
              if (LOGX) console.log((odd) ? '!!! ' : '', '    bling', path.basename(modifier));
            }
            break;
          case 'particle_create':
            var odd=false; // not expecting .asset
            if (modifier.indexOf('particles/econ/items') > -1) {
              // Hats mostly
              cat='Hats'; mods[cat][modifier]=MOD; // probably_hat
              if (asset && asset.indexOf('particles/econ/items') == -1) { mods[cat][modifier]=asset; odd=true; }
              if (LOGX) console.log((odd) ? '!!! ' : '', '    hat  ', path.basename(modifier) );
            } else if (modifier.indexOf('particles/units/heroes') > -1) {
              cat='Hats'; probably_hat[modifier]=MOD;
              if (LOGX) console.log(' ? probably_hat', prefab, modifier);
            } else {
              cat='Others'; //mods[cat][modifier]=MOD;
              //if (asset) { mods[cat][modifier]=asset; odd=true; }
              if (LOGX) console.log((odd) ? '!!! ' : '', '    model', path.basename(modifier) );
            }
            break;
          default:
        }
      } else if (prefab == 'default_item') {  // DEFAULT HEROES
        cat='Heroes!';
        if (modifier.indexOf('particles/units/heroes') == -1) continue;
        mods[cat][modifier]=(asset) ? asset : MOD;
      } else if (prefab == 'ward') {  // WARDS
        cat='Wards'; mods[cat][modifier]=(asset) ? asset : MOD;
      } else if (prefab.indexOf('courier') == 0) {  // COURIERS
        cat='Couriers'; mods[cat][modifier]=(asset) ? asset : MOD;
      } else {  // OTHERS
        if (expired) continue;
        cat='Others'; mods[cat][modifier]=(asset) ? asset : MOD;
      }
    } // next f

    // AveYo: Separate Hats from Spells out of the ambiguous visuals.asset_modifier.type='particle'
    for (var hat in probably_spell) {
      if (probably_spell[hat] in probably_hat) {
        mods['Hats'][hat]=MOD; if (LOGX) console.log('certainly hat', hat);
      } else if (probably_spell[hat] in mods['Heroes!']) {
        mods['Hats'][hat]=probably_spell[hat]; // if it's a default hero modifier, treat it as Hats when Heroes! not selected 
        mods['Heroes!'][hat]=MOD; if (LOGX) console.log('recursive hero', hat); // and only disable it if Heroes! selected
      } else {
        mods['Spells'][hat]=probably_spell[hat]; //if (LOG) console.log('certainly spell', hat, path.basename(probably_spell[hat]));
      }
    }

    // AveYo: Optionally log events / per-hero / ward / courier/ other items having particle definitions
    if (LOG && has_particles) {
      if (cat == 'Heroes!' || cat == 'Hats') { // per-hero items
        if (!logs[cat][hero]) logs[cat][hero]={};
        if (!logs[cat][hero][i]) logs[cat][hero][i]={}; // for convenience, log slices will keep original indenting.. wOw!
        if (!logs[cat][hero][i]['items_game']) logs[cat][hero][i]['items_game']={};
        if (!logs[cat][hero][i]['items_game']['items']) logs[cat][hero][i]['items_game']['items']={};
        if (!logs[cat][hero][i]['items_game']['items'][i+'']) logs[cat][hero][i]['items_game']['items'][i+'']=items[i];
      } else {  // non-hero items
        if (!logs[cat]) logs[cat]={};
        if (!logs[cat][i]) logs[cat][i]={};
        if (!logs[cat][i]['items_game']) logs[cat][i]['items_game']={};
        if (!logs[cat][i]['items_game']['items']) logs[cat][i]['items_game']['items']={};
        if (!logs[cat][i]['items_game']['items'][i+'']) logs[cat][i]['items_game']['items'][i+'']=items[i];
      }
    } // done LOG
    if (LOG && has_particles) console.log('  ',cat,hero,prefab,rarity,vdf.redup(i),iname);
  }  // next item i
  if (LOG) t.end(); // Done checking items loop

  // Import basic manual filter defined at the top of this script: ADD_HAT,REM_HAT, ADD_HERO,REM_HERO, ADD_SPELL,REM_SPELL
  for (var hat in ADD_HAT) { mods['Hats'][hat]=ADD_HAT[hat]; if (LOGX) console.log('  Add', path.basename(hat)); }
  for (var hat in REM_HAT) { mods['Hats'][hat]=undefined; delete mods['Hats'][hat]; if (LOGX) console.log('  Rem', hat); }
  for (var hat in ADD_HERO) { mods['Heroes!'][hat]=ADD_HERO[hat]; if (LOGX) console.log('  Add', path.basename(hat)); }
  for (var hat in REM_HERO) { mods['Heroes!'][hat]=undefined; delete mods['Heroes!'][hat]; if (LOGX) console.log('  Rem', hat); }
  for (var hat in ADD_SPELL) { mods['Spells'][hat]=ADD_SPELL[hat]; if (LOGX) console.log('  Add', path.basename(hat)); }
  for (var hat in REM_SPELL) { mods['Spells'][hat]=undefined; delete mods['Spells'][hat]; if (LOGX) console.log('  Rem', hat); }

  // AveYo: Optionally log to file per-hero / ward / events items lists, and the no_bling source = replacement troubleshooting list
  if (LOG) {
    t=timer(' Export per-hero / ward / events lists');
    for (var cat in logs) {
      if (typeof logs[cat] != 'object') continue;
      if (cat == 'Heroes!' || cat == 'Hats') { // per-hero items 
        for (var hero in used_by_heroes) {
          var per_hero='/' + hero + '/';
          for (item in logs[cat][hero]) {
            var iname=logs[cat][hero][item].items_game.items[item].item_name.replace('#DOTA_Item_',''), inumber=vdf.redup(item);
            var logitem='./log/' + cat + per_hero + iname + '_' + inumber + '.txt'; MakeDir('./log/' + cat + per_hero);
            fs.writeFileSync(path.normalize(logitem), vdf.stringify(logs[cat][hero][item],true), DEF_ENCODING);
          }
        }
      } else {  // non-hero items
        for (item in logs[cat]) {
          var iname=logs[cat][item].items_game.items[item].item_name.replace('#DOTA_Item_',''), inumber=vdf.redup(item);
          var logitem='./log/' + cat + '/' + iname + '_' + inumber + '.txt'; MakeDir('./log/' + cat + '/');
          fs.writeFileSync(path.normalize(logitem), vdf.stringify(logs[cat][item],true), DEF_ENCODING);
        }
      }
    }
    if (MOD_LV || MOD_EVENTS || MOD_SPELLS || MOD_HATS || MOD_HEROES || MOD_WARDS || MOD_COURIERS || MOD_TOWERS) {
      var summary='', maxpad = 0; for (var cat in mods){for (var hat in mods[cat]){var l=hat.length;if (l > maxpad) maxpad=l + 2 } }
      for (var cat in mods) {
        for (var hat in mods[cat]) {
          var l=hat.length, pad=(l > maxpad)? 0 : (maxpad - l), padding=Array(pad+1).join(' ');
          summary += hat +','+ padding +','+ mods[cat][hat] + ',\r\n';
        } 
      }
      fs.writeFileSync(path.normalize('./log/No-Bling.txt'), summary, DEF_ENCODING);
    }
    if (typeof log_lv == 'object' && log_lv.length > 1) {
      var lv_list=''; for (var l=0,n=log_lv.length; l<n; l++) { lv_list += log_lv[l] + '\r\n'; }
      fs.writeFileSync(path.normalize('./log/LowViolence.txt'), lv_list, DEF_ENCODING);
    }
    t.end();
  }

  // Do not output source files if no choice selected
  if (!MOD_LV && !MOD_EVENTS && !MOD_SPELLS && !MOD_HATS && !MOD_HEROES && !MOD_WARDS && !MOD_COURIERS && !MOD_TOWERS) 
    w.quit();

  // AveYo: Mod particle files using built-in m_hLowViolenceDef interface - this is what makes this mod so neat, clean, and safe!
  t=timer(' Mod particles');
  var lv_regx=new RegExp('^[ \t]*m_hLowViolenceDef = .*$[\n\r]+','m'), lv_insert=new RegExp('^[ \t]*_class = .*$[\n\r]+','m');
//  var mods={'Event':events,'Abilities':spells,'Hats':hats,'Heroes!':defaults,'Wards':wards,'Towers':towers,'Couriers':couriers,'Others':others};
//  var logs={ 'others':{},'couriers':{},'wards':{},'events':{},'wearables':{},'defaults':{} };
//  var mods={ 'others':{},'couriers':{},'wards':{},'events':{},'towers':{},'spells':{},'hats':{},'heroes':{} };


  for (var cat in mods) {
    var particles=mods[cat];
    for (var hat in particles) {
      var source_file=path.normalize(path.join(SOURCE, hat)), lv_file=path.normalize(OUTPUT+'\\src\\' + cat + '\\'+hat);
      MakeDir(path.dirname(lv_file));
      if (FileExists(source_file)) {
        var data=fs.readFileSync(source_file, DEF_ENCODING);
        var rez=lv_regx.exec(data); if (rez != null) data=data.replace(lv_regx,''); // remove default -lv definition
        var ins=lv_insert.exec(data); if (ins != null) {
          data=data.replace(lv_insert, ins + '\tm_hLowViolenceDef = resource:"' + particles[hat] + '"\r\n'); // no-bling def
        }
        fs.writeFileSync(lv_file, data, DEF_ENCODING);
      } else {
        if (LOG) console.log('  MISSING', source_file);
      }
    } // next hat
  } // next id
  t.end();

  if (MOD_LV) {
    console.log('Removing LowViolence definitions...');
    t=timer(' Patch -LV');
    var lv_src=path.normalize(path.join(SOURCE, 'particles'));
    var lv_dst=path.normalize(path.join(OUTPUT, 'src\\lowviolence\\particles'));
    var lv_regex=new RegExp('^[ \t]*m_hLowViolenceDef =[^\n]+\n','m');
    log_lv=RegexStrReplaceRecursiveDir(lv_regex, '', lv_src, lv_dst, DEF_ENCODING, LOG);
    t.end();
  }

} // End of No_Bling




  // whatrules[modifier]=asset - we override the asset part (usually wearable type / workshop) with default_item definition or null
/*  if (LOG) t=timer(' Filter particles');
  // Import basic manual filter defined at the top of this hybrid script: ADD_HAT, REM_HAT, ADD_HERO, REM_HERO
//  if (MOD_HATS) {
//    for (var hat in ADD_HAT) { whatrules[hat]=ADD_HAT[hat]; if (LOG) console.log('  add', path.basename(hat)); }
//    for (var hat in REM_HAT) { whatrules[hat]=undefined; delete whatrules[hat]; if (LOG) console.log('  rem', path.basename(hat)) }
//    for (var hat in KEEP) { whatrules[hat]=KEEP[hat]; if (LOG) console.log('  keep', path.basename(hat)); }
//  }
//  if (MOD_HEROES) {
//    for (var hat in ADD_HERO) { whatrules[hat]=ADD_HERO[hat]; if (LOG) console.log('  add', path.basename(hat)); }
//    for (var hat in REM_HERO) { whatrules[hat]=undefined; delete whatrules[hat]; if (LOG) console.log('  rem', path.basename(hat)) }
//  }
  // Process whatrules[modifier]=asset list that was auto-generated from items_game.txt (and altered by the manual filters above)
  for (var hat in whatrules) {

//     console.log('~~', path.basename(hat), path.basename(whatrules[hat]));
    // Import advanced lookup filter defined at the top of this hybrid script: KEEP, EXCLUDE
    var IMPORTED = false;
//    if (MOD_HATS) {
//      IMPORTED = (hat in KEEP) ? true : false; if (LOG && IMPORTED) console.log('  keep', path.basename(hat));
//      if (whatrules[hat] in EXCLUDE) { whatrules[hat]=undefined; delete whatrules[hat]; continue; if (LOG) console.log('  exclude', path.basename(hat));}
//      if (whatrules[hat] in EXCLUDE) { whatrules[hat]='BAUD MOD'; if (LOG) console.log('  exclude', path.basename(hat));}
//    }
    // Apply No-Bling choices
    if (whatrules[hat] === undefined) { delete whatrules[hat]; continue; }                // delete empty (removed by filters above)
    if (hat.indexOf('particles/econ/items') > -1) { if (!MOD_SPELLS && !MOD_HATS) whatrules[hat]=undefined; }
    else if (hat.indexOf('particles/units/heroes') > -1) { if (!MOD_HEROES && !IMPORTED) whatrules[hat]=undefined; }
    else if (hat.indexOf('particles/econ/wards') > -1) { if (!MOD_WARDS) whatrules[hat]=undefined; }
    else if (hat.indexOf('particles/world_tower') > -1) { if (!MOD_TOWERS) whatrules[hat]=undefined; }
    else if (hat.indexOf('particles/econ/events') > -1) { if (!MOD_COMPENDIUM) whatrules[hat]=undefined; }
    else whatrules[hat]=undefined;
    // Modifier Safeguard
    if (whatrules[hat] === undefined) { delete whatrules[hat]; continue; }                // delete empty (removed by filters above)
    if (hat == MOD || hat == whatrules[hat]) whatrules[hat]=undefined;          // skip modifier == null and modifier == asset
    else if (hat.lastIndexOf('.vpcf') == -1) whatrules[hat]=undefined;                         // skip non particle definition files
    else if (hat.lastIndexOf('_null.vpcf') > -1 || hat.lastIndexOf('_local.vpcf') > -1) whatrules[hat]=undefined;   // skip built-in
    else if (hat.lastIndexOf('obsidian_destroyer_smoke.vpcf') > -1 ) whatrules[hat]=undefined;   // the only file causing crashes!!!
    // Asset Safeguard
    if (whatrules[hat] === undefined) { delete whatrules[hat]; continue; }                // delete empty (removed by filters above)
    if (whatrules[hat].lastIndexOf('.vpcf') == -1) whatrules[hat]=undefined;                   // skip non particle definition files
    else if (whatrules[hat].indexOf('particles/ability_modifier') > -1) whatrules[hat]=undefined;         // skip dynamic references
    else if (whatrules[hat].indexOf('particles/reftononexistent') > -1) whatrules[hat]=undefined;         // skip dynamic references
//    else if (whatrules[hat].indexOf('particles/econ/items') > -1)
//      whatrules[hat]=(MOD_SPELLS) ? undefined : MOD;               // skip econ to econ modifier for Spells, disable otherwise
//    if (whatrules[hat] !== undefined && whatrules[whatrules[hat]] !== undefined)
//      whatrules[hat]=(MOD_SPELLS) ? undefined : MOD;                  // skip recursive modifier for Spells, disable otherwise

//    else if (whatrules[hat].indexOf('particles/econ/items') > -1) whatrules[hat]=MOD;     // don't allow econ to econ modifier
//    if (whatrules[hat] !== undefined && whatrules[whatrules[hat]] !== undefined) whatrules[hat]=MOD;  // no recursive modifier
    if (whatrules[hat] === undefined) delete whatrules[hat];                              // delete empty (removed by filters above)
  }
  if (LOG) t.end();  */

  // AveYo: Remove default -lv definitions that cause green alien blood   - slower than the batch method due to recursive / caching





//----------------------------------------------------------------------------------------------------------------------------------
// Utility JS functions - callable independently
//----------------------------------------------------------------------------------------------------------------------------------
DOTA_LaunchOptions=function(fn,options, _output) {
  var regs={}, opts=options.split(' '), i=0,n=opts.length; for (i=0;i<n;i++) regs[opts[i]]=new RegExp('\\B' + opts[i] + '\\b','gi');
  var output=_output || '2', found='yes', file=path.normalize(fn), data=fs.readFileSync(file, DEF_ENCODING);
  var vdf=ValveDataFormat(), parsed=vdf.parse(data), steam=parsed.UserLocalConfigStore.Software.Valve.Steam;
  var dota=(typeof steam.Apps == 'object') ? steam.Apps[vdf.nr('570')] : steam.apps[vdf.nr('570')]; // Gaben, please!
  if (output == '0') {  console.log(dota.LaunchOptions); return; } // 3rd par '0' = print existing launch options and exit
  if (dota.LaunchOptions === undefined || dota.LaunchOptions == '') {
    dota['LaunchOptions']=options; found=''; 
  } else {
    for (i=0;i<n;i++) if (!regs[opts[i]].test(dota.LaunchOptions)) { dota.LaunchOptions+=' ' + opts[i]; found=''; }
  }
  if (output == '1') { console.log(found); return; } // 3rd par '1' = check options and print found[1] or notfound['']
  fs.writeFileSync(fn, vdf.stringify(parsed,true), DEF_ENCODING); // '2' = silently add options - default output if 3rd par ommited 
}

OutChars=function(s) { new Function('console.log(String.fromCharCode('+s+'))')(); }

//----------------------------------------------------------------------------------------------------------------------------------
// ValveDataFormat hybrid js parser by AveYo, 2016                                                VDF test on 20.1 MB items_game.txt
// loosely based on vdf-parser by Rossen Popov, 2014-2016                                                           node.js  cscript
// featuring auto-renaming duplicate keys, saving comments, grabbing lame one-line "key" { "k" "v" }        parse:  1.329s   9.285s
// greatly improved cscript performance - it's not that bad overall but still lags behind node.js       stringify:  0.922s   3.439s
//----------------------------------------------------------------------------------------------------------------------------------
function ValveDataFormat() {
  var jscript=(typeof ScriptEngine == 'function' && ScriptEngine() == 'JScript');
  var order=!jscript, dups=false, comments=false, newline='\n', empty=(jscript) ? '' : undefined;
  return {
    parse: function(txt, flag) {
      var obj={}, stack=[obj], expect_bracket=false, i=0; comments=flag || false;
      if (/\r\n/.test(txt)) {newline='\r\n'} else newline='\n';
      var m, regex =/[^"\r\n]*(\/\/.*)|"([^"]*)"[ \t]+"([^"]*\\"[^"]*\\"[^"]*|[^"]*)"|"([^"]*)"|({)|(})/g;
      while ((m=regex.exec(txt)) !== null) {
        //lf='\n'; console.log(' cmnt:',m[1],lf ,'key:',m[2],lf ,'val:',m[3],lf ,'add:',m[4],lf ,'open:',m[5],lf ,'close:',m[6],lf);
        if (comments && m[1] !== empty) {
          key='\x10' + i++; stack[stack.length-1][key]=m[1];                                      // AveYo: optionally save comments
        } else if (m[4] !== empty) {
          key=m[4]; if (expect_bracket) { console.log('VDF.parse: invalid bracket near '+ m[0]); return this.stringify(obj,true) }
          if (order && key == ''+~~key) {key='\x11' + key;}            // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (stack[stack.length-1][key] === undefined) {
            stack[stack.length-1][key]={};
          } else {
            key += '\x12' + i++; stack[stack.length-1][key]={}; dups=true;          // AveYo: rename duplicate key obj with \x12 + i
          }
          stack.push(stack[stack.length-1][key]); expect_bracket=true;
        } else if (m[2] !== empty) {
          key=m[2]; if (expect_bracket) { console.log('VDF.parse: invalid bracket near '+ m[0]); return this.stringify(obj,true) }
          if (order && key == ''+~~key) key='\x11' + key;              // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (stack[stack.length-1][key] !== undefined) { key += '\x12' + i++; dups=true }       // AveYo: rename duplicate k-v pair
          stack[stack.length-1][key]=m[3]||'';
        } else if (m[5] !== empty) {
          expect_bracket=false; continue; // one level deeper
        } else if (m[6] !== empty) {
          stack.pop(); continue; // one level back
        }
      }
      if (stack.length != 1) { console.log('VDF.parse: open parentheses somewhere'); return this.stringify(obj,true) }
      return obj; // stack[0];
    },
    stringify: function(obj, pretty, nl) {
      if (typeof obj != 'object') { console.log('VDF.stringify: Input not an object'); return obj }
      pretty=( typeof pretty == 'boolean' && pretty) ? true : false; nl=nl || newline || '\n';
      return this.dump(obj, pretty, nl, 0);
    },
    dump: function(obj, pretty, nl, level) {
      if (typeof obj != 'object') { console.log('VDF.stringify: Key not string or object'); return obj}
      var indent='\t', buf='', idt='', i=0;
      if (pretty) for (; i < level; i++) idt += indent;
      for (var key in obj) {
        if (typeof obj[key] == 'object')  {
          buf += idt +'"'+ this.redup(key) +'"'+ nl + idt +'{'+ nl + this.dump(obj[key], pretty, nl, level+1) + idt +'}'+ nl;
        } else {
          if (comments && key.indexOf('\x10') !== -1) { buf += idt + obj[key] + nl; continue } // AveYo: restore comments (optional)
          buf += idt +'"'+ this.redup(key) +'"'+ indent + indent +'"'+ obj[key] +'"'+ nl;
        }
      };
      return buf;
    },
    redup: function(key) {
      if (order && key.indexOf('\x11') !== -1) key=key.split('\x11')[1];                    // AveYo: restore number keys in node.js
      if (dups && key.indexOf('\x12') !== -1) key=key.split('\x12')[0];                        // AveYo: restore duplicate key names
      return key;
    },
    nr: function(key) {return (!jscript && key.indexOf('\x11') == -1) ? '\x11' + key : key} // AveYo: check number key: vdf.nr('nr')
  }
} // End of ValveDataFormat

//----------------------------------------------------------------------------------------------------------------------------------
// Hybrid Node.js / JScript Engine by AveYo - can call specific functions as the first script argument
//----------------------------------------------------------------------------------------------------------------------------------
if (typeof ScriptEngine == 'function' && ScriptEngine() == 'JScript') {
  // start of JScript specific code
  jscript=true, engine='JScript', w=WScript, launcher=new ActiveXObject('WScript.Shell'), argc=w.Arguments.Count(), argv=[], run='';
  if (argc > 0) { run=w.Arguments(0); for (var i=1;i<argc;i++) argv.push( '"'+ w.Arguments(i).replace(/[\\\/]+/g,'\\\\') +'"') }
  process={}; process.argv=[ScriptEngine(),w.ScriptFullName]; for (var i=0;i<argc;i++) process.argv[i+2]=w.Arguments(i);
  path={}; path.join=function(f,n){return fso.BuildPath(f,n)}; path.normalize=function(f){return fso.GetAbsolutePathName(f)};
  path.basename=function(f){return fso.GetFileName(f)}; path.dirname=function(f){return fso.GetParentFolderName(f)};path.sep='\\';
  console={}; console.log=function(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u) { w.echo(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u) };
  fs={}; fso=new ActiveXObject("Scripting.FileSystemObject"); ado=new ActiveXObject('ADODB.Stream'); DEF_ENCODING='Windows-1252';
  FileExists=function(f) { return fso.FileExists(f) }; PathExists=function(f) { return fso.FolderExists(f) };
  MakeDir=function(fn){
    if (fso.FolderExists(fn)) return; var pfn=fso.GetAbsolutePathName(fn), d=pfn.match(/[^\\\/]+/g), p='';
    for(var i=0,n=d.length; i<n; i++) { p += d[i] + '\\'; if (!fso.FolderExists(p)) fso.CreateFolder(p) }
  }
  fs.readFileSync=function(fn, charset) {
    var data=''; ado.Mode=3; ado.Type=2; ado.Charset=charset || 'Windows-1252'; ado.Open(); ado.LoadFromFile(fn);
    while (!ado.EOS) data += ado.ReadText(131072); ado.Close(); return data;
  }
  fs.writeFileSync=function(fn, data, encoding) {
    ado.Mode=3; ado.Type=2; ado.Charset=encoding || 'Windows-1252'; ado.Open();
    ado.WriteText(data); ado.SaveToFile(fn, 2); ado.Close(); return 0;
  }
  RegexStrReplaceRecursiveDir=function(regex, str, src, dst, charset, verbose,  _root,_base,_list) {
    charset=charset || 'utf-8', _root=_root || src, _base=_base || path.basename(dst), VERBOSE =verbose || false, _list=_list || [];
    var root=fso.GetFolder(src), files=new Enumerator(root.Files), dirs=new Enumerator(root.SubFolders);
    while (!files.atEnd()) {
      //var data=fs.readFileSync(files.item(), charset);                               // definitely slower for multiple small files
      var buff=files.item().size, ts=files.item().OpenAsTextStream(1, 0), data=ts.Read(buff); ts.Close();  // (1=ForReading,0=ASCII)
      if (regex.test(data)) {
        if (VERBOSE) console.log('  ' + files.item().Name);
        data=data.replace(regex, str);
        var file_root=files.item().path.replace(_root, ''); MakeDir(fso.GetParentFolderName(dst + file_root));
        //fs.writeFileSync(dst + file_root, data, charset);                              // might be slower for multiple small files
        var f=fso.OpenTextFile(dst + file_root, 2, true); f.Write(data); f.Close();                  // (file, 2=ForWriting, create)
        _list.push(_base + file_root);
      }
      files.moveNext();
    }
    while (!dirs.atEnd()) {
      _list=RegexStrReplaceRecursiveDir(regex,str,dirs.item().path,dst,charset,VERBOSE, _root,_base,_list); dirs.moveNext();
    }
    return _list;
  };
  // end of JScript specific code
} else {
  // start of Node.js specific code
  jscript=false, engine='Node.js', w={}, argc=process.argv.length, argv=[], run='', p=process.argv; w.quit=process.exit;
  if (argc > 2) { run=p[2]; for (var i=3;i<argc;i++) argv.push( '"'+ p[i].replace(/[\\\/]+/g,'\\\\') +'"') }
  path=require('path'); fs=require('fs'); DEF_ENCODING='utf-8'; w.quit=process.exit;
  FileExists=function(f) { try{ return fs.statSync(f).isFile(); }catch(e){ if (e.code == 'ENOENT') return false } }
  PathExists=function(f) { try{ return fs.statSync(f).isDirectory(); }catch(e){ if (e.code == 'ENOENT') return false } }
  MakeDir=function(f) { try{ fs.mkdirSync(f) }catch(e){ if (e.code == 'ENOENT') { MakeDir(path.dirname(f)); MakeDir(f) } } }
  RegexStrReplaceRecursiveDir=function(regex, str, src, dst, charset, verbose,  _root,_base,_list) {
    charset=charset || 'utf-8', _root=_root || src, _base=_base || path.basename(dst), VERBOSE =verbose || false, _list=_list || [];
    var root=fs.readdirSync(src);
    root.forEach(function(item) {
      var file=path.join(src, item), stat=fs.statSync(file);
      if (stat && stat.isFile()) {
        var data=fs.readFileSync(file, charset);
        if (regex.test(data)) {
          if (VERBOSE) console.log('  ' + path.basename(file));
          data=data.replace(regex, str);
          var file_root=String(file).replace(_root, ''); MakeDir(path.dirname(dst + file_root));
          fs.writeFileSync(dst + file_root, data, charset);
          _list.push(_base + file_root);
        }
      }
      else if (stat && stat.isDirectory()) _list=RegexStrReplaceRecursiveDir(regex,str,file,dst,charset,VERBOSE, _root,_base,_list);
    });
    return _list; // async variant is a few secs faster, but does not warrant code bloat or using 3x-4x size newer node.exe binaries
  };
  // end of Node.js specific code
}
function timer(f) {
  var b=new Date(); return { end:function(){ var e=new Date(), t=(e.getTime()-b.getTime())/1000; console.log(f+': '+t+'s'); } }
}
// If run without parameters the .js file must have been double-clicked in shell, so try to launch the correct .bat file instead
if (jscript && run == '' && FileExists(w.ScriptFullName.slice(0, -2)+'bat')) launcher.Run('"'+w.ScriptFullName.slice(0, -2)+'bat"'); 
//----------------------------------------------------------------------------------------------------------------------------------
// Auto-run JS: if first script argument is a function name - call it, passing the next arguments
//----------------------------------------------------------------------------------------------------------------------------------
if (run && !/[^A-Z0-9$_]/i.test(run)) new Function('if(typeof '+run+' == "function"){'+run+'('+argv+');}')();
//
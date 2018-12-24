//  This JS script is used internally by the main "No-Bling DOTA mod builder.bat" launcher                    edited in SynWrite
// v2018.12.24: Merry Christmas!  
// - decoupled manual filters into No-Bling-filters.txt 
// - MagusCypher choice to revert Rubick arcana stolen abilities to default.. or not   
// - potato-optimized, less distracting Festive Fireworks, Snowman and UI snow; moved to Seasonal choice  
// - generate unified src.lst for streamlined content update; fixed Node.js processing   
//------------------------------------------------------------------------------------------------------------------------------

// No_Bling JS main function that does the processing of items_game.txt heavy lifting
//------------------------------------------------------------------------------------------------------------------------------
No_Bling=function(choices, verbose, timers){
  w.echo(""+run+" @ "+engine+((jscript) ? ": Try the faster Node.js engine" : "")); w.echo("------------------------");

  // Parse arguments
  var ABILITIES      = (choices.indexOf("Abilities") > -1);    // - Penguin Frostbite and stuff like that..
  var HATS           = (choices.indexOf("Hats") > -1);         // - Cosmetic particles spam - slowly turning into TF2..
  var COURIERS       = (choices.indexOf("Couriers") > -1);     // - Couriers particles are fine.. until one abuses gems on hats
  var WARDS          = (choices.indexOf("Wards") > -1);        // - Just a few of them make the ward and the sentry item similar

  var HEROES         = (choices.indexOf("HEROES") > -1);       // - Default hero-bundled effects  - helps potato pc
  var MAGUSCYPHER    = (choices.indexOf("MagusCypher") > -1);  // - Stolen spells via Rubick Arcana

  var SEASONAL       = (choices.indexOf("Seasonal") > -1);     // - Frostivus; The International custom tp, blink etc.
  var BASE           = (choices.indexOf("Base") > -1);         // - Base buildings - ancients, barracks, towers
  var EFFIGIES       = (choices.indexOf("Effigies") > -1);     // - Effigies
  var SHRINES        = (choices.indexOf("Shrines") > -1);      // - Shrines
  var TERRAIN        = (choices.indexOf("Terrain") > -1);      // - Terrain - bundled weather, lights, props
  var MENU           = (choices.indexOf("Menu") > -1);         // - Menu - ui, hero preview

  var LOG            = (verbose == "1");                       // Exports detailed per-hero lists, useful for debugging mod
  var MEASURE        = (timers == "1"); if (!MEASURE) timer = function(f){ return { end:function(){} }; }; var t;
  
  // Quit early if no choice selected
  var HAS_CHOICE=(ABILITIES||HATS||COURIERS||WARDS||HEROES||MAGUSCYPHER||SEASONAL||BASE||EFFIGIES||SHRINES||TERRAIN||MENU);
  if (!HAS_CHOICE && !LOG) w.quit();

  // Initiate filter variables
  var ROOT = path.normalize(path.dirname(process.argv[1])); // Root directory
  var FILTERS_FILE = path.normalize(ROOT+"\\No-Bling-filters.txt"); // Default filters file (auto-updated) 
  var FILTERS_FILE_PERSONAL = path.normalize(ROOT+"\\No-Bling-filters-personal.txt"); // Personal file is not overwritten
  if (FileExists(FILTERS_FILE_PERSONAL)) FILTERS_FILE = FILTERS_FILE_PERSONAL; // Use No-Bling-filters-personal.txt if found          
  // Quit if filters file not found
  if (!FileExists(FILTERS_FILE)){ w.echo("ERROR! "+FILTERS_FILE+" missing!"); w.quit(); }

  var ACTIVE_EVENT="EVENT_ID_INTERNATIONAL_2018"; // Hard-coded current event for the Seasonal category
  var off="particles/dev/empty_particle.vpcf"; // Disable particle files by replacing them with default empty particle
  var logs={ "Wearables":{},"HEROES":{},"Couriers":{},"Wards":{},"Seasonal":{},"Other":{} };
  var mods={ "Abilities":{},"Hats":{},"Couriers":{},"Wards":{},"Seasonal":{},
             "HEROES":{},"MagusCypher":{},
             "Base":{},"Effigies":{},"Shrines":{},"Weather":{},"Menu":{}, "Other":{} };
  var filters={}, KEEP_HERO={}, KEEP_ITEM={}, KEEP_RARITY={}, KEEP_FILE={}, REV_KEEP={}, REV_MOD={};  
  for (var mcat in mods){ filters[mcat]={}; }

  // Read and vdf.parse default No-Bling-filters.txt or No-Bling-filters-personal.txt if exist
  var vdf=ValveDataFormat();
  var bling_filters=vdf.parse(fs.readFileSync(FILTERS_FILE, DEF_ENCODING)).no_bling_filters;
  w.echo("Using "+FILTERS_FILE+" v"+bling_filters[":version"]);

  for (var bcat in bling_filters){
    if (typeof bling_filters[bcat] != "object" || typeof filters[bcat] != "object") continue; // ignore non-category
    for (var b in bling_filters[bcat]){
      switch (bling_filters[bcat][b]){
        case "+":
          filters[bcat][b]=off; break;             // replace "file" with empty asset
        case "++":
          REV_MOD[b]=1; break;                     // replace all modifiers referencing "file" with empty asset (reverse lookup)
        case "-":
          KEEP_FILE[b]=1; break;                   // keep "file"
        case "--":
          REV_KEEP[b]=1; break;                    // keep all modifiers referencing "file" (reverse-lookup)
        case "@":
          KEEP_HERO[b]=1; break;                   // keep all modifiers for hero "hero"
        case "#":
          KEEP_ITEM[b]=1; break;                   // keep all modifiers for item id "number"
        case "$":
          KEEP_RARITY[b]=1; break;                 // keep all modifiers for rarity "rarity"
        default:
          filters[bcat][b]=bling_filters[bcat][b]; // replace "modifier" with "asset" from dota/pak01_dir.vpk
        break;
      }
    } 
  }

  // Read and vdf.parse items_game.txt
  var items_game_src=path.normalize(ROOT+"\\src\\scripts\\items\\items_game.txt");
  t=timer("Read items_game.txt");
  var items_game_read=fs.readFileSync(items_game_src, DEF_ENCODING);
  t.end();
  //var vdf=ValveDataFormat();
  t=timer("VDF.parse items_game.txt");
  var items_game_parsed=vdf.parse(items_game_read);
  t.end();
  // Optionally export vdf.stringify result for verification purposes
  if (LOG){
    t=timer("VDF.stringify items_game.txt");
    var items_game_stringify=vdf.stringify(items_game_parsed,true);
    t.end();
    var items_game_out=path.normalize(ROOT+"\\log\\items_game.txt");
    t=timer("Write items_game.txt");
    fs.writeFileSync(items_game_out, items_game_stringify, DEF_ENCODING);
    t.end();
  }

  //----------------------------------------------------------------------------------------------------------------------------
  // 1. Loop trough all items, skipping over irrelevant categories and optionally generate accurate slice logs
  //----------------------------------------------------------------------------------------------------------------------------
  if (LOG) t=timer("--- Check items_game");
  var items=items_game_parsed.items_game.items, used_by_heroes={};
  for (var i in items){
    var precat="",cat="", expired="",logitem="", hero="NO", has_particles=false,maybe_ability={},maybe_hat={}, iid=vdf.redup(i);
    var prefab=items[i].prefab || "", rarity=items[i].item_rarity || "", iname=items[i].item_name.replace("#DOTA_Item_","");
    if (typeof items[i].prefab != "string") continue;        // skip if not having .prefab - the hidden item #TF_Default_ItemDef
    if (typeof items[i].visuals != "object") continue;                                            // skip if not having .visuals
    // guess hero name
    if (typeof items[i].used_by_heroes == "object"){
      for (var h in items[i].used_by_heroes){if (h.indexOf("_dota_") > -1) hero=h.split("_dota_")[1];}
      hero=(hero.indexOf("hero_") > -1) ? h.split("hero_")[1] : "NO"; used_by_heroes[hero]="";
    }
    // convert prefab categories
    if (prefab == "wearable" || prefab == "bundle") precat="Wearables"; else if (prefab == "default_item") precat="HEROES";
    else if (prefab == "courier" || prefab == "courier_wearable") precat="Couriers"; else if (prefab == "ward") precat="Wards";
    else if (prefab == "tool" || prefab == "relic" || prefab == "emblem" || prefab == "treasure_chest") precat="Seasonal";
    else precat="Other"; // 7.10: relic renamed to emblem..
    // guess expiration
    if (precat == "Seasonal" || precat == "Other"){
      var age=(typeof items[i].expiration_date == "string") ? items[i].expiration_date.split(" ")[0].split(/\-0|\-/g) : "";
      if(!age && typeof items[i].creation_date == "string"){age=items[i].creation_date.split("-");age[0]=parseInt(age[0],10)+1;}
      expired=(age && Date.UTC(age[0],age[1],age[2]) - new Date().getTime() < 0);
      if (items[i].event_id != ACTIVE_EVENT) expired=true;              // hard-coded ACTIVE_EVENT = EVENT_ID_INTERNATIONAL_2018
      if (items[i].event_id == "EVENT_ID_INTERNATIONAL_2017") expired=false;// re-enable expired TI7 Effects for replays viewing
    }
    // generate item category tracking text for debugging
    if (LOG) logitem="  "+iname+" ["+hero+"] "+prefab+" "+(rarity ? rarity+" " : "")+iid+RN;

    // Still in the item i loop above, check visuals section for asset_modifier* particles
    for (var f in items[i].visuals){
      var visuals=items[i].visuals[f];      // .visuals object - dont use exact naming since vdf.parser auto-renamed duplicates
      var type=(typeof visuals.type == "string" && visuals.type.indexOf("particle") === 0 ) ? visuals.type : "";
      if (!type || type == "particle_control_point" || type == "particle_combined") continue;//skip non particle/particle_create
      var modifier=(typeof visuals.modifier == "string" && visuals.modifier.lastIndexOf(".vpcf") > -1) ? visuals.modifier : "";
      var asset=(typeof visuals.asset == "string" && visuals.asset.lastIndexOf(".vpcf") > -1) ? visuals.asset : "";
      // INSERT PARTICLE SNAPSHOTS TO NON-PARTICLE BASED OVERRIDE (IN THE HATS CATEGORY)
      if (typeof visuals.asset == "string" && visuals.asset.lastIndexOf(".vsnap") > -1) { 
        filters["Other"][visuals.modifier]=visuals.asset; logitem+= "      SNAPSHOT "+modifier+RN;
      }
      if (modifier == asset) continue; // skip if both modifier and asset are the same / not defined / not .vpcf particle files
      if (modifier && modifier.lastIndexOf("null.vpcf") > -1) continue;                                  // skip dummy modifiers
      if (modifier && modifier.lastIndexOf("_local.vpcf") > -1) continue;                               // skip staged modifiers
      if (asset && asset.indexOf("particles/ability_modifier") > -1) continue;   //TODO//              // skip dynamic modifiers
      if (asset && asset.indexOf("particles/reftononexistent") > -1) asset=off;                       // skip dynamic references
      if (asset && asset in REV_KEEP){KEEP_FILE[modifier]=1;if (LOG) logitem+="      rev_skip: "+modifier+RN; continue;}
      if (asset && asset in REV_MOD){asset=off;if (LOG) logitem+="      rev_mod: "+modifier+RN; }               //reverse lookup 
      // ABILITIES AND HATS
      if (precat == "Wearables" && type == "particle"){
        // expecting .asset
        if (modifier.indexOf("particles/econ/items") > -1){
          // Abilities mostly but we can have Hats, too. Separating them is not simple, but Gaben shall not prevail!
          if (LOG) logitem+= "      maybe_ability? "+modifier+RN;
          if (asset && asset.indexOf("particles/econ/items") > -1){
            cat="Hats"; mods[cat][modifier]=off;                                            // mod (disable) modifier by default
            if (LOG) logitem+= "      hat: "+modifier+RN;
          } else {
            cat="Abilities"; maybe_ability[modifier]= (asset) ? asset : off;                         // use found asset if valid
          }
        } else if (modifier.indexOf("particles/units/heroes") > -1){
          if (hero == "rubick" && rarity == "arcana"){
            //cat="Abilities"; maybe_ability[modifier]= (asset) ? asset : off;  
            mods["MagusCypher"][modifier]= (asset) ? asset : off;                              // Rubick Arcana stolen abilities
            if (LOG) logitem+= "        stolen ability! "+modifier+RN;
          } else { 
            cat="HEROES"; if (LOG) logitem+= "      ignore_hero: "+modifier+RN;                              // just log ignored
          }  
        } else {
          cat="Other"; //mods[cat][modifier]=(asset) ? asset : off;                                         // just log ignored
          if (LOG) logitem+= "      skip_other1: "+modifier+RN;
        }
        has_particles = true;
      } else if (precat == "Wearables" && type == "particle_create"){
        // not expecting .asset
        if (modifier.indexOf("particles/econ/items") > -1){
          cat="Hats"; // Hats mostly
          mods[cat][modifier]=off;                                                          // mod (disable) modifier by default
          if (asset && asset.indexOf("particles/econ/items") == -1){
            mods[cat][modifier]=(asset) ? asset : off;                                               // use found asset if valid
          }
          if (LOG) logitem+= "      hat: "+modifier+RN;
        } else if (modifier.indexOf("particles/units/heroes") > -1){
          cat="HEROES"; // Default item overrides
          mods[cat][modifier]=(asset) ? asset : off; maybe_hat[modifier]=(asset) ? asset : off;
          if (LOG) logitem+= "      maybe_hat? "+modifier+RN;
        } else {
          cat="Other"; //mods[cat][modifier]=(asset) ? asset : off;                                         // just log ignored
          if (LOG) logitem+= "      skip_other2: "+modifier+RN;
        }
        has_particles = true;
      }
      // HEROES default
      if (precat == "HEROES"){
        if (modifier.indexOf("particles/units/heroes") > -1){
          cat="HEROES"; mods[cat][modifier]=off; has_particles = true;
          if (LOG) logitem+= "      hero: "+modifier+RN;
        }
      }
      // COURIERS
      if (precat == "Couriers"){
        cat="Couriers"; mods[cat][modifier]=(asset) ? asset : off; has_particles = true;
        if (LOG) logitem+= "      courier: "+modifier+RN;
      }
      // WARDS
      if (precat == "Wards"){
        cat="Wards"; mods[cat][modifier]=(asset) ? asset : off; has_particles = true;
        if (LOG) logitem+= "      ward: "+modifier+RN;
      }
      // SEASONAL
      if (precat == "Seasonal"){
        if (expired && !(vdf.nr(iid) in KEEP_ITEM)) continue;
        cat="Seasonal"; mods[cat][modifier]=(asset) ? asset : off; has_particles = true;
        if (LOG) logitem+= "      seasonal: "+modifier+RN;
      }
      // OTHER
      if (precat == "Other"){
        if (expired && !(vdf.nr(iid) in KEEP_ITEM)) continue;
        cat="Other"; mods[cat][modifier]=(asset) ? asset : off; has_particles = true;
        if (LOG) logitem+= "      other: "+modifier+RN;
      }
      // add generic manual particle filters
      if (rarity && rarity in KEEP_RARITY){
        KEEP_FILE[modifier]=1; if (LOG) logitem+= "    skip_"+rarity+": "+path.basename(modifier)+RN;
      }
      for (var shero in KEEP_HERO){
        if (modifier.indexOf(shero+"/") > -1){
          KEEP_FILE[modifier]=1; if(LOG) logitem+="    skip_"+hero+": "+path.basename(modifier)+RN;
        }
      }
      if (iid && vdf.nr(iid) in KEEP_ITEM){
        KEEP_FILE[modifier]=1; if (LOG) logitem+= "    skip_"+iid+": "+path.basename(modifier)+RN;
      }
    } // next f in visuals section

    // Separate Hats from Abilities out of the ambiguous visuals.asset_modifier.type="particle"
    for (var hat in maybe_ability){
      if (maybe_ability[hat] in maybe_hat){
        if (maybe_ability[hat] in mods["HEROES"]){
          mods["Hats"][hat]=maybe_ability[hat];
          if (LOG) logitem+= "        hat! "+path.basename(hat)+RN;
        } else {
          mods["Abilities"][hat]=maybe_ability[hat];
          if (LOG) logitem+= "        ability! "+path.basename(hat)+RN; // none?!
        }
      } else {
        if (maybe_ability[hat] in mods["HEROES"]){
          mods["Hats"][hat]=maybe_ability[hat];
          if (LOG) logitem+= "        hat! "+path.basename(hat)+RN;
        } else {
          mods["Abilities"][hat]=maybe_ability[hat];
          if (LOG) logitem+= "        ability! "+path.basename(hat)+RN;
        }
      }
    }

    // Find portrait particle definitions and add them to Menu filters
    if (typeof items[i].portraits == "object"){
      for (var p in items[i].portraits){
        if (typeof items[i].portraits[p] != "object") continue;
        if (typeof items[i].portraits[p].PortraitParticle != "string") continue;
        if (items[i].portraits[p].PortraitParticle.indexOf("portrait") < 1) continue;
        if (items[i].portraits[p].PortraitParticle in KEEP_FILE) continue;
        filters["Menu"][items[i].portraits[p].PortraitParticle]=off; has_particles=true;
      }
    }

    // Skip if no particles found for item i
    if (!has_particles) continue;

    // Optionally generate per-hero / category items_game.txt log slices keeping original indenting
    if (LOG){
      if (hero != "NO"){                                                                                       // per-hero items
        var herocat=(prefab == "default_item") ? "HEROES" : "Wearables";
        if (!logs[herocat][hero]) logs[herocat][hero]={};
        if (!logs[herocat][hero][i]) logs[herocat][hero][i]={};         // for convenience,
        if (!logs[herocat][hero][i]["items_game"]) logs[herocat][hero][i]["items_game"]={};
        if (!logs[herocat][hero][i]["items_game"]["items"]) logs[herocat][hero][i]["items_game"]["items"]={};
        if (!logs[herocat][hero][i]["items_game"]["items"][i+""]) logs[herocat][hero][i]["items_game"]["items"][i+""]=items[i];
      } else {                                                                                                 // non-hero items
        if (!logs[precat]) logs[precat]={};
        if (!logs[precat][i]) logs[precat][i]={};
        if (!logs[precat][i]["items_game"]) logs[precat][i]["items_game"]={};
        if (!logs[precat][i]["items_game"]["items"]) logs[precat][i]["items_game"]["items"]={};
        if (!logs[precat][i]["items_game"]["items"][i+""]) logs[precat][i]["items_game"]["items"][i+""]=items[i];
      }
    }

    // Optionally print item category tracking text for debugging in one go
    if (LOG && hero!="NO" && has_particles) w.echo(logitem);

  }  // next item i loop
  if (LOG) t.end();

  //----------------------------------------------------------------------------------------------------------------------------
  // 2. Loop trough generic attached_particles definitions in items_game.txt - these are mostly for Hats & Courier trails
  //----------------------------------------------------------------------------------------------------------------------------
  if (LOG) t=timer("--- Check generic attached_particles");
  var attached_particles=items_game_parsed.items_game.attribute_controlled_attached_particles;
  for (var ap in attached_particles){
    if (typeof attached_particles[ap] != "object") continue;                                               // skip if not object
    var generic=attached_particles[ap], existing=false;
    modifier=(typeof generic.system == "string" && generic.system.lastIndexOf(".vpcf") > -1) ? generic.system : "";
    if (!modifier) continue;                                                                    // skip not .vpcf particle files
    for (cat in mods){if (modifier in mods[cat]) existing=true;}
    if (existing) continue;                                                                             // do not override items
    if (modifier.indexOf("particles/units/heroes") > -1){
      mods["HEROES"][modifier]=off; if (LOG) w.echo("  hero: "+modifier);
    } else if (modifier.indexOf("particles/econ/items") > -1){
      mods["Hats"][modifier]=off; if (LOG) w.echo("  hat: "+modifier);
    } else if (modifier.indexOf("particles/econ/courier") > -1){
      mods["Couriers"][modifier]=off; if (LOG) w.echo("  courier: "+modifier);
    } else if (modifier.indexOf("particles/econ/wards") > -1){
      mods["Wards"][modifier]=off; if (LOG) w.echo("  ward: "+modifier);
    }
    // add generic manual particle filters
    for (shero in KEEP_HERO){
      if (modifier.indexOf(shero+"/") > -1){KEEP_FILE[modifier]=1; if (LOG) w.echo("    skip_"+hero+": "+modifier);}
    }
  } // next ap
  if (LOG) t.end();

  //----------------------------------------------------------------------------------------------------------------------------
  // 3. Loop trough generic asset_modifiers definitions in items_game.txt - these are mostly for custom Abilities effects
  //----------------------------------------------------------------------------------------------------------------------------
  if (LOG) t=timer("--- Check generic asset_modifiers");
  var asset_modifiers=items_game_parsed.items_game.asset_modifiers;
  for (var am in asset_modifiers){
    if (typeof asset_modifiers[am] != "object") continue;                                                  // skip if not object
    for (var m in asset_modifiers[am]){
      generic=asset_modifiers[am][m]; existing=false;
      if (typeof generic.type == "string" && generic.type == "particle"){
        modifier=(typeof generic.modifier == "string" && generic.modifier.lastIndexOf(".vpcf") > -1) ? generic.modifier : "";
        asset=(typeof generic.asset == "string" && generic.asset.lastIndexOf(".vpcf") > -1) ? generic.asset : "";
        if (!modifier || !asset) continue;               // skip if modifier or asset are not defined / not .vpcf particle files
        for (cat in mods){if (modifier in mods[cat]) existing=true;}
        if (existing) continue;                                                                         // do not override items
        if (asset in REV_KEEP){ KEEP_FILE[modifier]=1; if (LOG) w.echo("    rev_skip: "+path.basename(modifier)); continue;}
        if (asset in REV_MOD)  { asset=off; if (LOG) w.echo("    rev_mod: "+path.basename(modifier));  } // reverse mod
        mods["Abilities"][modifier]=asset;
        if (LOG) w.echo("  ability: "+modifier);
        // add generic manual particle filters
        for (shero in KEEP_HERO){
          if (modifier.indexOf(shero+"/") > -1){KEEP_FILE[modifier]=1;if (LOG) w.echo("    skip_"+hero+": "+modifier);}
        }
      }
    } // next m
  } // next am
  if (LOG) t.end();

  //----------------------------------------------------------------------------------------------------------------------------
  // 4. Import manual filters defined at the top of this script and sanitize categories
  //----------------------------------------------------------------------------------------------------------------------------
  if (LOG) t=timer("--- Import manual filters");
  for (hat in KEEP_FILE){
    for (filtercat in mods) delete mods[filtercat][hat];
    if (LOG) w.echo("  skip: "+hat);
  }
  for (hat in REV_KEEP){ delete mods["HEROES"][hat];  if (LOG) w.echo("  rev_skip: "+hat); }
  for (hat in REV_MOD){ mods["HEROES"][hat]=off;  if (LOG) w.echo("  rev_mod: "+hat); }
  for (cat in filters) {
    for (hat in filters[cat]) {
      mods[cat][hat]=filters[cat][hat]; if (LOG) w.echo("  mod_"+cat+": "+hat);
    }
  }

  // Heroes option supersedes Hats option so include non-moded particles (its also where the Rubick Arcana custom abilities go)
/*
  for (hat in mods["Hats"]){
    if (mods["Hats"][hat]!=off && !(mods["Hats"][hat] in KEEP_FILE)){
      mods["HEROES"][hat]=off;if (LOG) w.echo("  hero_include: "+hat)
    }
  }
*/
  if (LOG) t.end();

  //----------------------------------------------------------------------------------------------------------------------------
  // 5. Optionally log to file per-hero / category items lists
  //----------------------------------------------------------------------------------------------------------------------------
  if (LOG){
    t=timer("Write per-hero / category slice logs to file");
    for (cat in logs){
      if (typeof logs[cat] != "object") continue;
      var islot="";
      if (cat == "HEROES" || cat == "Wearables"){ // per-hero items
        for (hero in used_by_heroes){
          for (item in logs[cat][hero]){
            iname=logs[cat][hero][item].items_game.items[item].item_name.replace("#DOTA_Item_","").replace("#DOTA_","");
            islot=logs[cat][hero][item].items_game.items[item].item_slot || ""; item_slot=(islot) ? "_"+islot : "";
            logitem="./log/"+cat+"/"+hero+"/"+iname+"_"+vdf.redup(item)+item_slot+".txt"; MakeDir("./log/"+cat+"/"+hero+"/");
            fs.writeFileSync(path.normalize(logitem), vdf.stringify(logs[cat][hero][item],true), DEF_ENCODING);
          }
        }
      } else {  // non-hero items
        for (item in logs[cat]){
          iname=logs[cat][item].items_game.items[item].item_name.replace("#DOTA_Item_","").replace("#DOTA_","");
          islot=logs[cat][item].items_game.items[item].item_slot || ""; item_slot=(islot) ? "_"+islot : "";
          logitem="./log/"+cat+"/"+iname+"_"+vdf.redup(item)+item_slot+".txt"; MakeDir("./log/"+cat+"/");
          fs.writeFileSync(path.normalize(logitem), vdf.stringify(logs[cat][item],true), DEF_ENCODING);
        }
      }
    }
    t.end();
  } // end log to file

  //----------------------------------------------------------------------------------------------------------------------------
  // 6. Write particle?mod definitions for each category used for lame file replacement - RIP m_hLowViolenceDef after 7.07
  //----------------------------------------------------------------------------------------------------------------------------
  if (!HAS_CHOICE) w.quit();   // Do not output source files if no choice selected other than verbose (LOG)
  t=timer("Write particle?mod definitions for each src category");
  var src_lst=path.normalize(ROOT+"\\src\\src.lst"), src_data={}, data="";
  MakeDir(path.dirname(src_lst));
  for (cat in mods){
    var count=0, mod_ini=path.normalize(ROOT+"\\src\\"+cat+".ini"), mod_data={};
    for (hat in mods[cat]){
      mod_data[hat.split("/").join("\\") + "_c?" + mods[cat][hat].split("/").join("\\") + "_c"]=1;
      src_data[mods[cat][hat].split("/").join("\\") + "_c"]=1;
      count++;
    } // next hat
    if (count>0) {
      data="["+cat+"]\r\n"; for (i in mod_data){ data += i+"\r\n"; } fs.writeFileSync(mod_ini, data, DEF_ENCODING); 
    }
  } // next cat
  data=""; for (i in src_data){ data += i+"\r\n"; } fs.writeFileSync(src_lst, data, DEF_ENCODING); // combined src listing
  t.end();

}; // End of No_Bling

//------------------------------------------------------------------------------------------------------------------------------
// Utility JS functions - callable independently
//------------------------------------------------------------------------------------------------------------------------------
LOptions=function(fn, options, _flag){
  // fn:localconfig.vdf    options:separated by ,    _flag: -read=print -remove=delete -add=default if ommited
  var regs={}, lo=options.split(","), i=0,n=lo.length;
  for (i=0;i<n;i++){
    regs[lo[i]]=new RegExp("(" + lo[i].split(" ")[0].replace(/([-+])/,"\\$1")+((lo[i].indexOf(" ")==-1) ?")":" [\\w%]+)"),"gi");
  }
  var flag=_flag || "-add", file=path.normalize(fn), data=fs.readFileSync(file, DEF_ENCODING), vdf=ValveDataFormat();
  var parsed=vdf.parse(data), dota=getKeYpath(parsed,"UserLocalConfigStore/Software/Valve/Steam/Apps/"+vdf.nr("570"));
  if (flag == "-read"){ var found=dota["LaunchOptions"]; if (found) w.echo(found); return; }  // print existing options and exit
  if (typeof dota["LaunchOptions"] == "undefined" || dota["LaunchOptions"] === ""){
    dota["LaunchOptions"]=(flag != "-remove") ? lo.join(" ") : "";                         // no launch options defined, add all
  } else {
    for (i=0;i<n;i++){
      if (lo[i] !== ""){
        if (regs[lo[i]].test(dota["LaunchOptions"])){
          if (flag == "-remove") dota["LaunchOptions"]=dota["LaunchOptions"].replace(regs[lo[i]], "");//found exist, delete 1by1
          else dota["LaunchOptions"]=dota["LaunchOptions"].replace(regs[lo[i]], lo[i]);              //found exist, replace 1by1
        } else {
          if (flag != "-remove") dota["LaunchOptions"]+=" "+lo[i];                                   //not found exist, add 1by1
        }
      }
    }
  }
  dota["LaunchOptions"]=dota["LaunchOptions"].replace(/\s\s+/g, " ");                 // replace multiple spaces between options
  fs.writeFileSync(fn, vdf.stringify(parsed,true), DEF_ENCODING);                // update fn if flag is -add -remove or ommited
};
function getKeYpath(obj,kp){
  var test=kp.split("/");
  var out=obj;
  for (var i=0;i<test.length;i++) {
    for (var KeY in out) {
      if (out.hasOwnProperty(KeY) && (KeY+"").toLowerCase()==(test[i]+"").toLowerCase()) {out=out[KeY];/*w.echo("found "+KeY)*/}
    }
  }
  return out;
}

OutChars=function(s){ new Function("w.echo(String.fromCharCode("+s+"))")(); };

//------------------------------------------------------------------------------------------------------------------------------
// ValveDataFormat hybrid js parser by AveYo, 2016                                            VDF test on 20.1 MB items_game.txt
// loosely based on vdf-parser by Rossen Popov, 2014-2016                                                       node.js  cscript
// featuring auto-renaming duplicate keys, saving comments, grabbing lame one-line "key" { "k" "v" }     parse:  1.329s   9.285s
// greatly improved cscript performance - it"s not that bad overall but still lags behind node.js    stringify:  0.922s   3.439s
//------------------------------------------------------------------------------------------------------------------------------
function ValveDataFormat(){
  var jscript=(typeof ScriptEngine == "function" && ScriptEngine() == "JScript");
  if (!jscript){ var w={}; w.echo=function(s){console.log(s+"\r");}; } else { w=WScript; }
  var order=!jscript, dups=false, comments=false, newline="\n", empty=(jscript) ? "" : undefined;
  return {
    parse: function(txt, flag){
      var obj={}, stack=[obj], expect_bracket=false, i=0; comments=flag || false;
      if (/\r\n/.test(txt)){newline="\r\n";} else newline="\n";
      var m, regex =/[^""\r\n]*(\/\/.*)|"([^""]*)"[ \t]+"(.*)"|"([^""]*)"|({)|(})/g;
      while ((m=regex.exec(txt)) !== null){
        //lf="\n"; w.echo(" cmnt:"+m[1]+lf+" key:"+m[2]+lf+" val:"+m[3]+lf+" add:"+m[4]+lf+" open:"+m[5]+lf+" close:"+m[6]+lf);
        if (comments && m[1] !== empty){
          i++;key="\x10"+i; stack[stack.length-1][key]=m[1];                                  // AveYo: optionally save comments
        } else if (m[4] !== empty){
          key=m[4]; if (expect_bracket){ w.echo("VDF.parse: invalid bracket near "+m[0]); return this.stringify(obj,true); }
          if (order && key == ""+~~key){key="\x11"+key;}           // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (typeof stack[stack.length-1][key] == "undefined"){
            stack[stack.length-1][key]={};
          } else {
            i++;key+= "\x12"+i; stack[stack.length-1][key]={}; dups=true;         // AveYo: rename duplicate key obj with \x12+i
          }
          stack.push(stack[stack.length-1][key]); expect_bracket=true;
        } else if (m[2] !== empty){
          key=m[2]; if (expect_bracket){ w.echo("VDF.parse: invalid bracket near "+m[0]); return this.stringify(obj,true); }
          if (order && key == ""+~~key) key="\x11"+key;            // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (typeof stack[stack.length-1][key] !== "undefined"){ i++;key+= "\x12"+i; dups=true; }// AveYo: rename duplicate k-v
          stack[stack.length-1][key]=m[3]||"";
        } else if (m[5] !== empty){
          expect_bracket=false; continue; // one level deeper
        } else if (m[6] !== empty){
          stack.pop(); continue; // one level back
        }
      }
      if (stack.length != 1){ w.echo("VDF.parse: open parentheses somewhere"); return this.stringify(obj,true); }
      return obj; // stack[0];
    },
    stringify: function(obj, pretty, nl){
      if (typeof obj != "object"){ w.echo("VDF.stringify: Input not an object"); return obj; }
      pretty=( typeof pretty == "boolean" && pretty) ? true : false; nl=nl || newline || "\n";
      return this.dump(obj, pretty, nl, 0);
    },
    dump: function(obj, pretty, nl, level){
      if (typeof obj != "object"){ w.echo("VDF.stringify: Key not string or object"); return obj; }
      var indent="\t", buf="", idt="", i=0;
      if (pretty){for (; i < level; i++) idt+= indent;}
      for (var key in obj){
        if (typeof obj[key] == "object")  {
          buf+= idt+'"'+this.redup(key)+'"'+nl+idt+'{'+nl+this.dump(obj[key], pretty, nl, level+1)+idt+'}'+nl;
        } else {
          if (comments && key.indexOf("\x10") !== -1){ buf+= idt+obj[key]+nl; continue; }  // AveYo: restore comments (optional)
          buf+= idt+'"'+this.redup(key)+'"'+indent+indent+'"'+obj[key]+'"'+nl;
        }
      }
      return buf;
    },
    redup: function(key){
      if (order && (key+"").indexOf("\x11") !== -1) key=key.split("\x11")[1];           // AveYo: restore number keys in node.js
      if (dups && (key+"").indexOf("\x12") !== -1) key=key.split("\x12")[0];               // AveYo: restore duplicate key names
      return key;
    },
    nr: function(key){return (!jscript && (key+"").indexOf("\x11") == -1) ? "\x11"+key : key;}  // AveYo: check nr: vdf.nr("nr")
  };
} // End of ValveDataFormat

//------------------------------------------------------------------------------------------------------------------------------
// Hybrid Node.js / JScript Engine by AveYo - can call specific functions as the first script argument
//------------------------------------------------------------------------------------------------------------------------------
if (typeof ScriptEngine == "function" && ScriptEngine() == "JScript"){
  // start of JScript specific code
  jscript=true;engine="JScript";w=WScript;launcher=new ActiveXObject("WScript.Shell"); argc=w.Arguments.Count();argv=[]; run="";
  if (argc > 0){ run=w.Arguments(0); for (var i=1;i<argc;i++) argv.push( '"'+w.Arguments(i).replace(/[\\\/]+/g,"\\\\")+'"'); }
  process={};process.argv=[ScriptEngine(),w.ScriptFullName];for (var j=0;j<argc;j++) process.argv[j+2]=w.Arguments(j);RN="\r\n";
  path={}; path.join=function(f,n){return fso.BuildPath(f,n);}; path.normalize=function(f){return fso.GetAbsolutePathName(f);};
  path.basename=function(f){return fso.GetFileName(f);};path.dirname=function(f){return fso.GetParentFolderName(f);};
  fs={};fso=new ActiveXObject("Scripting.FileSystemObject"); ado=new ActiveXObject("ADODB.Stream"); DEF_ENCODING="Windows-1252";
  FileExists=function(f){ return fso.FileExists(f); }; PathExists=function(f){ return fso.FolderExists(f); }; path.sep="\\";
  MakeDir=function(fn){
    if (fso.FolderExists(fn)) return; var pfn=fso.GetAbsolutePathName(fn), d=pfn.match(/[^\\\/]+/g), p="";
    for(var i=0,n=d.length; i<n; i++){ p+= d[i]+"\\"; if (!fso.FolderExists(p)) fso.CreateFolder(p); }
  };
  fs.readFileSync=function(fn, charset){
    var data=""; ado.Mode=3; ado.Type=2; ado.Charset=charset || "Windows-1252"; ado.Open(); ado.LoadFromFile(fn);
    while (!ado.EOS) data+= ado.ReadText(131072); ado.Close(); return data;
  };
  fs.writeFileSync=function(fn, data, encoding){
    ado.Mode=3; ado.Type=2; ado.Charset=encoding || "Windows-1252"; ado.Open();
    ado.WriteText(data); ado.SaveToFile(fn, 2); ado.Close(); return 0;
  };
  // end of JScript specific code
} else {
  // start of Node.js specific code
  jscript=false;engine="Node.js";w={}; argc=process.argv.length; argv=[]; run=""; p=process.argv; w.quit=process.exit;RN="\r\n";
  if (argc > 2){ run=p[2]; for (var n=3;n<argc;n++) argv.push('"'+p[n].replace(/[\\\/]+/g,"\\\\")+'"'); }
  path=require("path"); fs=require("fs"); DEF_ENCODING="utf-8"; w.echo=function(s){console.log(s+"\r");};
  FileExists=function(f){ try{ return fs.statSync(f).isFile(); }catch(e){ if (e.code == "ENOENT") return false; } };
  PathExists=function(f){ try{ return fs.statSync(f).isDirectory(); }catch(e){ if (e.code == "ENOENT") return false; } };
  MakeDir=function(f){ try{ fs.mkdirSync(f); }catch(e){ if (e.code == "ENOENT"){ MakeDir(path.dirname(f)); MakeDir(f); } } };
  // end of Node.js specific code
}
function timer(hint){
  var s=new Date(); return { end:function(){ var e=new Date(), t=(e.getTime()-s.getTime())/1000; w.echo(hint+": "+t+"s"); } };
}
// If run without parameters the .js file must have been double-clicked in shell, so try to launch the correct .bat file instead
if (jscript&&run===""&&FileExists(w.ScriptFullName.slice(0, -2)+"bat")) launcher.Run('"'+w.ScriptFullName.slice(0, -2)+"bat\"");
//------------------------------------------------------------------------------------------------------------------------------
// Auto-run JS: if first script argument is a function name - call it, passing the next arguments
//------------------------------------------------------------------------------------------------------------------------------
if (run && !(/[^A-Z0-9$_]/i.test(run))) new Function("if(typeof "+run+" == \"function\"){"+run+"("+argv+");}")();
//

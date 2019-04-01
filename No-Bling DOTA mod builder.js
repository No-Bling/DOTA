//  This JS script is used internally by the main "No-Bling DOTA mod builder.bat" launcher                    edited in SynWrite
// v2019.03.30: (\_/)
// - completed Poor Man's Shield against the Bling!
// - revised categories and extended loadout particles support                                                 
// - output unified src.lst for in-memory modding via VPKMOD tool
// - decoupled manual filters into No-Bling-filters.txt
//------------------------------------------------------------------------------------------------------------------------------

// No_Bling JS main function that does the processing of items_game.txt heavy lifting
//------------------------------------------------------------------------------------------------------------------------------
No_Bling=function(choices, verbose, timers){
  var ACTIVE_EVENT = "EVENT_ID_INTERNATIONAL_2018";          // Hard-coded current event (for the Seasonal category)
  var PAST_EVENT   = "EVENT_ID_INTERNATIONAL_2017";          // Hard-coded older event (for replay viewing)
  // Parse arguments
  var BASE         = (choices.indexOf("Base") > -1);         // - tweak buildings - barracks, effigies, shrines       CORE BUILD
  var WEATHER      = (choices.indexOf("Weather") > -1);      // - tweak weather bundled with terrains, lights, props
  var SEASONAL     = (choices.indexOf("Seasonal") > -1);     // - tweak Frostivus; the International custom tp, blink etc.
  var MENU         = (choices.indexOf("Menu") > -1);         // - tweak menu - ui, hero loadout and preview, treasure opening

  var ABILITIES    = (choices.indexOf("Abilities") > -1);    // - revert penguin Frostbite and stuff like that..      MAIN BUILD
  var HATS         = (choices.indexOf("Hats") > -1);         // - hide cosmetic particles spam - slowly turning into TF2..
  var COURIERS     = (choices.indexOf("Couriers") > -1);     // - couriers particles are fine.. until one abuses gems on hats
  var WARDS        = (choices.indexOf("Wards") > -1);        // - hide ward particles on a couple workshop items

  var MAGUSCYPHER  = (choices.indexOf("MagusCypher") > -1);  // - revert Rubick Arcana stolen spells                  FULL BUILD
  var HEROES       = (choices.indexOf("Heroes") > -1);       // - hide default hero particles, helps potato pc
  var PMS          = (choices.indexOf("PMS") > -1);          // - gabening intensifies..

  var VERBOSE      = (verbose === "1");                      // Export detailed per-hero lists and log items in no_bling.txt
  var MEASURE      = (timers === "1");                       // Timers to identify long operations that need optimization

  var LOG = function(str){ if (VERBOSE) {w.echo(str);} }, t; if (!MEASURE) timer = function(f){ return { end:function(){} }; };
  w.echo(""+run+" @ "+engine+((jscript) ? ": Try the faster Node.js engine" : ""));

  // Quit early if no choice selected
  var UCHOICE = (BASE || WEATHER || SEASONAL || MENU || ABILITIES || HATS || COURIERS || WARDS || MAGUSCYPHER || HEROES || PMS);
  if (!UCHOICE && !VERBOSE) w.quit();

  // 

  // Initiate filter variables
  var ROOT = path.normalize(path.dirname(process.argv[1]));                                                    // Root directory
  var FILTERS_FILE = path.normalize(path.join(ROOT, "No-Bling-filters.txt"));             // Default filters file (auto-updated)
  var FILTERS_FILE_PERSONAL = path.normalize(path.join(ROOT, "No-Bling-filters-personal.txt")); // Personal file not overwritten
  if (FileExists(FILTERS_FILE_PERSONAL)) FILTERS_FILE = FILTERS_FILE_PERSONAL;     // Use No-Bling-filters-personal.txt if found
  // Quit if filters file not found
  if (!FileExists(FILTERS_FILE)) { w.echo("ERROR! " + FILTERS_FILE + " missing!"); w.quit(); }

  var off = "particles/dev/empty_particle.vpcf";         // Disable particle files by replacing them with default empty particle
  var KEEP_HERO={}, KEEP_ITEM={}, KEEP_RARITY={}, KEEP_FILE={}, REV_KEEP={}, REV_MOD={};
  var prefabs = { wearable: "wearable_items", default_item: "default_items", courier: "couriers", courier_wearable: "couriers",
                  ward: "wards", tool: "seasonal", relic: "seasonal", emblem: "seasonal", treasure_chest: "seasonal"
                };
  var logs = { "wearable_items": {}, "default_items": {}, "couriers": {}, "wards": {}, "seasonal": {}, "other": {} };
  var mods = { "Base": {}, "Weather": {}, "Seasonal": {}, "Menu": {},
               "Abilities": {}, "Hats": {}, "Couriers": {}, "Wards": {},
               "MagusCypher": {}, "Heroes": {}, "PMS": {}, "Other": {}
             };
  var filters = {}, models = {}, heroes = {}, npc_classes = {}, npc_models = {};
  for (mcat in mods) filters[mcat] = {};

  var vdf = ValveDataFormat();

  // Read and vdf.parse default No-Bling-filters.txt or No-Bling-filters-personal.txt if exist
  var bling_filters = vdf.parse(fs.readFileSync(FILTERS_FILE, DEF_ENCODING)).no_bling_filters;
  w.echo("Using " + FILTERS_FILE + " v" + bling_filters[":version"]);

  for (bcat in bling_filters) {
    if (choices.indexOf(bcat) == -1) continue;                                                                   // skip choices
    if (typeof bling_filters[bcat] !== "object" || typeof filters[bcat] !== "object") continue;           // ignore non-category
    for (b in bling_filters[bcat]) {
      switch (bling_filters[bcat][b]) {
        case "+":
        //if (PMS && bcat == "Hats") break;
          filters[bcat][b] = (b.lastIndexOf(".vmdl") > -1) ? "models/development/invisiblebox.vmdl" : off;
          break;                                                                              // replace "file" with empty asset
        case "++":
          REV_MOD[b] = 1;                            // replace all modifiers referencing "file" with off asset (reverse lookup)
          break;
        case "-":
          if (PMS && bcat == "Hats") break;
          KEEP_FILE[b] = 1;                          // keep "file"
          break;
        case "--":
          if (PMS && bcat == "Abilities") break;
          REV_KEEP[b] = 1;                           // keep all modifiers referencing "file" (reverse-lookup)
          break;
        case "@":
          KEEP_HERO[b] = 1;                          // keep all modifiers for hero "hero"
          break;
        case "#":
          KEEP_ITEM[b] = 1;                          // keep all modifiers for item id "number"
          break;
        case "$":
          KEEP_RARITY[b] = 1;                        // keep all modifiers for rarity "rarity"
          break;
        default:
          filters[bcat][b] = bling_filters[bcat][b]; // replace "modifier" with "asset" from dota/pak01_dir.vpk
          break;
      }
    }
  }

  // Read particles.lst
  if (VERBOSE) t = timer("Read particles.lst");
  var particles_src = path.normalize(path.join(ROOT, "src\\particles.lst"));
  var particles = fs.readFileSync(particles_src, DEF_ENCODING).split("\\").join("/").split("_c\r\n");
  if (VERBOSE) t.end();

  // Read models.lst
  if (VERBOSE) t = timer("Read models.lst");
  var models_src = path.normalize(path.join(ROOT, "src\\models.lst"));
  var models = fs.readFileSync(models_src, DEF_ENCODING).split("\\").join("/").split("_c\r\n");
  if (VERBOSE) t.end();

  // Read and vdf.parse npc resources
  if (VERBOSE) t = timer("Read and parse npc_units.txt");
  var npc_units = vdf.parse(fs.readFileSync("src\\scripts\\npc\\npc_units.txt", DEF_ENCODING)).DOTAUnits;
  for (id in npc_units) {
    if (typeof npc_units[id] !== "object") continue;
    var c2 = id.slice(-2,-1), c1 = id.slice(-1);
    if (typeof npc_units[id]["Model"] == "string") {
      npc_models[id] = npc_units[id]["Model"];
      if (c1 >= '0' && c1 <= '9') npc_models[id.slice(0, -1)] = npc_units[id]["Model"];
      if (c2 === '_') npc_models[id.slice(0, -2)] = npc_units[id]["Model"];
    }
  }
  if (VERBOSE) t.end();

  if (VERBOSE) t = timer("Read and parse npc_heroes.txt");
  var npc_heroes = vdf.parse(fs.readFileSync("src\\scripts\\npc\\npc_heroes.txt", DEF_ENCODING)).DOTAHeroes;
  for (id in npc_heroes) {
    if (typeof npc_heroes[id] !== "object") continue;
    var c2 = id.slice(-2,-1), c1 = id.slice(-1);
    if (typeof npc_heroes[id]["Model"] == "string") {
      npc_models[id] = npc_heroes[id]["Model"];
      if (c1 >= '0' && c1 <= '9') npc_models[id.slice(0, -1)] = npc_heroes[id]["Model"];
      if (c2 === '_') npc_models[id.slice(0, -2)] = npc_heroes[id]["Model"];
    }
  }
  if (VERBOSE) t.end();

  npc_models["courier_radiant"] = "models/props_gameplay/donkey.vmdl";
  npc_models["courier_dire"] = "models/props_gameplay/donkey_dire.vmdl";
  npc_models["courier_flying_radiant"] = "models/props_gameplay/donkey_wings.vmdl";
  npc_models["courier_flying_dire"] = "models/props_gameplay/donkey_dire_wings.vmdl";
  npc_models["npc_dota_goodguys_tower"] = "models/props_structures/tower_good.vmdl";

  // Read and vdf.parse items_game.txt
  var items_game_src = path.normalize(path.join(ROOT, "src\\scripts\\items\\items_game.txt"));
  t = timer("Read items_game.txt");
  var items_game_read = fs.readFileSync(items_game_src, DEF_ENCODING);
  t.end();
  t = timer("VDF.parse items_game.txt");
  var items_game_parsed = vdf.parse(items_game_read);
  t.end();
  // Optionally export vdf.stringify result for verification purposes
  if (VERBOSE) {
    t = timer("VDF.stringify items_game.txt");
    var items_game_stringify = vdf.stringify(items_game_parsed, true);
    t.end();
    var items_game_out=path.normalize(path.join(ROOT,"log\\items_game.txt"));
    t = timer("Write items_game.txt");
    fs.writeFileSync(items_game_out, items_game_stringify, DEF_ENCODING);
    t.end();
  }
  if (VERBOSE) w.echo(" ");

  //----------------------------------------------------------------------------------------------------------------------------
  // 1. Loop trough all items, skipping over irrelevant categories and optionally generate accurate slice logs
  //----------------------------------------------------------------------------------------------------------------------------
  var items = items_game_parsed.items_game.items;
  t = timer("Check items_game");
  for (i in items) {
    var prefab = items[i].prefab || "";
    var rarity = items[i].item_rarity || "";
    var id = vdf.redup(i);
    var caption = items[i].item_name.replace("#DOTA_Item_","");
    var expiration = items[i].expiration_date || "";
    var creation = items[i].creation_date || "";
    var slot = items[i].item_slot || "weapon";
    var model = items[i].model_player || "", model1 = "", model2 = "", model3 = "";
    var visuals = (typeof items[i].visuals === "object") ? items[i].visuals : "";
    var by_heroes = (typeof items[i].used_by_heroes === "object") ? items[i].used_by_heroes : {};
    var npc = "", hero = "", precat = "", cat = "", expired = "", maybe_ability = {}, maybe_hat = {}, has_modifier = false;

    // skip prefabs / non .visuals / non .model_player
    if (!prefab || prefab === "bundle" || prefab === "taunt" || (!visuals && !model)) continue;

    // get npc hero name
    for (used in by_heroes) {
      npc = used;
      if (used.indexOf("_hero_") > -1) {
        hero = used.split("_hero_")[1];
        heroes[hero] = 1;
        break;
      }
    }

    // get precat (for detailed logs)
    precat = (prefabs[prefab]) ? prefabs[prefab] : "other";
    // get expiration
    if (precat === "seasonal" || precat === "other") {
      var age = (expiration) ? expiration.split(" ")[0].split(/\-0|\-/g) : "";
      if (!age && creation) {
        age = creation.split("-");
        age[0] = parseInt(age[0], 10) + 1;
      }
      expired = (age && Date.UTC(age[0], age[1], age[2]) - new Date().getTime() < 0);
      if (items[i].event_id !== ACTIVE_EVENT) expired = true;           // hard-coded ACTIVE_EVENT = EVENT_ID_INTERNATIONAL_2018
      if (items[i].event_id === PAST_EVENT) expired = false;                 // re-enable expired PAST_EVENT for replays viewing
    }

    // optionally generate per-hero / category items_game.txt log slices keeping original indenting - as of 2019 more complete
    if (VERBOSE && hero) {
      var herocat=(prefab === "default_item") ? "default_items" : "wearable_items";
      if (!logs[herocat][hero]) logs[herocat][hero] = {};
      if (!logs[herocat][hero][i]) logs[herocat][hero][i] = {};         // for convenience,
      if (!logs[herocat][hero][i]["items_game"]) logs[herocat][hero][i]["items_game"] = {};
      if (!logs[herocat][hero][i]["items_game"]["items"]) logs[herocat][hero][i]["items_game"]["items"] = {};
      if (!logs[herocat][hero][i]["items_game"]["items"][i+""]) logs[herocat][hero][i]["items_game"]["items"][i+""] = items[i];
    }
    if (VERBOSE && !hero && !expired) {
      if (!logs[precat]) logs[precat] = {};
      if (!logs[precat][i]) logs[precat][i] = {};
      if (!logs[precat][i]["items_game"]) logs[precat][i]["items_game"] = {};
      if (!logs[precat][i]["items_game"]["items"]) logs[precat][i]["items_game"]["items"] = {};
      if (!logs[precat][i]["items_game"]["items"][i+""]) logs[precat][i]["items_game"]["items"][i+""] = items[i];
    }

    // gabening intensifies..
    if (PMS && model) { //&& npc 
      model1 = items[i].model_player1 || ""; model2 = items[i].model_player2 || ""; model3 = items[i].model_player3 || "";
      if (prefab === "default_item") {
        if (!models[npc]) models[npc] = {};
        if (!models[npc][slot]) models[npc][slot] = {};
        if (!models[npc][slot]["m"]) models[npc][slot]["m"] = items[i].model_player;
        if (model1 && !models[npc][slot]["m1"]) models[npc][slot]["m1"] = model1;
        if (model2 && !models[npc][slot]["m2"]) models[npc][slot]["m2"] = model2;
        if (model3 && !models[npc][slot]["m3"]) models[npc][slot]["m3"] = model3;
//      LOG(npc+"-"+slot+":MH "+model);
      } else if (prefab === "wearable") {
        if (typeof models[npc] == "object" && typeof models[npc][slot] == "object" && typeof models[npc][slot]["m"] == "string")
        {
          mods["PMS"][model]=models[npc][slot]["m"];
          if (model1) mods["PMS"][model1] = models[npc][slot]["m1"];
          if (model2) mods["PMS"][model2] = models[npc][slot]["m2"];
          if (model3) mods["PMS"][model3] = models[npc][slot]["m3"];
//        LOG(npc+"-"+slot+":MW "+model+" = "+models[npc][slot]["m"]);
        } else {
//        if ("models/heroes/"+hero+"/"+npc+"_"+slot+".vmdl" in models) LOG(npc+"FOOOOOOOOOOOOOOOOOUND");
          mods["PMS"][model] = "models/development/invisiblebox.vmdl";
//        LOG(npc+"-"+slot+":M? "+model+" = "+"models/development/invisiblebox.vmdl");
        }
      }
    }

    //--------------------------------------------------------------------------------------------------------------------------
    // Still in the item i loop above, check visuals section for asset_modifier* particles
    //--------------------------------------------------------------------------------------------------------------------------
    for (v in visuals) {
      var visual = items[i].visuals[v];      // .visuals object - dont use exact naming since vdf.parser auto-renamed duplicates
      var vtype = visual.type || "";
      var asset = visual.asset || "";
      var modifier = (typeof visual.modifier === "string") ? visual.modifier : "";
      if (modifier === asset) continue;                                          // skip if both modifier and asset are the same
      if (!vtype || vtype === "particle_control_point" /*|| vtype === "particle_combined"*/) continue; //skip non particle/p.._create
      var maybe = false;

      // OTHER - PARTICLE SNAPSHOTS
      if (vtype === "particle_snapshot") {
        mods["Hats"][modifier]=asset; //cat="Other";
        LOG("snapshot: "+modifier);
        continue;
      }

      // DEFINITELY HATS
      if (vtype === "additional_wearable") {
        if (asset.lastIndexOf(".vpcf") > -1) mods["Hats"][asset] = off;
        else if (asset.lastIndexOf(".vmdl") > -1) mods["PMS"][asset] = "models/development/invisiblebox.vmdl";
        LOG("additional: "+path.basename(asset));
        continue; 
      }

      // PMS - GABENING INTENSIFIES..
      var has_pms = (PMS && vtype in {hero_model_change:1, entity_model:1, entity_clientside_model:1});
      if (has_pms) {
        if (asset.lastIndexOf(".vmdl") > -1) {
          cat="PMS"; mods["PMS"][modifier] = asset; has_modifier = true;
        //LOG(npc+"-"+slot+":VA "+modifier+" = "+asset);
        } else if (asset in npc_models) {
          if (modifier !== npc_models[asset]) { 
            cat="PMS"; mods["PMS"][modifier] = npc_models[asset]; has_modifier = true;
          }  
        //LOG(npc+"-"+slot+":VAN "+modifier+" = "+npc_models[asset]);
        } else if (modifier.lastIndexOf(".vmdl") > -1) {
          if (prefab == "courier" && id > 3000) {
            cat="PMS"; mods["PMS"][modifier] = npc_models[vtype+"_"+asset]; has_modifier = true;
          //LOG(vtype+"-"+asset+":COUR "+modifier+" = "+npc_models[vtype+"_"+asset]);
          }
        }
        continue;
      }

      // Find portrait particle definitions and add them to Menu filters
      if (typeof items[i].portraits === "object") {
        for (p in items[i].portraits) {
          if (typeof items[i].portraits[p] !== "object") continue;
          if (typeof items[i].portraits[p].PortraitParticle !== "string") continue;
          var portrait = items[i].portraits[p].PortraitParticle;
          if (portrait.indexOf("portrait") === -1) continue;
          if (portrait.indexOf(hero) === -1) continue;
          if (portrait in KEEP_FILE) continue;
          mods["Menu"][portrait] = off; //has_modifier=true;
          LOG("portrait: "+portrait);
        }
      }

      if (!modifier || modifier.lastIndexOf(".vpcf") === -1) continue;                    // skip non-explicit particle modifier
      if (modifier === asset) continue;                                          // skip if both modifier and asset are the same
      if (modifier.lastIndexOf("null.vpcf") > -1) {LOG('NULL! '+modifier); continue; }                   // skip dummy modifiers
      if (modifier.lastIndexOf("_empty.vpcf") > -1) {LOG('EMPTY! '+modifier); continue; }                // skip empty modifiers
      if (modifier.lastIndexOf("_local.vpcf") > -1) {LOG('LOCAL! '+modifier); continue; }               // skip staged modifiers
      if (asset.indexOf("particles/ability_modifier") > -1) continue;                                  // skip dynamic modifiers
      if (asset.indexOf("particles/reftononexistent") > -1) asset=off;                             // replace dynamic references
      if (asset in REV_KEEP) {KEEP_FILE[modifier]=1;LOG("-rev_skip: "+modifier); continue;}               // skip reverse lookup
      if (asset in REV_MOD) { asset=off; LOG("+rev_replace: "+modifier); }                         // replace via reverse lookup
      if (hero && hero in KEEP_HERO) { LOG("-skip_hero_"+shero+": "+modifier); continue; }                 // skip hero wildcard
      if (id && vdf.nr(id) in KEEP_ITEM) { LOG("-skip_item_"+id+": "+modifier); continue; }             // skip item nr wildcard
      if (rarity && rarity in KEEP_RARITY) { LOG("-skip_rarity_"+rarity+": "+modifier); continue; }      // skip rarity wildcard

      // HEROES default
      if (precat === "default_items") {
        if (modifier.indexOf("particles/units/heroes") > -1) {
          cat="Heroes"; mods[cat][modifier] = off; has_modifier = true;
          LOG("hero: "+modifier);
        }
      }
      // MAGUSCYPHER - Rubick Arcana stolen abilities
      else if (precat === "wearable_items" && vtype === "particle" && rarity === "arcana" && hero === "rubick") {
        cat="MagusCypher"; mods["MagusCypher"][modifier]= (asset) ? asset : off; has_modifier = true;
        LOG("maguscypher: "+modifier);
      }
      // ABILITIES AND HATS
      else if (precat === "wearable_items" && vtype === "particle") {
        // expecting .asset
        if (modifier.indexOf("particles/econ/items") > -1) {
          // Abilities mostly but we can have Hats, too. Separating them is not simple, but Gaben shall not prevail!
          if (asset.indexOf("particles/econ/items") > -1) {
            cat="Hats"; mods[cat][modifier] = off;                                            // mod (hide) modifier by default
            LOG("hat: "+modifier);
          } else {
            cat="Abilities"; maybe = true; maybe_ability[modifier]= (asset) ? asset : off;           // use found asset if valid
            LOG("? ability: "+modifier);
          }
        } else if (modifier.indexOf("particles/units/heroes") > -1) {
            cat="Heroes";
            LOG("-ignore_hero: "+modifier);                                                                  // just log ignored
        } else if (modifier.indexOf("particles/status_fx") === -1) {
          cat="Abilities"; mods[cat][modifier]=(asset) ? asset : off;
          LOG("status_fx: "+modifier+" = "+asset);
        }
        has_modifier = true;
      }
      else if (precat === "wearable_items" && vtype === "particle_create") {
        // not expecting .asset
        if (modifier.indexOf("particles/econ/items") > -1) {
          cat="Hats"; // Hats mostly
          mods[cat][modifier] = off;                                                           // mod (hide) modifier by default
          LOG("hat: "+modifier);
        } else if (modifier.indexOf("particles/units/heroes") > -1) {
          cat="Heroes"; // Default item overrides
          mods[cat][modifier]=(asset) ? asset : off; maybe = true; maybe_hat[modifier]=(asset) ? asset : off;
          LOG("? hat: "+modifier);
        } else {
          cat="Other"; //mods[cat][modifier]=(asset) ? asset : off;
          LOG("-skip_other2: "+modifier);                                                                    // just log ignored
        }
        has_modifier = true;
      }
      else if (precat === "wearable_items" && vtype === "particle_combined") {
        cat="Abilities"; //base_asset = asset; 
//      if (asset in maybe_ability) base_asset = maybe_ability[asset];
//      if (asset in mods[cat]) base_asset = mods[cat][asset];
        mods[cat][modifier] = asset;
        LOG("ability_combined: "+modifier+"="+asset);
      }
      // COURIERS
      else if (precat === "couriers") {
        cat="Couriers"; mods[cat][modifier]=(asset) ? asset : off; has_modifier = true;
        LOG("courier: "+modifier);
      }
      // WARDS
      else if (precat === "wards") {
        cat="Wards"; mods[cat][modifier]=(asset) ? asset : off; has_modifier = true;
        LOG("ward: "+modifier);
      }
      // SEASONAL
      else if (precat === "seasonal") {
        if (expired && !(vdf.nr(id) in KEEP_ITEM)) continue;
        cat="Seasonal"; has_modifier = true; LOG("seasonal: "+modifier);
        mods[cat][modifier]=(asset && asset.indexOf("npc_dota_loadout_generic") == -1) ? asset : off;
      }
      // OTHER
      else if (precat === "other") {
        if (expired && !(vdf.nr(id) in KEEP_ITEM)) continue;
        cat="Other"; //mods[cat][modifier]=(asset) ? asset : off; has_modifier = true;
        LOG("other_last: "+modifier);
      }
    } // next f in visuals section

    // Skip if no modifier is used for item i
    if (!has_modifier) continue;

    // Separate Hats from Abilities out of the ambiguous visuals.asset_modifier.type="particle"
    if (maybe) for (hat in maybe_ability) {
      if (maybe_ability[hat] in maybe_hat) {
        if (maybe_ability[hat] in mods["Heroes"]) {
          mods["Hats"][hat]=maybe_ability[hat];
          LOG("= hat: "+path.basename(hat));
        } else {
          mods["Abilities"][hat]=maybe_ability[hat];
          LOG("= ability: "+path.basename(hat)); // none?!
        }
      } else {
        if (maybe_ability[hat] in mods["Heroes"]) {
          mods["Hats"][hat]=maybe_ability[hat];
          LOG("= hat: "+path.basename(hat));
        } else {
          mods["Abilities"][hat]=maybe_ability[hat];
          LOG("= ability: "+path.basename(hat));
        }
      }
    }

    // log more details to no_bling.txt
    LOG("[" + hero + "] " + caption + " " + prefab + " " + (slot ? slot + " ": "") + (rarity ? rarity + " ": "") + id + "\r\n");

  }  // next item i loop
  t.end();

  //----------------------------------------------------------------------------------------------------------------------------
  // 2. Loop trough generic attached_particles definitions in items_game.txt - these are mostly for Hats & Courier trails
  //----------------------------------------------------------------------------------------------------------------------------
  if (VERBOSE) t = timer("Check generic attached_particles");
  var attached_particles=items_game_parsed.items_game.attribute_controlled_attached_particles;
  for (ap in attached_particles) {
    if (typeof attached_particles[ap] !== "object") continue;                                               // skip if not object
    var generic=attached_particles[ap], existing=false;
    modifier=(typeof generic.system === "string" && generic.system.lastIndexOf(".vpcf") > -1) ? generic.system : "";
    if (!modifier) continue;                                                                    // skip not .vpcf particle files
    for (cat in mods) {if (modifier in mods[cat]) existing=true;}
    if (existing) continue;                                                                             // do not override items
    if (modifier.indexOf("particles/units/heroes") > -1) {
      mods["Heroes"][modifier] = off; LOG("hero: "+modifier);
    } else if (modifier.indexOf("particles/econ/items") > -1) {
      mods["Hats"][modifier] = off; LOG("hat: "+modifier);
    } else if (modifier.indexOf("particles/econ/courier") > -1) {
      mods["Couriers"][modifier] = off; LOG("courier: "+modifier);
    } else if (modifier.indexOf("particles/econ/wards") > -1) {
      mods["Wards"][modifier] = off; LOG("ward: "+modifier);
    }
    // add generic manual particle filters
    for (shero in KEEP_HERO) {
      if (modifier.indexOf(shero+"/") > -1) {KEEP_FILE[modifier]=1; LOG("-skip_"+hero+": "+modifier);}
    }
  } // next ap
  if (VERBOSE) t.end();

  //----------------------------------------------------------------------------------------------------------------------------
  // 3. Loop trough generic asset_modifiers definitions in items_game.txt - these are mostly for custom Abilities effects
  //----------------------------------------------------------------------------------------------------------------------------
  if (VERBOSE) t = timer("Check generic asset_modifiers");
  var asset_modifiers=items_game_parsed.items_game.asset_modifiers;
  for (am in asset_modifiers) {
    if (typeof asset_modifiers[am] !== "object") continue;                                                  // skip if not object
    for (m in asset_modifiers[am]) {
      generic=asset_modifiers[am][m]; existing=false;
      if (typeof generic.type === "string" && generic.type === "particle") {
        modifier=(typeof generic.modifier === "string" && generic.modifier.lastIndexOf(".vpcf") > -1) ? generic.modifier : "";
        asset=(typeof generic.asset === "string" && generic.asset.lastIndexOf(".vpcf") > -1) ? generic.asset : "";
        if (!modifier || !asset) continue;               // skip if modifier or asset are not defined / not .vpcf particle files
        for (cat in mods) {if (modifier in mods[cat]) existing = true;}
        if (existing) continue;                                                                         // do not override items
        if (asset in REV_KEEP) { KEEP_FILE[modifier] = 1; LOG("-rev_skip: "+path.basename(modifier)); continue;}
        if (asset in REV_MOD)  { asset = off; LOG("-rev_mod: "+path.basename(modifier));  } // reverse mod
        mods["Abilities"][modifier] = asset;
        LOG("ability: "+modifier);
        // add generic manual particle filters
        for (shero in KEEP_HERO) {
          if (modifier.indexOf(shero+"/") > -1) {KEEP_FILE[modifier] = 1; LOG("-skip_"+hero+": "+modifier);}
        }
      }
    } // next m
  } // next am
  if (VERBOSE) t.end();

  //----------------------------------------------------------------------------------------------------------------------------
  // 4. Import particles.lst - loadout
  //----------------------------------------------------------------------------------------------------------------------------
  if (VERBOSE) t = timer("Import particles.lst - loadout effects");
  for (i=0, len=particles.length; i < len; i++) {
    if (particles[i].lastIndexOf("loadout.vpcf") > -1) {
      mods["Menu"][particles[i]] = off;
      LOG("loadout: "+particles[i]);
    }
  }
  if (VERBOSE) t.end();

  //----------------------------------------------------------------------------------------------------------------------------
  // 5. Import manual filters defined in No-Bling-filters.txt or No-Bling-filters-personal.txt and sanitize categories
  //----------------------------------------------------------------------------------------------------------------------------
  if (VERBOSE) t = timer("Import manual filters");

  for (hat in KEEP_FILE) {
    for (filtercat in mods) delete mods[filtercat][hat];
    LOG("-skip: "+hat);
  }
  for (hat in REV_KEEP) {
    delete mods["Heroes"][hat];
    LOG("-rev_skip: "+hat);
  }
  for (hat in REV_MOD) {
    mods["Heroes"][hat] = off;
    LOG("+rev_mod: "+hat);
  }
  for (cat in filters) {
    for (hat in filters[cat]) {
      mods[cat][hat]=filters[cat][hat];
      LOG(cat+": "+hat);
    }
  }
  delete mods["PMS"]["models/development/invisiblebox.vmdl"];

  // If Hats pair is in Heroes replace it with empty particle as circular references would negate the replacement (why?)
//for (hat in mods["Hats"]) {
//  var pair = mods["Hats"][hat];
//  if (pair !== off && pair.indexOf("particles/units/heroes") > -1 && pair in mods["Heroes"]) {
//    mods["Hats"][hat] = off;
//    LOG("loop_ref: "+hat);
//  }
//}

  for (ability in mods["Abilities"]) {
    var combined = mods["Abilities"][ability]; 
    if (combined in mods["Abilities"]) {
      mods["Abilities"][ability] = mods["Abilities"][combined];
      LOG("uncombined: "+ability+"="+mods["Abilities"][combined]);
    }
    if (combined.lastIndexOf("loadout.vpcf") > -1) {
      delete mods["Abilities"][ability]; //loadout missmatch
      mods["Menu"][ability] = off;
    }
  }

  if (VERBOSE) t.end();

  //----------------------------------------------------------------------------------------------------------------------------
  // 6. Optionally log to file per-hero / category items lists
  //----------------------------------------------------------------------------------------------------------------------------
  if (VERBOSE) {
    t = timer("Write per-hero / category slice logs to file");
    for (cat in logs) {
      if (typeof logs[cat] !== "object") continue;
      var islot="";
      if (cat === "default_items" || cat === "wearable_items") { // per-hero items
        for (hero in heroes) {
          for (item in logs[cat][hero]) {
            iname=logs[cat][hero][item].items_game.items[item].item_name.replace("#DOTA_Item_","").replace("#DOTA_","");
            islot=logs[cat][hero][item].items_game.items[item].item_slot || ""; item_slot=(islot) ? "_"+islot : "";
            logitem="./log/"+cat+"/"+hero+"/"+iname+"_"+vdf.redup(item)+item_slot+".txt"; MakeDir("./log/"+cat+"/"+hero+"/");
            fs.writeFileSync(path.normalize(logitem), vdf.stringify(logs[cat][hero][item],true), DEF_ENCODING);
          }
        }
      } else {  // non-hero items
        for (item in logs[cat]) {
          iname=logs[cat][item].items_game.items[item].item_name.replace("#DOTA_Item_","").replace("#DOTA_","");
          islot=logs[cat][item].items_game.items[item].item_slot || ""; item_slot=(islot) ? "_"+islot : "";
          logitem="./log/"+cat+"/"+iname+"_"+vdf.redup(item)+item_slot+".txt"; MakeDir("./log/"+cat+"/");
          fs.writeFileSync(path.normalize(logitem), vdf.stringify(logs[cat][item],true), DEF_ENCODING);
        }
      }
    }
    t.end();
  } // end log to file

  if (!UCHOICE) w.quit();   // Do not output source files if no choice selected other than verbose

  //----------------------------------------------------------------------------------------------------------------------------
  // 7. Write particle?mod definitions for each category used for lame file replacement - RIP m_hLowViolenceDef after 7.07
  //----------------------------------------------------------------------------------------------------------------------------
  t = timer("Write particle?mod definitions for each src category");
  var src_lst=path.normalize(ROOT+"\\src\\src.lst"), src_data={}, data="";
  MakeDir(path.dirname(src_lst));
  for (cat in mods) {
    if (choices.indexOf(cat) == -1) continue; // skip if not a choice
    var count=0, mod_ini=path.normalize(ROOT+"\\src\\"+cat+".ini"), mod_data={};
    for (hat in mods[cat]) {
//    mod_data[hat.split("/").join("\\") + "_c?" + mods[cat][hat].split("/").join("\\") + "_c"]=1;
//    src_data[mods[cat][hat].split("/").join("\\") + "_c"]=1;
      mod_data[hat + "_c?" + mods[cat][hat] + "_c"]=1;
      src_data[hat + "_c?" + mods[cat][hat] + "_c"]=1;
      count++;
    } // next hat
    if (count>0) {
      data="["+cat+"]\r\n"; for (i in mod_data) { data += i+"\r\n"; } fs.writeFileSync(mod_ini, data, DEF_ENCODING);
    }
  } // next cat
  data=""; for (i in src_data) { data += i+"\r\n"; } fs.writeFileSync(src_lst, data, DEF_ENCODING); // combined src listing
  t.end();

}; // End of No_Bling

//------------------------------------------------------------------------------------------------------------------------------
// Utility JS functions - callable independently
//------------------------------------------------------------------------------------------------------------------------------
LOptions=function(fn, options, _flag){
  // fn:localconfig.vdf    options:separated by ,    _flag: -read=print -remove=delete -add=default if ommited
  var regs={}, lo=options.split(","), i=0, n=lo.length;
  for (i=0; i < n; i++) {
    regs[lo[i]]=new RegExp("(" + lo[i].split(" ")[0].replace(/([-+])/,"\\$1")+((lo[i].indexOf(" ")==-1) ?")":" [\\w%]+)"),"gi");
  }
  var flag=_flag || "-add", file=path.normalize(fn), data=fs.readFileSync(file, DEF_ENCODING), vdf=ValveDataFormat();
  var parsed=vdf.parse(data), dota=getKeYpath(parsed,"UserLocalConfigStore/Software/Valve/Steam/Apps/"+vdf.nr("570"));
  if (flag === "-read") { var found=dota["LaunchOptions"]; if (found) w.echo(found); return; } // print existing options and exit
  if (typeof dota["LaunchOptions"] === "undefined" || dota["LaunchOptions"] === "") {
    dota["LaunchOptions"]=(flag !== "-remove") ? lo.join(" ") : "";                         // no launch options defined, add all
  } else {
    for (i=0; i < n; i++) {
      if (lo[i] !== "") {
        if (regs[lo[i]].test(dota["LaunchOptions"])) {
          if (flag === "-remove") dota["LaunchOptions"]=dota["LaunchOptions"].replace(regs[lo[i]], "");//found exist, delete 1by1
          else dota["LaunchOptions"]=dota["LaunchOptions"].replace(regs[lo[i]], lo[i]);              //found exist, replace 1by1
        } else {
          if (flag !== "-remove") dota["LaunchOptions"]+=" "+lo[i];                                   //not found exist, add 1by1
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
  for (i=0; i < test.length; i++) {
    for (KeY in out) {
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
  var jscript=(typeof ScriptEngine === "function" && ScriptEngine() === "JScript");
  if (!jscript) { var w={}; w.echo=function(s){console.log(s+"\r");}; } else { w=WScript; }
  var order=!jscript, dups=false, comments=false, newline="\n", empty=(jscript) ? "" : undefined;
  return {
    parse: function(txt, flag){
      var obj={}, stack=[obj], expect_bracket=false, i=0; comments=flag || false;
      if (/\r\n/.test(txt)) {newline="\r\n";} else newline="\n";
      var m, regex =/[^""\r\n]*(\/\/.*)|"([^""]*)"[ \t]+"(.*)"|"([^""]*)"|({)|(})/g;
      while ((m=regex.exec(txt)) !== null) {
        //lf="\n"; w.echo(" cmnt:"+m[1]+lf+" key:"+m[2]+lf+" val:"+m[3]+lf+" add:"+m[4]+lf+" open:"+m[5]+lf+" close:"+m[6]+lf);
        if (comments && m[1] !== empty) {
          i++;key="\x10"+i; stack[stack.length-1][key]=m[1];                                  // AveYo: optionally save comments
        } else if (m[4] !== empty) {
          key=m[4]; if (expect_bracket) { w.echo("VDF.parse: invalid bracket near "+m[0]); return this.stringify(obj,true); }
          if (order && key === ""+~~key) {key="\x11"+key;}          // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (typeof stack[stack.length-1][key] === "undefined") {
            stack[stack.length-1][key] = {};
          } else {
            i++;key+= "\x12"+i; stack[stack.length-1][key] = {}; dups=true;         // AveYo: rename duplicate key obj with \x12+i
          }
          stack.push(stack[stack.length-1][key]); expect_bracket=true;
        } else if (m[2] !== empty) {
          key=m[2]; if (expect_bracket) { w.echo("VDF.parse: invalid bracket near "+m[0]); return this.stringify(obj,true); }
          if (order && key === ""+~~key) key="\x11"+key;            // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (typeof stack[stack.length-1][key] !== "undefined") {i++; key+="\x12"+i; dups=true; }// AveYo: rename duplicate k-v
          stack[stack.length-1][key]=m[3]||"";
        } else if (m[5] !== empty) {
          expect_bracket=false; continue; // one level deeper
        } else if (m[6] !== empty) {
          stack.pop(); continue; // one level back
        }
      }
      if (stack.length !== 1) { w.echo("VDF.parse: open parentheses somewhere"); return this.stringify(obj,true); }
      return obj; // stack[0];
    },
    stringify: function(obj, pretty, nl){
      if (typeof obj !== "object") { w.echo("VDF.stringify: Input not an object"); return obj; }
      pretty=( typeof pretty === "boolean" && pretty) ? true : false; nl=nl || newline || "\n";
      return this.dump(obj, pretty, nl, 0);
    },
    dump: function(obj, pretty, nl, level){
      if (typeof obj !== "object") { w.echo("VDF.stringify: Key not string or object"); return obj; }
      var indent="\t", buf="", idt="", i=0;
      if (pretty) { for (i=0; i < level; i++) idt+= indent; }
      for (var key in obj) {
        if (typeof obj[key] === "object")  {
          buf+= idt+'"'+this.redup(key)+'"'+nl+idt+'{'+nl+this.dump(obj[key], pretty, nl, level+1)+idt+'}'+nl;
        } else {
          if (comments && key.indexOf("\x10") !== -1) { buf+= idt+obj[key]+nl; continue; } // AveYo: restore comments (optional)
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
    nr: function(key){return (!jscript && (key+"").indexOf("\x11") === -1) ? "\x11"+key : key;}  // AveYo: check nr: vdf.nr("nr")
  };
} // End of ValveDataFormat

//------------------------------------------------------------------------------------------------------------------------------
// Hybrid Node.js / JScript Engine by AveYo - can call specific functions as the first script argument
//------------------------------------------------------------------------------------------------------------------------------
if (typeof ScriptEngine === "function" && ScriptEngine() === "JScript") {
  // start of JScript specific code
  jscript=true;engine="JScript";w=WScript;launcher=new ActiveXObject("WScript.Shell"); argc=w.Arguments.Count();argv=[]; run="";
  if (argc > 0){run=w.Arguments(0); for (var i=1; i < argc; i++) argv.push( '"'+w.Arguments(i).replace(/[\\\/]+/g,"\\\\")+'"');}
  process={};process.argv=[ScriptEngine(),w.ScriptFullName];for (var j=0;j<argc;j++) process.argv[j+2]=w.Arguments(j);RN="\r\n";
  path={}; path.join=function(f,n){return fso.BuildPath(f,n);}; path.normalize=function(f){return fso.GetAbsolutePathName(f);};
  path.basename=function(f){return fso.GetFileName(f);};path.dirname=function(f){return fso.GetParentFolderName(f);};
  fs={};fso=new ActiveXObject("Scripting.FileSystemObject"); ado=new ActiveXObject("ADODB.Stream"); DEF_ENCODING="Windows-1252";
  FileExists=function(f){ return fso.FileExists(f); }; PathExists=function(f){ return fso.FolderExists(f); }; path.sep="\\";
  MakeDir=function(fn){
    if (fso.FolderExists(fn)) return; var pfn=fso.GetAbsolutePathName(fn), d=pfn.match(/[^\\\/]+/g), p="";
    for (var i=0,n=d.length; i<n; i++) { p+= d[i]+"\\"; if (!fso.FolderExists(p)) fso.CreateFolder(p); }
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
  if (argc > 2) { run=p[2]; for (n=3;n<argc;n++) argv.push('"'+p[n].replace(/[\\\/]+/g,"\\\\")+'"'); }
  path=require("path"); fs=require("fs"); DEF_ENCODING="utf-8"; w.echo=function(s){console.log(s+"\r");};
  FileExists=function(f){ try{ return fs.statSync(f).isFile(); }catch(e) { if (e.code === "ENOENT") return false; } };
  PathExists=function(f){ try{ return fs.statSync(f).isDirectory(); }catch(e) { if (e.code === "ENOENT") return false; } };
  MakeDir=function(f){ try{ fs.mkdirSync(f); }catch(e) { if (e.code === "ENOENT") { MakeDir(path.dirname(f)); MakeDir(f); } } };
  // end of Node.js specific code
}
function timer(hint){
  var s=new Date(); return { end:function(){ var e=new Date(), t=(e.getTime()-s.getTime())/1000; w.echo(hint+": "+t+"s");}};
}
// If run without parameters the .js file must have been double-clicked in shell, so try to launch the correct .bat file instead
if (jscript&&run===""&&FileExists(w.ScriptFullName.slice(0, -2)+"bat")) launcher.Run('"'+w.ScriptFullName.slice(0, -2)+"bat\"");
//------------------------------------------------------------------------------------------------------------------------------
// Auto-run JS: if first script argument is a function name - call it, passing the next arguments
//------------------------------------------------------------------------------------------------------------------------------
if (run && !(/[^A-Z0-9$_]/i.test(run))) new Function("if(typeof "+run+" === \"function\") {"+run+"("+argv+");}")();
//

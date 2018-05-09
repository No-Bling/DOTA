//  This JS script is used internally by the main "No-Bling DOTA mod builder.bat" launcher                       edited in SynWrite
//---------------------------------------------------------------------------------------------------------------------------------
// v7.14 r1: TI8 BattlePass edition
// - keep filter applies to all categories, not just abilities heroes and hats
// - update ACTIVE_EVENT, re-enable expired TI7 effects, fix missing ball for TI8 lich item, fix emblem only in ui
// v7.12 r1: Pudge Arcana edition
// - less underwhelming arcana keeping element dismember, keeping flies globally, removing hook streak extras and ground scratch
// - can be visually uncluttered later but for now it stays because it's awesome (like necro immortal scythe) + to not affect sales 
// Bumped version from v2.0 final to match game patch 7.10:
// - Add emblem (previously called relic), re-enable expired TI7 Effects for event replays viewing
// - Proper fix for Gyro call down bug
// What's new in No-Bling DOTA mod builder.js v2.0 final:
// - Seasonal category reinstated, as it's still useful for TI7 replays despite event being expired
// - Extended manual filters to make certain items like arcana's less underwhelming
// - New Tweaks category - split into subcategories for more fine-tuning - effigies support, proper shrines, filtered portraits
// - More reliable Dota_LOptions function and consistent verbose output in both Node.js and JScript engines
//---------------------------------------------------------------------------------------------------------------------------------
var ACTIVE_EVENT='EVENT_ID_INTERNATIONAL_2018'; // Hard-coded current event for the Seasonal category
var off='particles/dev/empty_particle.vpcf'; // Disable particle files by replacing them with default empty particle
var KEEP_ITEM={};            // [Experimental] Ignore any auto-generated mod for item id - ex: KEEP_ITEM[7507]=0;KEEP_ITEM[9521]=0;
var KEEP_HERO={};            // [Experimental] Ignore any auto-generated mod for hero name - ex: KEEP_HERO['sven']=1;
var KEEP_RARITY={};          // [Experimental] Ignore any auto-generated mod for rarity - ex: KEEP_RARITY['arcana']=1;
var REV_KEEP={};             // [Advanced] Ignore any auto-generated mod for specific particle file - reverse lookup asset values
var REV_MOD={};              // [Advanced] Replace any auto-generated mod for particle file - reverse lookup asset values
var KEEP={};                 // Ignore any auto-generated mod for specific particle file
var MOD_ABILITY={};          // Add particle replacement file in the Abilities category
var MOD_HAT={};              // Add particle replacement file in the Hats category
var MOD_HERO={};             // Add particle replacement file in the HEROES category
var MOD_BASE={};             // Add particle replacement file in the Base category
var MOD_EFFIGY={};           // Add particle replacement file in the Effigies category
var MOD_SHRINE={};           // Add particle replacement file in the Shrines category
var MOD_PROP={};             // Add particle replacement file in the Props category
var MOD_MENU={};             // Add particle replacement file in the Menu (UI) category
//---------------------------------------------------------------------------------------------------------------------------------
// Manual filters to supplement the auto generated ones by the No_Bling JS function - for convenience moved here on top
// Tip: while debugging a hero, list loaded particles using console command: dumpparticlelist | grep partial_hero_name
// WARNING! Don`t touch before understanding the No_Bling function and the definitions above; expect glitches if changed
//---------------------------------------------------------------------------------------------------------------------------------
  /* Potato PC tweaks - Map Aegis of Champions */
MOD_BASE['particles/econ/events/ti7/aegis_lvl_1000_ambient_ti7.vpcf']=off;//
  /* Potato PC tweaks - Map ancients */
MOD_BASE['particles/dire_fx/bad_ancient_core.vpcf']=off;//
MOD_BASE['particles/dire_fx/bad_ancient_deflights.vpcf']=off;//
MOD_BASE['particles/dire_fx/bad_ancient_flow_test.vpcf']=off;//
MOD_BASE['particles/dire_fx/bad_ancient_embers.vpcf']=off;//
MOD_BASE['particles/dire_fx/bad_ancient_smoke.vpcf']=off;//
MOD_BASE['particles/radiant_fx2/good_ancient001_deflights.vpcf']=off;//
MOD_BASE['particles/radiant_fx2/good_ancient001_spherering.vpcf']=off;//
MOD_BASE['particles/radiant_fx2/good_ancient001_base_pool_c.vpcf']=off;//
  /* Potato PC tweaks - Map barracs */
MOD_BASE['particles/dire_fx/barracks_bad_smoke.vpcf']=off;//
MOD_BASE['particles/dire_fx/barracks_bad_ranged_flow.vpcf']=off;//
MOD_BASE['particles/dire_fx/barracks_bad_ranged_flow2.vpcf']=off;//
  /* Potato PC tweaks - Map buildings */
MOD_BASE['particles/dire_fx/bad_column001_firetorch_embers.vpcf']=off;//
MOD_BASE['particles/dire_fx/bad_column001_firetorch_flame_b.vpcf']=off;//
MOD_BASE['particles/dire_fx/incense_large_b.vpcf']=off;//
MOD_BASE['particles/dire_fx/bad_column001_firetorch_glow.vpcf']=off;//
MOD_BASE['particles/dire_fx/bad_column01_smoketorch.vpcf']=off;//
MOD_BASE['particles/radiant_fx/good_statue008_amb_mdlwisp.vpcf']=off;//
MOD_BASE['particles/radiant_fx/good_statue010_ambienglow_fallback_med.vpcf']=off;//
MOD_BASE['particles/radiant_fx/good_statue010_ambienglow_c.vpcf']=off;//
  /* Potato PC tweaks - Map towers */
MOD_BASE['particles/dire_fx/tower_bad_lamp.vpcf']=off;//
  /* Potato PC tweaks - Map effigies */
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire_lvl2.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_dire_lvl3.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_radiant.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_radiant_lvl1.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_radiant_lvl2.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/ambientfx_effigy_wm16_radiant_lvl3.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/frosty_effigy_ambient_dire.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/frosty_effigy_ambient_l2_dire.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/frosty_effigy_ambient_l2_radiant.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/frosty_effigy_ambient_radiant.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_dire.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_dire_lvl2.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_radiant.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/gold_effigy_ambient_radiant_lvl2.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/jade_effigy_ambient_dire.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/jade_effigy_ambient_radiant.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_dire_lvl1.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_dire_lvl2.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_dire_lvl3.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_rad_lvl1.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_rad_lvl2.vpcf']=off;//
MOD_EFFIGY['particles/econ/items/effigies/status_fx_effigies/se_ambient_fm16_rad_lvl3.vpcf']=off;//
  /* Potato PC tweaks - Map shrines */
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_detail.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_embers.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_flares.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_ground.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_ground_b.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_ground_splash.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_haze.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_lava.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_puddle.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_ray.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_splash.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_vapor.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/dire_shrine_ambient_warp.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/radiant_shrine_ambient_bubbles.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/radiant_shrine_ambient_embers.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/radiant_shrine_ambient_flares.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/radiant_shrine_ambient_puddle.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/radiant_shrine_ambient_ray.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/radiant_shrine_ambient_steam.vpcf']=off;//
MOD_SHRINE['particles/world_shrine/radiant_shrine_ambient_swirl.vpcf']=off;//
  /* Potato PC tweaks - Map fountains */
MOD_PROP['particles/addons_gameplay/fountain_tintable_ambient.vpcf']=off;//
MOD_PROP['particles/terrain_fx/classical_fountain001_water.vpcf']=off;//
MOD_PROP['maps/journey_assets/particles/journey_fountain_radiant.vpcf']=off;//
MOD_PROP['maps/journey_assets/particles/journey_fountain_dire.vpcf']=off;//
  /* Potato PC tweaks - Map bundled weather */
MOD_PROP['particles/rain_fx/journey_terrain.vpcf']=off;//
MOD_PROP['particles/rain_fx/coloseum_terrain.vpcf']=off;//
MOD_PROP['particles/rain_fx/spring_terrain.vpcf']=off;//
MOD_PROP['particles/rain_fx/desert_terrain.vpcf']=off;//
MOD_PROP['particles/rain_fx/winter_terrain.vpcf']=off;//
  /*  Potato PC tweaks - Menu */
MOD_MENU['particles/ui/ui_home_button.vpcf']=off;//                                                                   tweak menu ui
MOD_MENU['particles/ui/ui_home_button_default.vpcf']=off;//
MOD_MENU['particles/ui/ui_home_button_logo.vpcf']=off;//
MOD_MENU['particles/ui/ui_mid_debris.vpcf']=off;//
MOD_MENU['particles/ui/ui_game_start_hero_spotlight.vpcf']=off;//
MOD_MENU['particles/ui/static_fog_flash.vpcf']=off;//
MOD_MENU['particles/ui/static_ground_smoke.vpcf']=off;//
MOD_MENU['particles/ui/static_ground_smoke_soft.vpcf']=off;//
MOD_MENU['particles/ui/static_ground_smoke_soft_ring.vpcf']=off;//
MOD_MENU['particles/ui/static_ground_smoke_soft_small.vpcf']=off;//
MOD_MENU['particles/ui/ui_accept_ember.vpcf']=off;//
MOD_MENU['particles/ui/ui_find_match_status_ember.vpcf']=off;//
MOD_MENU['particles/ui/ui_find_match_status_glow.vpcf']=off;//
MOD_MENU['particles/ui/ui_find_match_status_steam.vpcf']=off;//
MOD_MENU['particles/ui/ui_loadout_preview.vpcf']=off;//

KEEP['particles/econ/events/ti8/emblem_loadout_ambient_ti8.vpcf']=0;//                                       show emblem only in ui
  /*  ABADDON  */
  /*  ABYSSAL_UNDERLORD  */
  /*  ALCHEMIST  */
  /*  ANCIENT_APPARITION  */
  /*  ANTIMAGE  */
  /*  ARC_WARDEN  */
  /*  AXE  */
  /*  BANE  */
  /*  BATRIDER  */
  /*  BEASTMASTER  */
  /*  BLOODSEEKER  */
  /*  BOUNTY_HUNTER  */
KEEP['particles/units/heroes/hero_bounty_hunter/bounty_hunter_hand_l.vpcf']=0;//                               FIX empty crit ready
KEEP['particles/units/heroes/hero_bounty_hunter/bounty_hunter_hand_r.vpcf']=0;//
  /*  BREWMASTER  */
  /*  BRISTLEBACK  */
  /*  BROODMOTHER  */
  /*  CENTAUR  */
  /*  CHAOS_KNIGHT  */
  /*  CHEN  */
  /*  CLINKZ  */
  /*  CRYSTAL_MAIDEN  */
  /*  DARK_SEER  */
//KEEP['particles/units/heroes/hero_dark_seer/dark_seer_ambient_hands.vpcf']=0;//                           keep iconic hands smoke
//MOD_HERO['particles/units/heroes/hero_dark_seer/dark_seer_ambient_hands_b.vpcf']=off;//                               tweak smoke
//MOD_HERO['particles/units/heroes/hero_dark_seer/dark_seer_ambient_hands_c.vpcf']=off;//
  /*  DARK_WILLOW  */
KEEP['particles/units/heroes/hero_dark_willow/dark_willow_lantern_ambient.vpcf']=0;//                             FIX empty lantern
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_lantern_ambient_trail.vpcf']=off;//                     tweak lantern
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_lantern_ambient_trail_bits.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_lantern_ambient_core.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_bramble_cast_smoke.vpcf']=off;//                           tweak cast
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_bramble_cast_throw.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_bramble_wraith_swirl.vpcf']=off;//                       tweak wraith
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_bramble_wraith_ember.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_flash_debris.vpcf']=off;//                 tweak terrorize
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_ring_glow.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell_ring_smoke.vpcf']=off;//
  /*  DAZZLE  */
  /*  DEATH_PROPHET  */
KEEP['particles/units/heroes/hero_death_prophet/death_prophet_spirit_glow.vpcf']=0;//            FIX empty ultimate spirits healing
  /*  DISRUPTOR  */
  /*  DOOM_BRINGER  */
KEEP['particles/units/heroes/hero_doom_bringer/doom_bringer_ambient.vpcf']=0;//                                     keep doom flame
MOD_HERO['particles/units/heroes/hero_doom_bringer/doom_bringer_ambient_b.vpcf']=off;//                                 tweak flame
  /*  DRAGON_KNIGHT  */
  /*  DROW_RANGER  */
var drow_bowstring='particles/units/heroes/hero_drow/drow_bowstring.vpcf';//                                    FIX empty bowstring
MOD_HAT['particles/econ/items/drow/drow_bow_dpits3/drow_bowstring_dpits3.vpcf']=drow_bowstring;//
MOD_HAT['particles/econ/items/drow/drow_arvalias_legacy/drow_bowstring_arvalias.vpcf']=drow_bowstring;//
KEEP[drow_bowstring]=0;//
  /*  EARTH_SPIRIT  */
  /*  EARTHSHAKER  */
  /*  ELDER_TITAN  */
  /*  EMBER_SPIRIT  */
KEEP['particles/units/heroes/hero_ember_spirit/ember_spirit_ambient_eyes.vpcf']=0;//                             keep ember head fx
KEEP['particles/units/heroes/hero_ember_spirit/ember_spirit_ambient_head.vpcf']=0;//
  /*  ENCHANTRESS  */
  /*  ENIGMA  */
KEEP['particles/units/heroes/hero_enigma/enigma_ambient_eyes.vpcf']=0;//                                      FIX empty iconic eyes
KEEP['particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf']=0;//                             FIX empty iconic body wormhole
MOD_HERO['particles/units/heroes/hero_enigma/enigma_ambient_pebbles.vpcf']=off;//                                    tweak wormhole
MOD_HERO['particles/units/heroes/hero_enigma/enigma_ambient_rocks.vpcf']=off;//
//KEEP['particles/units/heroes/hero_enigma/enigma_eidolon_ambient.vpcf']=0;//              don't uncomment this one if you need fps
  /*  FACELESS_VOID  */
  /*  FURION  */
  /*  GYROCOPTER  */
KEEP['particles/units/heroes/hero_gyrocopter/gyro_ambient.vpcf']=0;//                                    FIX empty propeller radius
MOD_HERO['particles/units/heroes/hero_gyrocopter/gyro_ambient_smokestack.vpcf']=off;//                                  tweak smoke
var gyro_cd='particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_call_down_explosion_impact_a.vpcf';//
MOD_ABILITY['particles/units/heroes/hero_gyrocopter/gyro_call_down_explosion_impact_a.vpcf']=gyro_cd;//   FIX Gyro proper call down
  /*  HUSKAR  */
  /*  INVOKER  */
  /*  JAKIRO  */
  /*  JUGGERNAUT  */
KEEP['particles/units/heroes/hero_juggernaut/juggernaut_healing_ward.vpcf']=0;//                             FIX empty healing ward
MOD_HAT['particles/econ/items/juggernaut/jugg_arcana/jugg_arcana_haste.vpcf']=off;//                        mod arcana ground haste
  /*  KEEPER_OF_THE_LIGHT  */
  /*  KUNKKA  */
  /*  LEGION_COMMANDER  */
KEEP['particles/econ/items/legion/legion_weapon_voth_domosh/legion_duel_ring_arcana.vpcf']=0;//                    keep arcana duel
  /*  LESHRAC  */
  /*  LICH  */
var lich_ball='particles/units/heroes/hero_lich/lich_ambient_frost.vpcf';
MOD_HAT['particles/econ/items/lich/lich_ti8_immortal_arms/lich_ti8_ambient_frost.vpcf']=lich_ball;//      FIX TI8 empty iconic ball
KEEP[lich_ball]=0;//                                                                                          FIX empty iconic ball
MOD_HERO['particles/units/heroes/hero_lich/lich_ambient_frost_b.vpcf']=off;//                                            tweak ball
MOD_HERO['particles/units/heroes/hero_lich/lich_ambient_frost_c.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_lich/lich_ambient_frost_d.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_lich/lich_ambient_ball_glow_c.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_lich/lich_ambient_ball_light.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_lich/lich_ambient_ball_glow.vpcf']=off;//
  /*  LIFE_STEALER  */
  /*  LINA  */
KEEP['particles/econ/items/lina/lina_head_headflame/lina_headflame.vpcf']=0;//                               keep arcana head flame
MOD_HAT['particles/econ/items/lina/lina_head_headflame/lina_headflame_f.vpcf']=off;//                              tweak head flame
MOD_HAT['particles/econ/items/lina/lina_head_headflame/lina_headflame_d.vpcf']=off;//
MOD_HAT['particles/econ/items/lina/lina_head_headflame/lina_headflame_e.vpcf']=off;//
MOD_HAT['particles/econ/items/lina/lina_head_headflame/lina_headflame_g.vpcf']=off;//
MOD_HAT['particles/econ/items/lina/lina_head_headflame/lina_headflame_h.vpcf']=off;//
MOD_HAT['particles/econ/items/lina/lina_head_headflame/lina_headflame_i.vpcf']=off;//
  /*  LION  */
  /*  LONE_DRUID  */
  /*  LUNA  */
  /*  LYCAN  */
  /*  MAGNATAUR  */
  /*  MEDUSA  */
KEEP['particles/units/heroes/hero_medusa/medusa_bow.vpcf']=0;//                                                 FIX empty bowstring
  /*  MEEPO  */
  /*  MIRANA  */
KEEP['particles/econ/items/mirana/mirana_starstorm_bow/mirana_bowstring_starstorm.vpcf']=0;//                   FIX empty bowstring
MOD_HAT['particles/econ/items/mirana/mirana_starstorm_bow/mirana_bowstring_starstorm_b.vpcf']=off;//
MOD_HAT['particles/econ/items/mirana/mirana_starstorm_bow/mirana_bow_starstorm.vpcf']=off;//
MOD_HAT['particles/econ/items/mirana/mirana_starstorm_bow/mirana_bowstring_starstorm_bloom.vpcf']=off;//
MOD_HAT['particles/econ/items/mirana/mirana_starstorm_bow/mirana_bowstring_starstorm_e.vpcf']=off;//
  /*  MONKEY_KING  */
  /*  MORPHLING  */
KEEP['particles/units/heroes/hero_morphling/morphling_ambient_new.vpcf']=0;//                               FIX empty iconic vortex
MOD_HERO['particles/units/heroes/hero_morphling/morphling_ambient_new_b.vpcf']=off;//                                    tweak body
MOD_HERO['particles/units/heroes/hero_morphling/morphling_ambient_new_body_b.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_morphling/morphling_ambient_trail.vpcf']=off;//                                   tweak trail
  /*  NAGA_SIREN  */
  /*  NECROLYTE  */
KEEP['particles/econ/items/necrolyte/necrophos_sullen/necro_sullen_pulse_enemy.vpcf']=0;//                           keep ti7 pulse
KEEP['particles/econ/items/necrolyte/necrophos_sullen_gold/necro_sullen_pulse_enemy_gold.vpcf']=0;//
KEEP['particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe.vpcf']=0;//                     keep ti7 scythe
KEEP['particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf']=0;//
MOD_HAT['particles/econ/items/necrolyte/necro_sullen_harvest/necro_sullen_harvest_ambient_staff_event.vpcf']=off;//     tweak trail
  /*  NEVERMORE  */
KEEP['particles/units/heroes/hero_nevermore/nevermore_trail.vpcf']=0;//                                        keep and tweak trail
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_flek_swirl.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_flek_hit.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_ribbon_b.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_dust.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_wispy.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_ribbon.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_ribbon_rev.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_ground_cracks.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_ground_cracks_soft.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_nevermore/nevermore_trail_ambient_swirl.vpcf']=off;//
KEEP['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail.vpcf']=0;//                 keep and tweak arcana trail
MOD_HAT['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail_flek_hit.vpcf']=off;//
MOD_HAT['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail_embers.vpcf']=off;//
MOD_HAT['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail_dust.vpcf']=off;//
MOD_HAT['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail_fire.vpcf']=off;//
MOD_HAT['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail_contact.vpcf']=off;//
MOD_HAT['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail_ground_soft.vpcf']=off;//
MOD_HAT['particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_trail_ground_dark.vpcf']=off;//
  /*  NIGHT_STALKER  */
  /*  NYX_ASSASSIN  */
  /*  OBSIDIAN_DESTROYER  */
MOD_HERO['particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_smoke.vpcf']=off;//               WARNING! don't modify
  /*  OGRE_MAGI  */
  /*  OMNIKNIGHT  */
  /*  ORACLE  */
  /*  PANGOLIER  */
  /*  PHANTOM_ASSASSIN  */
REV_KEEP['particles/units/heroes/hero_phantom_assassin/phantom_assassin_ambient_blade.vpcf']=0;//           FIX lvl6+ weapon glitch
KEEP['particles/econ/items/phantom_assassin/phantom_assassin_weapon_generic/phantom_assassin_ambient_blade_generic.vpcf']=0;//
KEEP['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_ambient_a.vpcf']=0;// arcana blade1
KEEP['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_ambient_b.vpcf']=0;//        blade2
MOD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_d.vpcf']=off;//    arcana style1
MOD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_d_fire.vpcf']=off;//      style3
MOD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_e.vpcf']=off;//           style2
MOD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_blade_f.vpcf']=off;//
MOD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_gravemarker_lvl1.vpcf']=off;//   marks
MOD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_gravemarker_lvl2.vpcf']=off;//
MOD_HAT['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_gravemarker_lvl3.vpcf']=off;//
//KEEP['particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_arcana_swoop.vpcf']=0;//crt
  /*  PHANTOM_LANCER  */
  /*  PHOENIX  */
  /*  PUCK  */
  /*  PUDGE  */
KEEP['particles/units/heroes/hero_pudge/pudge_ambient_chain.vpcf']=0;//                  FIX pudge chains glitch towards map center
REV_KEEP['particles/units/heroes/hero_pudge/pudge_ambient_flies.vpcf']=0;//                               Keep pudge flies globally 
//REV_KEEP['particles/units/heroes/hero_pudge/pudge_hook_streak.vpcf']=0;//                         Keep pudge hook streak globally
MOD_HAT['particles/econ/items/pudge/pudge_arcana/pudge_arcana_idle_groundscratch.vpcf']=off;//    Tweak pudge Arcana ground scratch
MOD_HAT['particles/econ/items/pudge/pudge_arcana/pudge_arcana_red_idle_groundscratch.vpcf']=off;//
MOD_HAT['particles/econ/items/pudge/pudge_arcana/pudge_arcana_walk_groundscratch.vpcf']=off;//       
MOD_HAT['particles/econ/items/pudge/pudge_arcana/pudge_arcana_red_walk_groundscratch.vpcf']=off;//
REV_KEEP['particles/units/heroes/hero_pudge/pudge_dismember_null.vpcf']=0;//                    Keep pudge Arcana element dismember 
REV_KEEP['particles/units/heroes/hero_pudge/pudge_dismember_electric.vpcf']=0;//  
REV_KEEP['particles/units/heroes/hero_pudge/pudge_dismember_ethereal.vpcf']=0;//  
REV_KEEP['particles/units/heroes/hero_pudge/pudge_dismember_fire.vpcf']=0;//  
REV_KEEP['particles/units/heroes/hero_pudge/pudge_dismember_goo.vpcf']=0;//  
REV_KEEP['particles/units/heroes/hero_pudge/pudge_dismember_ice.vpcf']=0;//  
REV_KEEP['particles/units/heroes/hero_pudge/pudge_dismember_motor.vpcf']=0;//  
REV_KEEP['particles/units/heroes/hero_pudge/pudge_dismember_stone.vpcf']=0;//  
REV_KEEP['particles/units/heroes/hero_pudge/pudge_dismember_wood.vpcf']=0;//  
//MOD_HERO['particles/econ/items/pudge/pudge_arcana/default/pudge_arcana_dismember_parent_b_default.vpcf']=off;//    Nerf dismember
//MOD_HERO['particles/econ/items/pudge/pudge_arcana/electric/pudge_arcana_dismember_parent_b_electric.vpcf']=off;//
//MOD_HERO['particles/econ/items/pudge/pudge_arcana/ethereal/pudge_arcana_dismember_parent_b_ethereal.vpcf']=off;//
//MOD_HERO['particles/econ/items/pudge/pudge_arcana/fire/pudge_arcana_dismember_parent_b_fire.vpcf']=off;//
//MOD_HERO['particles/econ/items/pudge/pudge_arcana/goo/pudge_arcana_dismember_parent_b_goo.vpcf']=off;//
//MOD_HERO['particles/econ/items/pudge/pudge_arcana/ice/pudge_arcana_dismember_parent_b_ice.vpcf']=off;//
//MOD_HERO['particles/econ/items/pudge/pudge_arcana/motor/pudge_arcana_dismember_parent_b_motor.vpcf']=off;//
//MOD_HERO['particles/econ/items/pudge/pudge_arcana/stone/pudge_arcana_dismember_parent_b_stone.vpcf']=off;//
//MOD_HERO['particles/econ/items/pudge/pudge_arcana/wood/pudge_arcana_dismember_parent_b_wood.vpcf']=off;//
  /*  PUGNA  */
KEEP['particles/units/heroes/hero_pugna/pugna_ward_ambient.vpcf']=0;//                                               FIX empty ward
//REV_KEEP['particles/units/heroes/hero_pugna/pugna_ward_ambient.vpcf']=0;//
  /*  QUEENOFPAIN  */
  /*  RATTLETRAP  */
  /*  RAZOR  */
KEEP['particles/units/heroes/hero_razor/razor_whip.vpcf']=0;//                                                       FIX empty whip
MOD_HERO['particles/units/heroes/hero_razor/razor_whip_b.vpcf']=off;//                                                   tweak whip
MOD_HERO['particles/units/heroes/hero_razor/razor_whip_light.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_razor_reduced_flash/razor_ambient_main_reduced_flash.vpcf']=off;// FIX dota_hud_reduced_flash
MOD_HERO['particles/units/heroes/hero_razor_reduced_flash/razor_ambient_reduced_flash.vpcf']=off;//
MOD_HERO['particles/units/heroes/hero_razor_reduced_flash/razor_whip_reduced_flash.vpcf']=
         'particles/units/heroes/hero_razor/razor_whip.vpcf';//
  /*  RIKI  */
  /*  RUBICK  */
var rubick_staff='particles/units/heroes/hero_rubick/rubick_staff_ambient.vpcf';//                                  FIX empty staff
KEEP[rubick_staff]=0;//
MOD_HAT['particles/econ/items/rubick/rubick_staff_wandering/rubick_staff_ambient_whset.vpcf']=rubick_staff;//           tweak staff
MOD_HAT['particles/econ/items/rubick/rubick_fortuneteller_ambient/rubick_fortuneteller_staff_ambient.vpcf']=rubick_staff;//
MOD_HAT['particles/econ/items/rubick/rubick_wayfaring/rubick_wayfaring_staff_ambient.vpcf']=rubick_staff;//
MOD_HAT['particles/econ/items/rubick/rubick_gambling_mage/rubick_gambling_mage_ambient.vpcf']=rubick_staff;//
KEEP['particles/econ/items/rubick/rubick_puppet_master/rubick_telekinesis_puppet.vpcf']=0;//                     keep puppet effect
  /*  SAND_KING  */
  /*  SHADOW_DEMON  */
  /*  SHADOW_SHAMAN  */
  /*  SHREDDER  */
  /*  SILENCER  */
  /*  SKELETON_KING  */
  /*  SKYWRATH_MAGE  */
  /*  SLARDAR  */
  /*  SLARK  */
  /*  SNIPER  */
  /*  SPECTRE  */
  /*  SPIRIT_BREAKER  */
  /*  STORM_SPIRIT  */
  /*  SVEN  */
KEEP_ITEM[9449]=0;//    Using experimental item id filter (replacing ~6 manual entries) to keep Vigil_Triumph pay2loose(tm) effects
MOD_HAT['particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_ambient.vpcf']=off;//                  tweak Vigil_Triumph ambient
  /*  TECHIES  */
  /*  TEMPLAR_ASSASSIN  */
KEEP['particles/units/heroes/hero_templar_assassin/templar_assassin_ambient.vpcf']=0;//                            FIX iconic hands
//KEEP['particles/econ/items/templar_assassin/templar_assassin_focal/ta_focal_ambient.vpcf']=0;//                     keep immortal
  /*  TERRORBLADE  */
KEEP['particles/econ/items/terrorblade/terrorblade_horns_arcana/terrorblade_ambient_body_arcana_horns.vpcf']=0;//     FIX body hole
KEEP['particles/econ/items/terrorblade/terrorblade_horns_arcana/terrorblade_ambient_eyes_arcana_horns.vpcf']=0;//     FIX head hole
var terrorblade_left='particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade_2.vpcf';//       mod workshop ambient
MOD_HAT['particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_workshop_left.vpcf']=terrorblade_left;//
var terrorblade_right='particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_blade.vpcf';//
MOD_HAT['particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_workshop_right.vpcf']=terrorblade_right;//
//MOD_HERO['particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_workshop_left.vpcf']=off;//
//MOD_HERO['particles/units/heroes/hero_terrorblade/terrorblade_ambient_sword_workshop_right.vpcf']=off;//
  /*  TIDEHUNTER  */
  /*  TINKER  */
  /*  TINY  */
  /*  TREANT  */
  /*  TROLL_WARLORD  */
  /*  TUSK  */
KEEP['particles/units/heroes/hero_tusk/tusk_frozen_sigil.vpcf']=0;//                                                FIX empty sigil
  /*  UNDYING  */
  /*  URSA  */
  /*  VENGEFULSPIRIT  */
  /*  VENOMANCER  */
  /*  VIPER  */
  /*  VISAGE  */
  /*  WARLOCK  */
REV_MOD['particles/units/heroes/hero_warlock/golem_ambient.vpcf']=off;//                      reverse lookup mod warlock golem fire
  /*  WEAVER  */
  /*  WINDRUNNER  */
var windrunner_bowstring='particles/units/heroes/hero_windrunner/windrunner_bowstring.vpcf';//       FIX windrunner empty bowstring
MOD_HAT['particles/econ/items/windrunner/windrunner_weapon_rainmaker/windranger_weapon_rainmaker.vpcf']=windrunner_bowstring;//
KEEP[windrunner_bowstring]=0;
  /*  WINTER_WYVERN  */
  /*  WISP  */
KEEP['particles/units/heroes/hero_wisp/wisp_ambient.vpcf']=0;//          WARNING! don't modify - wisp is entirely made of particles
  /*  WITCH_DOCTOR  */
KEEP['particles/units/heroes/hero_witchdoctor/witchdoctor_ward_skull.vpcf']=0;//                                FIX empty ward head
  /*  ZUUS  */
KEEP['particles/econ/items/zeus/arcana_chariot/zeus_arcana_chariot.vpcf']=0;//                               keep zeus arcana cloud
MOD_HAT['particles/econ/items/zeus/arcana_chariot/zeus_arcana_chariot_shadow_b.vpcf']=off;//                     tweak arcana cloud
MOD_HAT['particles/econ/items/zeus/arcana_chariot/zeus_arcana_chariot_elecd.vpcf']=off;//
MOD_HAT['particles/econ/items/zeus/arcana_chariot/zeus_arcana_chariot_rays_a.vpcf']=off;//
MOD_HAT['particles/econ/items/zeus/arcana_chariot/zeus_arcana_chariot_rays_b.vpcf']=off;//


//---------------------------------------------------------------------------------------------------------------------------------
// No_Bling JS main function
//---------------------------------------------------------------------------------------------------------------------------------
No_Bling=function(content, output, choices, verbose, timers){
  w.echo(''+run+' @ '+engine+((jscript) ? ': Try the faster Node.js engine' : '')); w.echo('------------------------');
  // Parse arguments
  var CONTENT_DIR    = path.normalize(content);
  var OUTPUT_DIR     = path.normalize(output);
  var ABILITIES      = (choices.indexOf('Abilities') > -1);      // Penguin Frostbite and stuff like that..
  var HATS           = (choices.indexOf('Hats') > -1);           // Cosmetic particles spam - slowly turning into TF2..
  var COURIERS       = (choices.indexOf('Couriers') > -1);       // Couriers particles are fine.. until someone abuses gems on hats
  var WARDS          = (choices.indexOf('Wards') > -1);          // Just a few of them make the ward and the sentry item similar
  var SEASONAL       = (choices.indexOf('Seasonal') > -1);       // The International 7 custom tp, blink, penis-contest towers etc.
  var HEROES         = (choices.indexOf('HEROES') > -1);         // Model particles, helps potato pc but glancevalue can suffer
  var BASE           = (choices.indexOf('Base') > -1);           // tweak map base buildings - ancients, barracks, towers
  var EFFIGIES       = (choices.indexOf('Effigies') > -1);       // tweak map effigies
  var SHRINES        = (choices.indexOf('Shrines') > -1);        // tweak map shrines
  var PROPS          = (choices.indexOf('Props') > -1);          // tweak map props - fountains and terrain-bundled weather
  var MENU           = (choices.indexOf('Menu') > -1);           // tweak menu - ui, hero preview

  var LOG            = (verbose == '1');                           // Exports detailed per-hero lists, useful for debugging mod
  var MEASURE        = (timers == '1'); if (!MEASURE) timer = function(f){ return { end:function(){} }; }; var t;

  // Quit early if no choice selected
  var HAS_CHOICES=(ABILITIES || HATS || COURIERS || WARDS || SEASONAL || HEROES || BASE || EFFIGIES || SHRINES || PROPS || MENU);
  if (!HAS_CHOICES && !LOG) w.quit();

  // Initiate filter variables
  var off='particles/dev/empty_particle.vpcf', q='"', used_by_heroes={};
  var logs={ 'Wearables':{},'HEROES':{},'Couriers':{},'Wards':{},'Seasonal':{},'Others':{} };
  var mods={ 'Abilities':{},'Hats':{},'Couriers':{},'Wards':{},'Seasonal':{},'HEROES':{},'Others':{},
             'Base':{},'Effigies':{},'Shrines':{},'Props':{},'Menu':{} };

  // Read and vdf.parse items_game.txt
  var items_game_src=path.normalize(CONTENT_DIR+'\\scripts\\items\\items_game.txt');
  t=timer('Read items_game.txt');
  var items_game_read=fs.readFileSync(items_game_src, DEF_ENCODING);
  t.end();
  var vdf=ValveDataFormat();
  t=timer('VDF.parse items_game.txt');
  var items_game_parsed=vdf.parse(items_game_read);
  t.end();
  // Optionally export vdf.stringify result for verification purposes
  if (LOG){
    t=timer('VDF.stringify items_game.txt');
    var items_game_stringify=vdf.stringify(items_game_parsed,true);
    t.end();
    var items_game_out=path.normalize(OUTPUT_DIR+'\\log\\items_game.txt');
    t=timer('Write items_game.txt');
    fs.writeFileSync(items_game_out, items_game_stringify, DEF_ENCODING);
    t.end();
  }

  //-------------------------------------------------------------------------------------------------------------------------------
  // 1. Loop trough all items, skipping over irrelevant categories and optionally generate accurate slice logs
  //-------------------------------------------------------------------------------------------------------------------------------
  if (LOG) t=timer('--- Check items_game');
  var items=items_game_parsed.items_game.items;
  for (var i in items){
    var precat='', cat='', expired='', logitem='',hero='NO', has_particles=false, maybe_ability={}, maybe_hat={}, iid=vdf.redup(i);
    var prefab=items[i].prefab || '', rarity=items[i].item_rarity || '', iname=items[i].item_name.replace('#DOTA_Item_','');
    if (typeof items[i].prefab != 'string') continue;           // skip if not having .prefab - the hidden item #TF_Default_ItemDef
    if (typeof items[i].visuals != 'object') continue;                                               // skip if not having .visuals
    // guess hero name
    if (typeof items[i].used_by_heroes == 'object'){
      for (var h in items[i].used_by_heroes){if (h.indexOf('_dota_') > -1) hero=h.split('_dota_')[1];}
      hero=(hero.indexOf('hero_') > -1) ? h.split('hero_')[1] : 'NO'; used_by_heroes[hero]='';
    }
    // convert prefab categories
    if (prefab == 'wearable' || prefab == 'bundle') precat='Wearables'; else if (prefab == 'default_item') precat='HEROES';
    else if (prefab == 'courier' || prefab == 'courier_wearable') precat='Couriers'; else if (prefab == 'ward') precat='Wards';
    else if (prefab == 'tool' || prefab == 'relic' || prefab == 'emblem' || prefab == 'treasure_chest') precat='Seasonal';
    else precat='Others'; // 7.10: relic renamed to emblem..
    // guess expiration
    if (precat == 'Seasonal' || precat == 'Others'){
      var age=(typeof items[i].expiration_date == 'string') ? items[i].expiration_date.split(' ')[0].split(/\-0|\-/g) : '';
      if (!age && typeof items[i].creation_date == 'string'){ age=items[i].creation_date.split('-');age[0]=parseInt(age[0],10)+1; }
      expired=(age && Date.UTC(age[0],age[1],age[2]) - new Date().getTime() < 0);
      if (items[i].event_id != ACTIVE_EVENT) expired=true;                 // hard-coded ACTIVE_EVENT = EVENT_ID_INTERNATIONAL_2018
      if (items[i].event_id == 'EVENT_ID_INTERNATIONAL_2017') expired=false;   // re-enable expired TI7 Effects for replays viewing
    }
    // generate item category tracking text for debugging
    if (LOG) logitem='  '+iname+' ['+hero+'] '+prefab+' '+(rarity ? rarity+' ' : '')+iid+RN;

    // Still in the item i loop above, check visuals section for asset_modifier* particles
    for (var f in items[i].visuals){
      var visuals=items[i].visuals[f];         // .visuals object - don't use exact naming since vdf.parser auto-renamed duplicates
      var type=(typeof visuals.type == 'string' && visuals.type.indexOf('particle') === 0 ) ? visuals.type : '';
      if (!type || type == 'particle_control_point' || type == 'particle_combined') continue; //skip non particle / particle_create
      var modifier=(typeof visuals.modifier == 'string' && visuals.modifier.lastIndexOf('.vpcf') > -1) ? visuals.modifier : '';
      var asset=(typeof visuals.asset == 'string' && visuals.asset.lastIndexOf('.vpcf') > -1) ? visuals.asset : '';
      if (modifier == asset) continue; // skip if both modifier and asset are the same / are not defined / not .vpcf particle files
      if (modifier && modifier.lastIndexOf('null.vpcf') > -1) continue;                                     // skip dummy modifiers
      if (modifier && modifier.lastIndexOf('_local.vpcf') > -1) continue;                                  // skip staged modifiers
      if (asset && asset.indexOf('particles/ability_modifier') > -1) continue;                            // skip dynamic modifiers
      if (asset && asset.indexOf('particles/reftononexistent') > -1) asset=off;                          // skip dynamic references
      if (asset && asset in REV_KEEP){ KEEP[modifier]=1; if (LOG) logitem+='    rev_skip: '+path.basename(modifier)+RN; }// reverse
      if (asset && asset in REV_MOD){ asset=REV_MOD[asset]; if (LOG) logitem+='    rev_mod: '+path.basename(modifier)+RN; }//lookup
      // ABILITIES AND HATS
      if (precat == 'Wearables' && type == 'particle'){
        // expecting .asset
        if (modifier.indexOf('particles/econ/items') > -1){
          // Abilities mostly but we can have Hats, too. Separating them is not simple, but Gaben shall not prevail!
          if (LOG) logitem+= '      maybe_ability? '+modifier+RN;
          if (asset && asset.indexOf('particles/econ/items') > -1){
            cat='Hats'; mods[cat][modifier]=off;                                               // mod (disable) modifier by default
            if (LOG) logitem+= '      hat: '+modifier+RN;
          } else {
            cat='Abilities'; maybe_ability[modifier]= (asset) ? asset : off;                            // use found asset if valid
          }
        } else if (modifier.indexOf('particles/units/heroes') > -1){
          cat='HEROES'; //mods[cat][modifier]=(asset) ? asset : off;                                            // just log ignored
          if (LOG) logitem+= '      ignore_hero: '+modifier+RN;
        } else {
          cat='Others'; //mods[cat][modifier]=(asset) ? asset : off;                                            // just log ignored
          if (LOG) logitem+= '      skip_other1: '+modifier+RN;
        }
        has_particles = true;
      } else if (precat == 'Wearables' && type == 'particle_create'){
        // not expecting .asset
        if (modifier.indexOf('particles/econ/items') > -1){
          cat='Hats'; // Hats mostly
          mods[cat][modifier]=off;                                                             // mod (disable) modifier by default
          if (asset && asset.indexOf('particles/econ/items') == -1){
            mods[cat][modifier]=(asset) ? asset : off;                                                  // use found asset if valid
          }
          if (LOG) logitem+= '      hat: '+modifier+RN;
        } else if (modifier.indexOf('particles/units/heroes') > -1){
          cat='HEROES'; // Default item overrides
          mods[cat][modifier]=(asset) ? asset : off; maybe_hat[modifier]=(asset) ? asset : off;
          if (LOG) logitem+= '      maybe_hat? '+modifier+RN;
        } else {
          cat='Others'; //mods[cat][modifier]=(asset) ? asset : off;                                            // just log ignored
          if (LOG) logitem+= '      skip_other2: '+modifier+RN;
        }
        has_particles = true;
      }
      // HEROES default
      if (precat == 'HEROES'){
        if (modifier.indexOf('particles/units/heroes') > -1){
          cat='HEROES'; mods[cat][modifier]=off; has_particles = true;
          if (LOG) logitem+= '      hero: '+modifier+RN;
        }
      }
      // COURIERS
      if (precat == 'Couriers'){
        cat='Couriers'; mods[cat][modifier]=(asset) ? asset : off; has_particles = true;
        if (LOG) logitem+= '      courier: '+modifier+RN;
      }
      // WARDS
      if (precat == 'Wards'){
        cat='Wards'; mods[cat][modifier]=(asset) ? asset : off; has_particles = true;
        if (LOG) logitem+= '      ward: '+modifier+RN;
      }
      // SEASONAL
      if (precat == 'Seasonal'){
        if (expired && !(iid in KEEP_ITEM)) continue;
        cat='Seasonal'; mods[cat][modifier]=(asset) ? asset : off; has_particles = true;
        if (LOG) logitem+= '      seasonal: '+modifier+RN;
      }
      // OTHERS
      if (precat == 'Others'){
        if (expired && !(iid in KEEP_ITEM)) continue;
        cat='Others'; mods[cat][modifier]=(asset) ? asset : off; has_particles = true;
        if (LOG) logitem+= '      others: '+modifier+RN;
      }
      // add generic manual particle filters
      if (rarity && rarity in KEEP_RARITY){
        KEEP[modifier]=1; if (LOG) logitem+= '    skip_'+rarity+': '+path.basename(modifier)+RN;
      }
      for (var shero in KEEP_HERO){
        if (modifier.indexOf(shero+'/') > -1){KEEP[modifier]=1; if(LOG) logitem+='    skip_'+hero+': '+path.basename(modifier)+RN;}
      }
      if (iid && iid in KEEP_ITEM){
        KEEP[modifier]=1; if (LOG) logitem+= '    skip_'+iid+': '+path.basename(modifier)+RN;
      }
    } // next f in visuals section

    // Separate Hats from Abilities out of the ambiguous visuals.asset_modifier.type='particle'
    for (var hat in maybe_ability){
      if (maybe_ability[hat] in maybe_hat){
        if (maybe_ability[hat] in mods['HEROES']){
          mods['Hats'][hat]=maybe_ability[hat];
          if (LOG) logitem+= '        hat! '+path.basename(hat)+RN;
        } else {
          mods['Abilities'][hat]=maybe_ability[hat];
          if (LOG) logitem+= '        ability! '+path.basename(hat)+RN; // none?!
        }
      } else {
        if (maybe_ability[hat] in mods['HEROES']){
          mods['Hats'][hat]=maybe_ability[hat];
          if (LOG) logitem+= '        hat! '+path.basename(hat)+RN;
        } else {
          mods['Abilities'][hat]=maybe_ability[hat];
          if (LOG) logitem+= '        ability! '+path.basename(hat)+RN;
        }
      }
    }

    // Find portrait particle definitions and add them to MOD_MENU manual filter
    if (typeof items[i].portraits == 'object'){
      for (var p in items[i].portraits){
        if (typeof items[i].portraits[p] != 'object') continue;
        if (typeof items[i].portraits[p].PortraitParticle != 'string') continue;
        if (items[i].portraits[p].PortraitParticle.indexOf('portrait') < 1) continue;
        if (items[i].portraits[p].PortraitParticle in KEEP) continue;
        MOD_MENU[items[i].portraits[p].PortraitParticle]=off; has_particles=true;
      }
    }

    // Skip if no particles found for item i
    if (!has_particles) continue;

    // Optionally generate per-hero / category items_game.txt log slices keeping original indenting
    if (LOG){
      if (hero != 'NO'){                                                                                          // per-hero items
        var herocat=(prefab == 'default_item') ? 'HEROES' : 'Wearables';
        if (!logs[herocat][hero]) logs[herocat][hero]={};
        if (!logs[herocat][hero][i]) logs[herocat][hero][i]={};         // for convenience,
        if (!logs[herocat][hero][i]['items_game']) logs[herocat][hero][i]['items_game']={};
        if (!logs[herocat][hero][i]['items_game']['items']) logs[herocat][hero][i]['items_game']['items']={};
        if (!logs[herocat][hero][i]['items_game']['items'][i+'']) logs[herocat][hero][i]['items_game']['items'][i+'']=items[i];
      } else {                                                                                                    // non-hero items
        if (!logs[precat]) logs[precat]={};
        if (!logs[precat][i]) logs[precat][i]={};
        if (!logs[precat][i]['items_game']) logs[precat][i]['items_game']={};
        if (!logs[precat][i]['items_game']['items']) logs[precat][i]['items_game']['items']={};
        if (!logs[precat][i]['items_game']['items'][i+'']) logs[precat][i]['items_game']['items'][i+'']=items[i];
      }
    }

    // Optionally print item category tracking text for debugging in one go
    if (LOG && hero!='NO' && has_particles) w.echo(logitem);

  }  // next item i loop
  if (LOG) t.end();

  //-------------------------------------------------------------------------------------------------------------------------------
  // 2. Loop trough generic attached_particles definitions in items_game.txt - these are mostly for Hats & Courier trails
  //-------------------------------------------------------------------------------------------------------------------------------
  if (LOG) t=timer('--- Check generic attached_particles');
  var attached_particles=items_game_parsed.items_game.attribute_controlled_attached_particles;
  for (var ap in attached_particles){
    if (typeof attached_particles[ap] != 'object') continue;                                                  // skip if not object
    var generic=attached_particles[ap], existing=false;
    modifier=(typeof generic.system == 'string' && generic.system.lastIndexOf('.vpcf') > -1) ? generic.system : '';
    if (!modifier) continue;                                                                       // skip not .vpcf particle files
    for (cat in mods){if (modifier in mods[cat]) existing=true;}
    if (existing) continue;                                                                                // do not override items
    if (modifier.indexOf('particles/units/heroes') > -1){
      mods['HEROES'][modifier]=off; if (LOG) w.echo('  hero: '+modifier);
    } else if (modifier.indexOf('particles/econ/items') > -1){
      mods['Hats'][modifier]=off; if (LOG) w.echo('  hat: '+modifier);
    } else if (modifier.indexOf('particles/econ/courier') > -1){
      mods['Couriers'][modifier]=off; if (LOG) w.echo('  courier: '+modifier);
    } else if (modifier.indexOf('particles/econ/wards') > -1){
      mods['Wards'][modifier]=off; if (LOG) w.echo('  ward: '+modifier);
    }
    // add generic manual particle filters
    for (shero in KEEP_HERO){
      if (modifier.indexOf(shero+'/') > -1){KEEP[modifier]=1; if (LOG) w.echo('    skip_'+hero+': '+path.basename(modifier));}
    }
  } // next ap
  if (LOG) t.end();

  //-------------------------------------------------------------------------------------------------------------------------------
  // 3. Loop trough generic asset_modifiers definitions in items_game.txt - these are mostly for custom Abilities effects
  //-------------------------------------------------------------------------------------------------------------------------------
  if (LOG) t=timer('--- Check generic asset_modifiers');
  var asset_modifiers=items_game_parsed.items_game.asset_modifiers;
  for (var am in asset_modifiers){
    if (typeof asset_modifiers[am] != 'object') continue;                                                     // skip if not object
    for (var m in asset_modifiers[am]){
      generic=asset_modifiers[am][m]; existing=false;
      if (typeof generic.type == 'string' && generic.type == 'particle'){
        modifier=(typeof generic.modifier == 'string' && generic.modifier.lastIndexOf('.vpcf') > -1) ? generic.modifier : '';
        asset=(typeof generic.asset == 'string' && generic.asset.lastIndexOf('.vpcf') > -1) ? generic.asset : '';
        if (!modifier || !asset) continue;                  // skip if modifier or asset are not defined / not .vpcf particle files
        for (cat in mods){if (modifier in mods[cat]) existing=true;}
        if (existing) continue;                                                                            // do not override items
        if (asset in REV_KEEP){ KEEP[modifier]=1; if (LOG) w.echo('    rev_skip: '+path.basename(modifier)); }      // reverse skip
        if (asset in REV_MOD)  { asset=REV_MOD[asset]; if (LOG) w.echo('    rev_mod: '+path.basename(modifier));  }   //reverse mod
        mods['Abilities'][modifier]=asset;
        if (LOG) w.echo('  ability: '+modifier);
        // add generic manual particle filters
        for (shero in KEEP_HERO){
          if (modifier.indexOf(shero+'/') > -1){KEEP[modifier]=1; if (LOG) w.echo('    skip_'+hero+': '+path.basename(modifier));}
        }
      }
    } // next m
  } // next am
  if (LOG) t.end();

  //-------------------------------------------------------------------------------------------------------------------------------
  // 4. Import manual filters defined at the top of this script and sanitize categories
  //-------------------------------------------------------------------------------------------------------------------------------
  if (LOG) t=timer('--- Import manual filters');

  // Import manual filters
  for (hat in KEEP){
    for (filtercat in mods) delete mods[filtercat][hat]; 
    if (LOG) w.echo('  skip: '+hat);
  }

  for (hat in REV_KEEP){ delete mods['HEROES'][hat];  if (LOG) w.echo('  rev_skip: '+hat); }
  for (hat in REV_MOD){ mods['HEROES'][hat]=REV_MOD[hat];  if (LOG) w.echo('  rev_mod: '+hat); }

  for (hat in MOD_ABILITY){ mods['Abilities'][hat]=MOD_ABILITY[hat]; if (LOG) w.echo('  mod_ability: '+hat); }
  for (hat in MOD_HAT){ mods['Hats'][hat]=MOD_HAT[hat]; if (LOG) w.echo('  mod_hat: '+hat); }
  for (hat in MOD_HERO){ mods['HEROES'][hat]=MOD_HERO[hat]; if (LOG) w.echo('  mod_hero: '+hat); }
  for (hat in MOD_BASE){ mods['Base'][hat]=MOD_BASE[hat]; if (LOG) w.echo('  mod_base: '+hat); }
  for (hat in MOD_EFFIGY){ mods['Effigies'][hat]=MOD_EFFIGY[hat]; if (LOG) w.echo('  mod_effigy: '+hat); }
  for (hat in MOD_SHRINE){ mods['Shrines'][hat]=MOD_SHRINE[hat]; if (LOG) w.echo('  mod_shrine: '+hat); }
  for (hat in MOD_PROP){ mods['Props'][hat]=MOD_PROP[hat]; if (LOG) w.echo('  mod_prop: '+hat); }
  for (hat in MOD_MENU){ mods['Menu'][hat]=MOD_MENU[hat]; if (LOG) w.echo('  mod_menu: '+hat); }

  // Heroes option supersedes Hats option so include non-moded particles
  for (hat in mods['Hats']){
    if (mods['Hats'][hat]!=off && !(mods['Hats'][hat] in KEEP)){mods['HEROES'][hat]=off; if (LOG) w.echo('  hero_include: '+hat);}
  }

  if (LOG) t.end();

  //-------------------------------------------------------------------------------------------------------------------------------
  // 5. Optionally log to file per-hero / category items lists
  //-------------------------------------------------------------------------------------------------------------------------------
  if (LOG){
    t=timer('Write per-hero / category slice logs to file');
    for (cat in logs){
      if (typeof logs[cat] != 'object') continue;
      var islot='';
      if (cat == 'HEROES' || cat == 'Wearables'){ // per-hero items
        for (hero in used_by_heroes){
          for (item in logs[cat][hero]){
            iname=logs[cat][hero][item].items_game.items[item].item_name.replace('#DOTA_Item_','').replace('#DOTA_','');
            islot=logs[cat][hero][item].items_game.items[item].item_slot || ''; item_slot=(islot) ? '_'+islot : '';
            logitem='./log/'+cat+'/'+hero+'/'+iname+'_'+vdf.redup(item)+item_slot+'.txt'; MakeDir('./log/'+cat+'/'+hero+'/');
            fs.writeFileSync(path.normalize(logitem), vdf.stringify(logs[cat][hero][item],true), DEF_ENCODING);
          }
        }
      } else {  // non-hero items
        for (item in logs[cat]){
          iname=logs[cat][item].items_game.items[item].item_name.replace('#DOTA_Item_','').replace('#DOTA_','');
          islot=logs[cat][item].items_game.items[item].item_slot || ''; item_slot=(islot) ? '_'+islot : '';
          logitem='./log/'+cat+'/'+iname+'_'+vdf.redup(item)+item_slot+'.txt'; MakeDir('./log/'+cat+'/');
          fs.writeFileSync(path.normalize(logitem), vdf.stringify(logs[cat][item],true), DEF_ENCODING);
        }
      }
    }
    t.end();
  } // end log to file

  //-------------------------------------------------------------------------------------------------------------------------------
  // 6. Write particle?mod definitions for each category used for lame file replacement - RIP proper m_hLowViolenceDef after 7.07
  //-------------------------------------------------------------------------------------------------------------------------------
  if (!HAS_CHOICES) w.quit();   // Do not output source files if no choice selected other than verbose (LOG)
  t=timer('Write particle?mod definitions for each src category');
  for (cat in mods){
    var particles=mods[cat], mod_file=path.normalize(OUTPUT_DIR+'\\src\\'+cat+'.ini');
    MakeDir(path.dirname(mod_file));
    var data='['+cat+']\r\n', count=0;
    for (hat in particles){
      var content_file=path.normalize(path.join(CONTENT_DIR, hat+'_c'));
      if (FileExists(content_file)){
        data += hat.split('/').join('\\') + '_c?' + particles[hat].split('/').join('\\') + '_c\r\n';
        count++;
      } else {
        if (LOG) w.echo('  [CONTENT MISSING]: '+hat+'_c');
      }
    } // next hat
    if (count>0) fs.writeFileSync(mod_file, data, DEF_ENCODING);
  } // next cat
  t.end();

}; // End of No_Bling

//---------------------------------------------------------------------------------------------------------------------------------
// Utility JS functions - callable independently
//---------------------------------------------------------------------------------------------------------------------------------
Dota_LOptions=function(fn, options, _flag){
  // fn:localconfig.vdf    options:separated by ,    _flag: -read=print -remove=delete -add=default if ommited
  var regs={}, lo=options.split(","), i=0,n=lo.length;
  for (i=0;i<n;i++){
    regs[lo[i]]=new RegExp('(' + lo[i].split(" ")[0].replace(/([-+])/,"\\$1")+((lo[i].indexOf(' ')==-1) ? ')' : ' [\\w%]+)'),'gi');
  }
  var flag=_flag || '-add', file=path.normalize(fn), data=fs.readFileSync(file, DEF_ENCODING);
  var vdf=ValveDataFormat(), parsed=vdf.parse(data), apps=getKeYpath(parsed,"UserLocalConfigStore/Software/Valve/Steam/Apps");
  var dota=apps[vdf.nr('570')];                             // added getKeYpath function to fix inconsistent key case used by Valve
  if (flag == '-read'){ w.echo(dota["LaunchOptions"]); return; }                          // print existing launch options and exit
  if (typeof dota["LaunchOptions"] === 'undefined' || dota["LaunchOptions"] === ''){
    dota["LaunchOptions"]=(flag != '-remove') ? lo.join(" ") : "";                            // no launch options defined, add all
  } else {
    for (i=0;i<n;i++){
      if (lo[i] !== ''){
        if (regs[lo[i]].test(dota["LaunchOptions"])){
          if (flag == '-remove') dota["LaunchOptions"]=dota["LaunchOptions"].replace(regs[lo[i]], '');//found existing, delete 1by1
          else dota["LaunchOptions"]=dota["LaunchOptions"].replace(regs[lo[i]], lo[i]);              //found existing, replace 1by1
        } else {
          if (flag != '-remove') dota["LaunchOptions"]+=' '+lo[i];                                   //not found existing, add 1by1
        }
      }
    }
  }
  dota["LaunchOptions"]=dota["LaunchOptions"].replace(/\s\s+/g, ' ');                    // replace multiple spaces between options
  fs.writeFileSync(fn, vdf.stringify(parsed,true), DEF_ENCODING);                   // update fn if flag is -add -remove or ommited
};
function getKeYpath(obj,kp){
  var test=kp.split("/");
  var out=obj;
  for (var i=0;i<test.length;i++) {
    for (var KeY in out) {
      if (out.hasOwnProperty(KeY) && (KeY+"").toLowerCase()==(test[i]+"").toLowerCase()) {out=out[KeY]; /*w.echo("found "+KeY);*/}
    }
  }
  return out;
}

OutChars=function(s){ new Function('w.echo(String.fromCharCode('+s+'))')(); };

//---------------------------------------------------------------------------------------------------------------------------------
// ValveDataFormat hybrid js parser by AveYo, 2016                                               VDF test on 20.1 MB items_game.txt
// loosely based on vdf-parser by Rossen Popov, 2014-2016                                                          node.js  cscript
// featuring auto-renaming duplicate keys, saving comments, grabbing lame one-line "key" { "k" "v" }        parse:  1.329s   9.285s
// greatly improved cscript performance - it's not that bad overall but still lags behind node.js       stringify:  0.922s   3.439s
//---------------------------------------------------------------------------------------------------------------------------------
function ValveDataFormat(){
  var jscript=(typeof ScriptEngine == 'function' && ScriptEngine() == 'JScript');
  if (!jscript){ var w={}; w.echo=function(s){console.log(s+'\r');}; }
  var order=!jscript, dups=false, comments=false, newline='\n', empty=(jscript) ? '' : undefined;
  return {
    parse: function(txt, flag){
      var obj={}, stack=[obj], expect_bracket=false, i=0; comments=flag || false;
      if (/\r\n/.test(txt)){newline='\r\n';} else newline='\n';
      var m, regex =/[^"\r\n]*(\/\/.*)|"([^"]*)"[ \t]+"([^"]*\\"[^"]*\\"[^"]*|[^"]*)"|"([^"]*)"|({)|(})/g;                      //"
      while ((m=regex.exec(txt)) !== null){
        //lf='\n'; w.echo(' cmnt:'+m[1]+lf+' key:'+m[2]+lf+' val:'+m[3]+lf+' add:'+m[4]+lf+' open:'+m[5]+lf+' close:'+m[6]+lf);
        if (comments && m[1] !== empty){
          i++;key='\x10'+i; stack[stack.length-1][key]=m[1];                                     // AveYo: optionally save comments
        } else if (m[4] !== empty){
          key=m[4]; if (expect_bracket){ w.echo('VDF.parse: invalid bracket near '+m[0]); return this.stringify(obj,true); }
          if (order && key == ''+~~key){key='\x11'+key;}              // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (typeof stack[stack.length-1][key] === 'undefined'){
            stack[stack.length-1][key]={};
          } else {
            i++;key+= '\x12'+i; stack[stack.length-1][key]={}; dups=true;            // AveYo: rename duplicate key obj with \x12+i
          }
          stack.push(stack[stack.length-1][key]); expect_bracket=true;
        } else if (m[2] !== empty){
          key=m[2]; if (expect_bracket){ w.echo('VDF.parse: invalid bracket near '+m[0]); return this.stringify(obj,true); }
          if (order && key == ''+~~key) key='\x11'+key;               // AveYo: prepend nr. keys with \x11 to keep order in node.js
          if (typeof stack[stack.length-1][key] !== 'undefined'){ i++;key+= '\x12'+i; dups=true; }   // AveYo: rename duplicate k-v
          stack[stack.length-1][key]=m[3]||'';
        } else if (m[5] !== empty){
          expect_bracket=false; continue; // one level deeper
        } else if (m[6] !== empty){
          stack.pop(); continue; // one level back
        }
      }
      if (stack.length != 1){ w.echo('VDF.parse: open parentheses somewhere'); return this.stringify(obj,true); }
      return obj; // stack[0];
    },
    stringify: function(obj, pretty, nl){
      if (typeof obj != 'object'){ w.echo('VDF.stringify: Input not an object'); return obj; }
      pretty=( typeof pretty == 'boolean' && pretty) ? true : false; nl=nl || newline || '\n';
      return this.dump(obj, pretty, nl, 0);
    },
    dump: function(obj, pretty, nl, level){
      if (typeof obj != 'object'){ w.echo('VDF.stringify: Key not string or object'); return obj; }
      var indent='\t', buf='', idt='', i=0;
      if (pretty){for (; i < level; i++) idt+= indent;}
      for (var key in obj){
        if (typeof obj[key] == 'object')  {
          buf+= idt+'"'+this.redup(key)+'"'+nl+idt+'{'+nl+this.dump(obj[key], pretty, nl, level+1)+idt+'}'+nl;
        } else {
          if (comments && key.indexOf('\x10') !== -1){ buf+= idt+obj[key]+nl; continue; }     // AveYo: restore comments (optional)
          buf+= idt+'"'+this.redup(key)+'"'+indent+indent+'"'+obj[key]+'"'+nl;
        }
      }
      return buf;
    },
    redup: function(key){
      if (order && key.indexOf('\x11') !== -1) key=key.split('\x11')[1];                   // AveYo: restore number keys in node.js
      if (dups && key.indexOf('\x12') !== -1) key=key.split('\x12')[0];                       // AveYo: restore duplicate key names
      return key;
    },
    nr: function(key){return (!jscript && key.indexOf('\x11') == -1) ? '\x11'+key : key;}  // AveYo: check number key: vdf.nr('nr')
  };
} // End of ValveDataFormat

//---------------------------------------------------------------------------------------------------------------------------------
// Hybrid Node.js / JScript Engine by AveYo - can call specific functions as the first script argument
//---------------------------------------------------------------------------------------------------------------------------------
if (typeof ScriptEngine == 'function' && ScriptEngine() == 'JScript'){
  // start of JScript specific code
  jscript=true; engine='JScript'; w=WScript; launcher=new ActiveXObject('WScript.Shell'); argc=w.Arguments.Count();argv=[]; run='';
  if (argc > 0){ run=w.Arguments(0); for (var i=1;i<argc;i++) argv.push( '"'+w.Arguments(i).replace(/[\\\/]+/g,'\\\\')+'"'); }
  process={}; process.argv=[ScriptEngine(),w.ScriptFullName]; for (var j=0;j<argc;j++) process.argv[j+2]=w.Arguments(j); RN='\r\n';
  path={}; path.join=function(f,n){return fso.BuildPath(f,n);}; path.normalize=function(f){return fso.GetAbsolutePathName(f);};
  path.basename=function(f){return fso.GetFileName(f);};path.dirname=function(f){return fso.GetParentFolderName(f);};path.sep='\\';
  fs={}; fso=new ActiveXObject("Scripting.FileSystemObject"); ado=new ActiveXObject('ADODB.Stream'); DEF_ENCODING='Windows-1252';
  FileExists=function(f){ return fso.FileExists(f); }; PathExists=function(f){ return fso.FolderExists(f); };
  MakeDir=function(fn){
    if (fso.FolderExists(fn)) return; var pfn=fso.GetAbsolutePathName(fn), d=pfn.match(/[^\\\/]+/g), p='';
    for(var i=0,n=d.length; i<n; i++){ p+= d[i]+'\\'; if (!fso.FolderExists(p)) fso.CreateFolder(p); }
  };
  fs.readFileSync=function(fn, charset){
    var data=''; ado.Mode=3; ado.Type=2; ado.Charset=charset || 'Windows-1252'; ado.Open(); ado.LoadFromFile(fn);
    while (!ado.EOS) data+= ado.ReadText(131072); ado.Close(); return data;
  };
  fs.writeFileSync=function(fn, data, encoding){
    ado.Mode=3; ado.Type=2; ado.Charset=encoding || 'Windows-1252'; ado.Open();
    ado.WriteText(data); ado.SaveToFile(fn, 2); ado.Close(); return 0;
  };
  // end of JScript specific code
} else {
  // start of Node.js specific code
  jscript=false; engine='Node.js'; w={}; argc=process.argv.length; argv=[]; run=''; p=process.argv; w.quit=process.exit; RN='\r\n';
  if (argc > 2){ run=p[2]; for (var n=3;n<argc;n++) argv.push('"'+p[n].replace(/[\\\/]+/g,'\\\\')+'"'); }
  path=require('path'); fs=require('fs'); DEF_ENCODING='utf-8'; w.echo=function(s){console.log(s+'\r');};
  FileExists=function(f){ try{ return fs.statSync(f).isFile(); }catch(e){ if (e.code == 'ENOENT') return false; } };
  PathExists=function(f){ try{ return fs.statSync(f).isDirectory(); }catch(e){ if (e.code == 'ENOENT') return false; } };
  MakeDir=function(f){ try{ fs.mkdirSync(f); }catch(e){ if (e.code == 'ENOENT'){ MakeDir(path.dirname(f)); MakeDir(f); } } };
  // end of Node.js specific code
}
function timer(f){
  var b=new Date(); return { end:function(){ var e=new Date(), t=(e.getTime()-b.getTime())/1000; w.echo(f+': '+t+'s\r\n'); } };
}
// If run without parameters the .js file must have been double-clicked in shell, so try to launch the correct .bat file instead
if (jscript && run==='' && FileExists(w.ScriptFullName.slice(0, -2)+'bat')) launcher.Run('"'+w.ScriptFullName.slice(0, -2)+'bat"');
//---------------------------------------------------------------------------------------------------------------------------------
// Auto-run JS: if first script argument is a function name - call it, passing the next arguments
//---------------------------------------------------------------------------------------------------------------------------------
if (run && !(/[^A-Z0-9$_]/i.test(run))) new Function('if(typeof '+run+' == "function"){'+run+'('+argv+');}')();
//

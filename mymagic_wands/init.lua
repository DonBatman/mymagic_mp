-- init.lua (for mymagic_wands mod)

-- 1. Create the global table for this mod
mymagic_wands = {}

-- 2. Load Core Systems
-- These files should exist inside the mymagic_wands folder
local modpath = core.get_modpath("mymagic_wands")

dofile(modpath .. "/mana.lua")      -- Mana storage/regen
dofile(modpath .. "/register.lua")  -- Registration template
dofile(modpath .. "/hud.lua")       -- HUD display

-- 3. Load Wand Definitions
-- Ensure these .lua files are in your mymagic_wands folder
dofile(modpath .. "/fire_wand.lua")
dofile(modpath .. "/earth_wand.lua")
dofile(modpath .. "/water_wand.lua")
dofile(modpath .. "/air_wand.lua")
dofile(modpath .. "/light_wand.lua")
dofile(modpath .. "/shadow_wand.lua")

-- Note: blocks.lua, orbs_crystals.lua, and enchanter.lua 
-- should be loaded by the 'mymagic' mod's init.lua, NOT here.

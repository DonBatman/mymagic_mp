-- MyMagic Potions: Main Initialization
mymagic_potions = {}

local path = minetest.get_modpath("mymagic_potions")

dofile(path .. "/materials.lua")
--dofile(path .. "/items.lua")
dofile(path .. "/brewing.lua")
dofile(path .. "/potions.lua")
--dofile(path .. "/nodes.lua")

minetest.log("action", "[MyMagic Potions] Successfully initialized with all modules.")

-- MyMagic Potions: Brewing Logic & Mesh Node Registration

-- 1. Recipe Definition
local recipes = {
    ["default:apple"] = "mymagic_potions:potion_health",
    ["default:blueberries"] = "mymagic_potions:potion_mana",
    ["default:grass_8"] = "mymagic_potions:potion_swiftness",
    ["default:obsidian_shard"] = "mymagic_potions:potion_void",
    ["default:torch"] = "mymagic_potions:potion_fire_res",
    ["default:mese_crystal_fragment"] = "mymagic_potions:potion_night_vision",
}

-- 2. Formspec Helper
function mymagic_potions.get_formspec(progress)
    local p = progress or 0
    local p_percent = math.floor(p)
    
    -- Rotation R270 makes the Up-pointing arrow point Right
    local rotation = "^[transformR270"
    local arrow_bg = "gui_furnace_arrow_bg.png" .. rotation
    
    -- Using lowpart with rotation results in a Left-to-Right fill
    local arrow_fg = "gui_furnace_arrow_bg.png^[lowpart:" .. p_percent .. ":gui_furnace_arrow_fg.png" .. rotation
    
    local fs = "size[9,10]" ..
        "background[0,0;9,10;mymagic_fs_bg.png]" ..
        
        -- Ingredient Slot
        "label[3.9,0.5;Ingredient]" ..
        "list[context;src;4,1;1,1;]" ..
        
        -- Bottle Slot
        "label[3,1.6;Bottle]" ..
        "list[context;bottle;3,2;1,1;]" ..
        
        -- Fuel Slot
        "label[3.7,4;Crystals/Orbs]" ..
        "list[context;fuel;4,3;1,1;]" ..
        
        -- PROGRESS ARROW
        "image[4.05,2.1;0.9,0.8;" .. arrow_bg .. "]" ..
        "image[4.05,2.1;0.9,0.8;" .. arrow_fg .. "]" ..
        
        -- Result Slot
        "label[5.1,1.6;Output]" ..
        "list[context;dst;5,2;1,1;]" ..
        
        -- Player Inventory
        "label[0.5,4.7;Inventory]" ..
        "list[current_player;main;0.5,5.35;8,4;]" ..
        
        "listring[context;dst]" ..
        "listring[current_player;main]" ..
        "listring[context;src]" ..
        "listring[current_player;main]" ..
        "listring[context;bottle]" ..
        "listring[current_player;main]" ..
        "listring[context;fuel]" ..
        "listring[current_player;main]"
        
    return fs
end

-- 3. Brewing Logic
function mymagic_potions.run_brew(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    
    local src = inv:get_stack("src", 1)
    local bottle = inv:get_stack("bottle", 1)
    local fuel = inv:get_stack("fuel", 1)
    
    -- Check for valid bottles
    local has_bottle = bottle:get_name() == "vessels:glass_bottle" or bottle:get_name() == "mymagic_potions:glass_bottle"
    
    -- FIXED: Strict fuel validation
    local fuel_name = fuel:get_name()
    local has_valid_fuel = fuel_name == "mymagic_potions:mana_crystal" or fuel_name == "mymagic_potions:void_orb"
    
    local result_item = recipes[src:get_name()]
    
    -- Logic Check: Must have recipe, bottle, valid fuel, and space in output
    if not result_item or not has_bottle or not has_valid_fuel or not inv:room_for_item("dst", result_item) then
        if meta:get_int("progress") ~= 0 then
            meta:set_int("progress", 0)
            meta:set_string("formspec", mymagic_potions.get_formspec(0))
        end
        return false 
    end
    
    local progress = meta:get_int("progress")
    progress = progress + 10 
    
    if progress >= 100 then
        -- Complete brewing
        inv:add_item("dst", result_item)
        
        -- Take ingredients
        src:take_item(1)
        inv:set_stack("src", 1, src)
        
        bottle:take_item(1)
        inv:set_stack("bottle", 1, bottle)
        
        fuel:take_item(1)
        inv:set_stack("fuel", 1, fuel)
        
        progress = 0
        
        -- Play sound effect for completion
        minetest.sound_play("default_cool_lava", {pos = pos, gain = 0.5})
    end
    
    meta:set_int("progress", progress)
    meta:set_string("formspec", mymagic_potions.get_formspec(progress))
    
    return true
end

-- 4. Node Registration
minetest.register_node("mymagic_potions:brewing_stand", {
    description = "Magic Brewing Stand",
    drawtype = "mesh",
    mesh = "mymagic_brewing_stand.obj",
    tiles = {"mymagic_brewing_stand.png"}, 
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2, oddly_breakable_by_hand = 1},
    
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_int("progress", 0)
        meta:set_string("formspec", mymagic_potions.get_formspec(0))
        
        local inv = meta:get_inventory()
        inv:set_size("src", 1)
        inv:set_size("bottle", 1)
        inv:set_size("fuel", 1)
        inv:set_size("dst", 1)
    end,

    can_dig = function(pos, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        return inv:is_empty("src") and 
               inv:is_empty("bottle") and 
               inv:is_empty("fuel") and 
               inv:is_empty("dst")
    end,

    on_metadata_inventory_put = function(pos)
        local timer = minetest.get_node_timer(pos)
        if not timer:is_started() then
            timer:start(1.0)
        end
    end,

    on_timer = function(pos, elapsed)
        return mymagic_potions.run_brew(pos)
    end,
})

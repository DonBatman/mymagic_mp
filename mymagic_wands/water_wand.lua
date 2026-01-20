-- water_wand.lua
local powers = {}

-- 1. PASSIVE ABILITY: FROST WALK
-- When holding the wand, water beneath and around the player turns to ice.
core.register_globalstep(function(dtime)
    for _, player in ipairs(core.get_connected_players()) do
        local wielded = player:get_wielded_item()
        if wielded:get_name() == "mymagic_wands:water_wand" then
            local pos = player:get_pos()
            local level = math.max(1, wielded:get_meta():get_int("wand_level"))
            -- Radius of effect grows slightly with level
            local radius = 1 + math.floor(level / 8)
            
            -- Check a small area around the player's feet
            for dx = -radius, radius do
                for dz = -radius, radius do
                    -- Check just below the player and at foot level
                    for dy = -1, 0 do
                        local p = {x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}
                        local node = core.get_node(p).name
                        if node == "default:water_source" or node == "default:water_flowing" then
                            if not core.is_protected(p, player:get_player_name()) then
                                core.set_node(p, {name = "default:ice"})
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Ice Spear Entity
core.register_entity("mymagic_wands:ice_spear", {
    initial_properties = {
        visual = "sprite",
        textures = {"default_ice.png"},
        visual_size = {x=0.5, y=0.5},
    },
    on_step = function(self, dtime)
        local pos = self.object:get_pos()
        if core.get_node(pos).name ~= "air" then
            if not core.is_protected(pos, self.owner or "") then
                core.set_node(pos, {name="default:ice"})
            end
            self.object:remove()
        end
    end,
})

-- 2. ICE SPEAR (Left Click)
powers.ice_spear = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 15) then return itemstack end
    local pos = vector.add(user:get_pos(), {x=0, y=1.5, z=0})
    local spear = core.add_entity(pos, "mymagic_wands:ice_spear")
    if spear then
        spear:get_luaentity().owner = user:get_player_name()
        spear:set_velocity(vector.multiply(user:get_look_dir(), 20))
    end
    return itemstack
end

-- 3. ICE BOX (Right Click)
powers.ice_box = function(itemstack, user, pointed_thing)
    if pointed_thing.type ~= "object" then return itemstack end
    if not mymagic_wands.use_mana(user, 40) then return itemstack end
    local p = vector.round(pointed_thing.ref:get_pos())
    for dx = -1, 1 do
        for dz = -1, 1 do
            for dy = 0, 2 do
                if math.abs(dx) == 1 or math.abs(dz) == 1 or dy == 2 then
                    local bpos = {x=p.x+dx, y=p.y+dy, z=p.z+dz}
                    if not core.is_protected(bpos, user:get_player_name()) then
                        core.set_node(bpos, {name="default:ice"})
                    end
                end
            end
        end
    end
    return itemstack
end

mymagic_wands.register({
    name = "water_wand",
    description = "Aqua Dominion",
    wield_image = "mymagic_wand_blue.png",
    on_use = powers.ice_spear,
    on_secondary_use = powers.ice_box,
})

-- Standardized Crafting Recipe
core.register_craft({
    output = "mymagic_wands:water_wand",
    recipe = {
        {"default:glass", "default:diamond", "default:glass"},
        {"", "default:steel_ingot", ""},
        {"", "wool:blue", ""}, 
    }
})

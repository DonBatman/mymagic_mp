-- fire_wand.lua
local powers = {}
local wand_cooldowns = {}

local function check_cooldown(name, seconds)
    local now = core.get_us_time()
    if wand_cooldowns[name] and now - wand_cooldowns[name] < (seconds * 1e6) then return false end
    wand_cooldowns[name] = now
    return true
end

-- Fireball Power
powers.fireball = function(itemstack, user, pointed_thing)
    local pname = user:get_player_name()
    local level = math.max(1, itemstack:get_meta():get_int("wand_level"))
    
    if not check_cooldown(pname, 1.5) then return itemstack end
    if not mymagic_wands.use_mana(user, 20) then return itemstack end

    local pos = vector.add(user:get_pos(), {x=0, y=1.5, z=0})
    local dir = user:get_look_dir()
    local fireball = core.add_entity(pos, "mymagic_wands:fireball_entity")
    
    if fireball then
        fireball:set_velocity(vector.multiply(dir, 15 + level))
        fireball:get_luaentity().owner = pname
        fireball:get_luaentity().damage = 4 + level
    end
    return itemstack
end

-- Toggle Lava Power
powers.toggle_stone_lava = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 30) then return itemstack end
    local eye = vector.add(user:get_pos(), {x=0, y=1.5, z=0})
    local ray = core.raycast(eye, vector.add(eye, vector.multiply(user:get_look_dir(), 8)), false, false)
    local hit = ray:next()

    if hit and hit.type == "node" then
        local node = core.get_node(hit.under).name
        if node == "default:stone" or node == "default:cobble" then
            core.set_node(hit.under, {name="default:lava_source"})
        elseif node == "default:lava_source" then
            core.set_node(hit.under, {name="default:stone"})
        end
    end
    return itemstack
end

-- Ring of Fire Power
powers.ring_of_fire = function(itemstack, user, pointed_thing)
    -- Logic: If pointing at a player/mob, center fire on them. 
    -- Otherwise, center fire on the user.
    local target = (pointed_thing.type == "object") and pointed_thing.ref or user
    
    if not mymagic_wands.use_mana(user, 40) then return itemstack end

    local pos = vector.round(target:get_pos())
    local level = math.max(1, itemstack:get_meta():get_int("wand_level"))
    local size = math.min(4, 1 + math.floor(level/5)) -- Radius grows with level

    for dx = -size, size do
        for dz = -size, size do
            -- Only create the border of the square
            if math.abs(dx) == size or math.abs(dz) == size then
                local fpos = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
                -- Check if node is air and not protected
                if core.get_node(fpos).name == "air" and not core.is_protected(fpos, user:get_player_name()) then
                    core.set_node(fpos, {name="fire:basic_flame"})
                end
            end
        end
    end
    
    -- Visual Feedback
    core.chat_send_player(user:get_player_name(), "§6Ignis Circularis!")
    
    return itemstack
end

-- Fireball Entity
core.register_entity("mymagic_wands:fireball_entity", {
    initial_properties = {
        visual = "sprite",
        textures = {"fire_basic_flame.png"},
        visual_size = {x=0.7, y=0.7},
    },
    damage = 4,
    on_step = function(self, dtime)
        local pos = self.object:get_pos()
        if core.get_node(pos).name ~= "air" then
            -- Create a small flame where it hits
            if core.get_node(pos).name ~= "ignore" then
                 core.set_node(pos, {name="fire:basic_flame"})
            end
            self.object:remove()
        end
    end,
})

mymagic_wands.register({
    name = "fire_wand",
    description = "Inferno's Embrace",
    wield_image = "mymagic_wand_red.png",
    on_use = powers.fireball,
    on_use_sneak = powers.toggle_stone_lava,
    on_secondary_use = powers.ring_of_fire,
})

-- Standardized Crafting Recipe
core.register_craft({
    output = "mymagic_wands:fire_wand",
    recipe = {
        {"default:glass", "default:diamond", "default:glass"},
        {"", "default:steel_ingot", ""},
        {"", "wool:red", ""}, 
    }
})

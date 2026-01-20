-- air_wand.lua
local powers = {}

-- Store players who are currently protected from fall damage
local fall_protected = {}

-- Global callback to prevent fall damage for protected players
-- This ensures that the next time you hit the ground after a leap, you take 0 damage.
core.register_on_player_hpchange(function(player, hp_change, reason)
    if reason and reason.type == "fall" then
        local name = player:get_player_name()
        if fall_protected[name] then
            fall_protected[name] = nil -- Consume the protection
            return 0
        end
    end
    return hp_change
end)

-- 1. GUST (Left Click)
powers.gust = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 15) then return itemstack end
    local pos = user:get_pos()
    local level = math.max(1, itemstack:get_meta():get_int("wand_level"))
    local force = 10 + level

    for _, obj in ipairs(core.get_objects_inside_radius(pos, 6)) do
        if obj ~= user then
            local opos = obj:get_pos()
            local dir = vector.direction(pos, opos)
            obj:add_velocity({x=dir.x*force, y=4, z=dir.z*force})
        end
    end
    return itemstack
end

-- 2. CLOUD LEAP (Shift + Left Click)
powers.leap = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 20) then return itemstack end
    
    local name = user:get_player_name()
    -- Launch player upwards
    user:add_velocity({x=0, y=18, z=0})
    
    -- Flag the player for fall protection
    fall_protected[name] = true
    
    core.chat_send_player(name, "§bAscension!")
    return itemstack
end

-- 3. VACUUM (Right Click)
-- Pulls nearby items and small objects toward the player
powers.vacuum = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 10) then return itemstack end
    
    local pos = user:get_pos()
    local level = math.max(1, itemstack:get_meta():get_int("wand_level"))
    local radius = 8 + math.floor(level / 5)
    
    local objects = core.get_objects_inside_radius(pos, radius)
    for _, obj in ipairs(objects) do
        local lua_ent = obj:get_luaentity()
        -- Ensure we don't pull the user, and prioritize items/mobs
        if obj ~= user then
            local opos = obj:get_pos()
            -- Calculate direction from object TO player
            local dir = vector.direction(opos, pos)
            
            -- Increase pull strength based on distance and level
            local dist = vector.distance(opos, pos)
            local force = (7 + (level / 2)) * (dist / radius)
            
            -- Apply velocity. We add a slight upward lift to prevent 
            -- friction with the ground from stopping the pull.
            obj:add_velocity({
                x = dir.x * force,
                y = (dir.y * force) + 2,
                z = dir.z * force
            })
        end
    end
    
    core.chat_send_player(user:get_player_name(), "§bVortex!")
    return itemstack
end

mymagic_wands.register({
    name = "air_wand",
    description = "Zephyr's Reach",
    wield_image = "mymagic_wand_blue.png^[colorize:#FFFFFF:150",
    on_use = powers.gust,
    on_use_sneak = powers.leap,
    on_secondary_use = powers.vacuum,
})

-- Standardized Crafting Recipe
core.register_craft({
    output = "mymagic_wands:air_wand",
    recipe = {
        {"default:glass", "default:diamond", "default:glass"},
        {"", "default:steel_ingot", ""},
        {"", "wool:white", ""}, 
    }
})

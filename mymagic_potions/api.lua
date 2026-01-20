-- Tower of Arcana: API & Helper Functions
-- This file contains shared logic used by nodes, items, and mobs.

arcana.api = {}

-- 1. Mana Validation Logic
-- Checks if a player has enough mana and subtracts it if they do.
-- Usage: if arcana.api.consume_mana(player, 20) then ...
function arcana.api.consume_mana(player, amount)
    local name = player:get_player_name()
    -- Note: player_data is defined globally in init.lua
    local data = player_data[name]
    
    if data and data.mana >= amount then
        data.mana = data.mana - amount
        return true
    end
    
    minetest.chat_send_player(name, "Insufficient Mana!")
    return false
end

-- 2. Arcane Spawning Logic
-- Finds a valid position near a point to spawn a ghost or item.
-- Avoids spawning things inside solid walls.
function arcana.api.get_safe_spawn_pos(pos, radius)
    local attempts = 0
    while attempts < 10 do
        local offset = {
            x = math.random(-radius, radius),
            y = math.random(0, 2), -- Prefer ground level or slightly above
            z = math.random(-radius, radius)
        }
        local target = vector.add(pos, offset)
        local node = minetest.get_node(target)
        local node_below = minetest.get_node({x=target.x, y=target.y-1, z=target.z})
        
        -- Check if target is air and there is ground below
        if node.name == "air" and node_below.name ~= "air" then
            return target
        end
        attempts = attempts + 1
    end
    return nil
end

-- 3. Particle Effects
-- A reusable function to create "Arcane Poof" effects
function arcana.api.spawn_particles(pos, color)
    minetest.add_particlespawner({
        amount = 20,
        time = 0.5,
        minpos = vector.subtract(pos, 0.5),
        maxpos = vector.add(pos, 0.5),
        minvel = {x = -1, y = 1, z = -1},
        maxvel = {x = 1, y = 2, z = 1},
        minacc = {x = 0, y = -2, z = 0},
        maxacc = {x = 0, y = -4, z = 0},
        minexptime = 1,
        maxexptime = 2,
        minsize = 1,
        maxsize = 3,
        texture = "arcana_particle.png^[multiply:" .. (color or "#FFFFFF"),
    })
end

minetest.log("info", "[Tower of Arcana] API Loaded")

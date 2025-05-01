local powers = {}

-- Cooldown table for the tunnel ability
local wand_cooldowns = {}

powers.whirlwind = function(itemstack, user, pointed_thing)
    local caster_name = user:get_player_name()

    -- Cast ray to find a target object.
    local origin = vector.add(user:get_pos(), {x = 0, y = 1.5, z = 0})
    local dir = user:get_look_dir()
    local max_distance = 20
    local ray = minetest.raycast(origin, vector.add(origin, vector.multiply(dir, max_distance)), true, false)
    local target = nil

    for pointed in ray do
        if pointed.type == "object" and pointed.ref and pointed.ref:is_player()
           and pointed.ref:get_player_name() ~= caster_name then
            target = pointed.ref
            break
        end
    end

    if not target then
        minetest.chat_send_player(caster_name, "No valid target for whirlwind!")
        return itemstack
    end

    -- Get the target's position.
    local target_pos = target:get_pos()
    minetest.chat_send_player(caster_name, "Whirlwind cast on " .. target:get_player_name() .. "!")

    -- Add whirlwind particle effect around the target.
    minetest.add_particlespawner({
        amount = 100,
        time = 3,  -- Duration of the whirlwind
        minpos = {x = target_pos.x - 1, y = target_pos.y, z = target_pos.z - 1},
        maxpos = {x = target_pos.x + 1, y = target_pos.y + 2, z = target_pos.z + 1},
        minvel = {x = -1, y = 0.5, z = -1},
        maxvel = {x = 1, y = 1.5, z = 1},
        minexptime = 0.5,
        maxexptime = 1.0,
        minsize = 2,
        maxsize = 5,
        texture = "default_sand.png",
    })

    -- Blind and disorient the target.
    for i = 1, 3 do
        minetest.after(i, function()
            if target and target:get_hp() > 0 then
                local random_look = {
                    x = math.random(-0.5, 0.5),
                    y = math.random(-0.3, 0.3),
                }
                target:set_look_horizontal(target:get_look_horizontal() + random_look.x)
                target:set_look_vertical(target:get_look_vertical() + random_look.y)
                target:set_hp(target:get_hp() - 0.5)  -- Apply slight damage per second
            end
        end)
    end

    -- Notify the affected player.
    minetest.chat_send_player(target:get_player_name(), "You are caught in a whirlwind and feel disoriented!")

    return itemstack
end

powers.dig_tunnel = function(itemstack, user, pointed_thing)
    local player_name = user:get_player_name()
    local now = minetest.get_us_time()
    local cooldown_time = 2 * 1e6 -- 2 seconds in microseconds

    -- Check cooldown
    if wand_cooldowns[player_name] and now - wand_cooldowns[player_name] < cooldown_time then
        minetest.chat_send_player(player_name, "The wand is recharging!")
        return itemstack
    end
    wand_cooldowns[player_name] = now

    if pointed_thing.type ~= "node" then
        return itemstack
    end

    local start_pos = pointed_thing.under
    local look_dir = user:get_look_dir()
    look_dir.y = 0
    if vector.length(look_dir) == 0 then
        look_dir = { x = 0, y = 0, z = 1 }
    else
        look_dir = vector.normalize(look_dir)
    end

    local up = { x = 0, y = 1, z = 0 }
    local right = { x = look_dir.z, y = 0, z = -look_dir.x }
    local tunnel_length = 5

    -- Collect all positions to dig
    local positions = {}
    for i = 0, tunnel_length - 1 do
        local center = {
            x = start_pos.x + look_dir.x * i,
            y = start_pos.y,
            z = start_pos.z + look_dir.z * i,
        }
        for r = -1, 1 do
            for u = -1, 1 do
                local pos = {
                    x = center.x + right.x * r + up.x * u,
                    y = center.y + right.y * r + up.y * u,
                    z = center.z + right.z * r + up.z * u,
                }
                pos.x = math.floor(pos.x + 0.5)
                pos.y = math.floor(pos.y + 0.5)
                pos.z = math.floor(pos.z + 0.5)
                table.insert(positions, pos)
            end
        end
    end

    local function dig_next(idx)
        local pos = positions[idx]
        if not pos then return end
        if not core.is_protected(pos, player_name) then
            local node_name = minetest.get_node(pos).name
            if minetest.registered_nodes[node_name]
               and minetest.registered_nodes[node_name].groups.unbreakable ~= 1 then
                minetest.set_node(pos, { name = "air" })
            else
                core.record_protection_violation(pos, player_name)
            end
        end
        if positions[idx + 1] then
            minetest.after(0, dig_next, idx + 1)
        end
    end

    dig_next(1)
    return itemstack
end

-- Gather all flower node names registered as "flowers:*"
local function get_flower_list()
    local flower_list = {}
    for name, _ in pairs(minetest.registered_nodes) do
        if name:match("^flowers:") then
            table.insert(flower_list, name)
        end
    end
    return flower_list
end

local flower_list = get_flower_list()

-- Function to grow flowers around the player if wielding the wand.
local function grow_flowers_around(player)
    -- Check if the player is wielding the magic wand.
    local wield_item = player:get_wielded_item()
    if wield_item:get_name() ~= "mymagic_wands:earth_wand" then
        return
    end

    -- Round the player's position to the nearest node.
    local pos = vector.round(player:get_pos())
    -- Verify the node directly below the player.
    local node_below = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z}).name

    -- Only attempt flower growth if the ground is valid.
    if node_below == "default:dirt_with_grass" then
        -- Place a flower in a randomly selected nearby location (2 attempts per cycle).
        for i = 1, 2 do
            local offset_x = math.random(-2, 2)
            local offset_z = math.random(-2, 2)
            local flower_pos = {
                x = pos.x + offset_x,
                y = pos.y,  -- Position where the flower node will be placed.
                z = pos.z + offset_z
            }
            -- Check that the flower position is not protected.
            if not minetest.is_protected(flower_pos, player:get_player_name()) then
                -- Now check that the node below this position is a valid ground node.
                local ground_pos = {x = flower_pos.x, y = flower_pos.y - 1, z = flower_pos.z}
                local ground_node = minetest.get_node(ground_pos).name
                if (ground_node == "default:dirt" or ground_node == "default:dirt_with_grass")
                   and minetest.get_node(flower_pos).name == "air"
                   and #flower_list > 0 then
                    local flower = flower_list[math.random(1, #flower_list)]
                    minetest.set_node(flower_pos, {name = flower})
                end
            end
        end
    end
end

-- Create the wand item.
local wand = {
    name = "earth_wand",
    description = "Terra Shaper",
    wield_image = "mymagic_wand_orange.png",
    on_use = powers.dig_tunnel,
    on_secondary_use = powers.whirlwind,
}

mymagic_wands.register(wand)

-- Flower spawn timer table to reduce placement frequency per player.
local flower_timer = {}

minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local player_name = player:get_player_name()
        flower_timer[player_name] = (flower_timer[player_name] or 0) + dtime
        if flower_timer[player_name] >= 2 then  -- Only trigger every 2 seconds
            flower_timer[player_name] = 0
            grow_flowers_around(player)
        end
    end
end)
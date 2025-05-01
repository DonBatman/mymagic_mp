local powers = {}

-- Cooldown table
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
    local cooldown_time = 2 * 1e6 -- 1 second in microseconds

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

local wand = {
    name = "earth_wand",
    description = "Terra Shaper",
    wield_image = "mymagic_wand_orange.png",
    on_use = powers.dig_tunnel,
    on_secondary_use = powers.whirlwind,
}

mymagic_wands.register(wand)
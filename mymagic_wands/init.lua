local burning_players = {}

minetest.register_tool("mymagic_wands:fire_wand", {
    description = "Inferno's Embrace - Fire Wand",
    inventory_image = "mymagic_wand_red.png",
    wield_image = "mymagic_wand_red.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            cracky = {
                times = { [1] = 2.0, [2] = 1.0, [3] = 0.5 },
                uses = 20,
                maxlevel = 1,
            },
        },
        damage_groups = { fleshy = 5 },
    },


    on_use = function(itemstack, user, pointed_thing)
        return itemstack
    end,

    on_place = function(itemstack, placer, pointed_thing)
        if pointed_thing and pointed_thing.type == "object" then
            local obj = pointed_thing.ref
            if obj and obj:is_player() then
                local pname = obj:get_player_name()
                if burning_players[pname] then
                    return itemstack
                end

                burning_players[pname] = true

                local pos = obj:get_pos()
                if pos then
                    minetest.add_particle({
                        pos = pos,
                        velocity = { x = 0, y = 1, z = 0 },
                        acceleration = { x = 0, y = 0, z = 0 },
                        expirationtime = 1.0,
                        size = 8,
                        collisiondetection = false,
                        texture = "fire_basic_flame.png",
                    })
                end
                for i = 1, 3 do
                    minetest.after(i, function()
                        if obj and obj:get_pos() then
                            local current_hp = obj:get_hp() or 20
                            obj:set_hp(current_hp - 0.15)
                        end
                    end)
                end
                minetest.after(3.1, function()
                    burning_players[pname] = nil
                end)
            end
        end
        return itemstack
    end,
    on_secondary_use = function(itemstack, user, pointed_thing)
        if not user then
            return itemstack
        end

        if pointed_thing and pointed_thing.type == "object" then
            local obj = pointed_thing.ref
            if obj and obj:is_player() then
                local pname = obj:get_player_name()
                if burning_players[pname] then
                    return itemstack
                end

                burning_players[pname] = true

                local player_pos = obj:get_pos()
                local eye_offset = { x = 0, y = 1.625, z = 0 }
                local user_eye_pos = vector.add(user:get_pos(), eye_offset)
                local mouse_pos = vector.add(user_eye_pos, vector.multiply(user:get_look_dir(), 2))
                if player_pos and mouse_pos then
                    local direction = {
                        x = player_pos.x - mouse_pos.x,
                        y = player_pos.y - mouse_pos.y,
                        z = player_pos.z - mouse_pos.z,
                    }
                    direction = vector.normalize(direction) or direction
                    local speed = 20
                    local velocity = {
                        x = direction.x * speed,
                        y = direction.y * speed,
                        z = direction.z * speed,
                    }
                    minetest.add_particle({
                        pos = mouse_pos,
                        velocity = velocity,
                        acceleration = { x = 0, y = 0, z = 0 },
                        expirationtime = 0.2,
                        size = 6,
                        collisiondetection = false,
                        texture = "fire_basic_flame.png",
                    })
                    minetest.add_particlespawner({
                        amount = 50,
                        time = 3,
                        minpos = { x = -0.5, y = -1, z = -0.5 },
                        maxpos = { x = 0.5, y = 1, z = 0.5 },
                        minvel = { x = -1, y = 1, z = -1 },
                        maxvel = { x = 1, y = 3, z = 1 },
                        minacc = { x = 0, y = 0, z = 0 },
                        maxacc = { x = 0, y = 0, z = 0 },
                        minexptime = 0.5,
                        maxexptime = 1.0,
                        minsize = 1,
                        maxsize = 2,
                        collisiondetection = false,
                        attached = obj,
                        texture = "fire_basic_flame.png",
                    })
                end

                if obj and obj:get_pos() then
                    local current_hp = obj:get_hp() or 20
                    obj:set_hp(current_hp - 0.15)
                end

                for i = 1, 3 do
                    minetest.after(i, function()
                        if obj and obj:get_pos() then
                            local current_hp = obj:get_hp() or 20
                            obj:set_hp(current_hp - 0.15)
                        end
                    end)
                end
                minetest.after(3.1, function()
                    burning_players[pname] = nil
                end)
            end
        end
        return itemstack
    end,
})

local frozen_targets = {}  

local function create_ice_box_around_target(target)
    local center = target:get_pos()
    local cx = math.floor(center.x + 0.5)
    local cy = math.floor(center.y) 
    local cz = math.floor(center.z + 0.5)
    for dx = -1, 1 do
        for dz = -1, 1 do
            for dy = 0, 3 do
                local pos = { x = cx + dx, y = cy + dy, z = cz + dz }
                if dy == 0 or dy == 3 then
                    minetest.set_node(pos, {name = "default:ice"})
                else
                    if math.abs(dx) == 1 or math.abs(dz) == 1 then
                        minetest.set_node(pos, {name = "default:ice"})
                    else
                        minetest.set_node(pos, {name = "default:water_source"})
                    end
                end
            end
        end
    end
    minetest.chat_send_player(target:get_player_name(), "You have been encased in an ice box!")
end

local function ice_box_target(user)
    local caster = user:get_player_name()
    local origin = vector.add(user:get_pos(), {x = 0, y = 1.5, z = 0})
    local dir = user:get_look_dir()
    local max_distance = 20
    local ray = minetest.raycast(origin, vector.add(origin, vector.multiply(dir, max_distance)), true, false)
    local target = nil
    for pointed in ray do
        if pointed.type == "object" and pointed.ref then
            if pointed.ref:is_player() and pointed.ref:get_player_name() ~= caster then
                target = pointed.ref
                break
            end
        end
    end
    if target then
        create_ice_box_around_target(target)
        minetest.chat_send_player(caster, "Ice Box activated on " .. target:get_player_name() .. "!")
    else
        minetest.chat_send_player(caster, "No valid target found for Ice Box!")
    end
end

local function freeze_player_target(user)
    local caster = user:get_player_name()
    local origin = vector.add(user:get_pos(), {x = 0, y = 1.5, z = 0})
    local dir = user:get_look_dir()
    local max_distance = 20
    local ray = minetest.raycast(origin, vector.add(origin, vector.multiply(dir, max_distance)), true, false)
    local target = nil

    for pointed in ray do
        if pointed.type == "object" and pointed.ref then
            if pointed.ref:is_player() and pointed.ref:get_player_name() ~= caster then
                target = pointed.ref
                break
            end
        end
    end

    if target then
        local target_name = target:get_player_name()
        if frozen_targets[target_name] then
            minetest.chat_send_player(caster, target_name .. " is already frozen!")
            return
        end

        frozen_targets[target_name] = true
        local target_pos = target:get_pos()
        minetest.add_particlespawner({
            amount = 200,
            time = 3,  -- Particle effect lasts 3 seconds.
            minpos = origin,
            maxpos = target_pos,
            minvel = {x = 0, y = 0, z = 0},
            maxvel = {x = 0, y = 0, z = 0},
            minexptime = 1,
            maxexptime = 1.5,
            minsize = 1,
            maxsize = 2,
            texture = "freeze_particle.png",
        })

        target:set_physics_override({speed = 0, jump = 0})
        minetest.chat_send_player(caster, "Freeze activated on " .. target_name .. "!")
        for i = 1, 3 do
            minetest.after(i, function()
                if target and target:get_player_name() then
                    target:set_hp(target:get_hp() - 0.15)
                end
            end)
        end

        minetest.after(3, function()
            if target and target:get_player_name() then
                target:set_physics_override({speed = 1.0, jump = 1.0})
                minetest.chat_send_player(caster, target_name .. " is thawed!")
            end
            frozen_targets[target_name] = nil
        end)
    else
        minetest.chat_send_player(caster, "No valid target found!")
    end
end

minetest.register_tool("mymagic_wands:water_wand", {
    description = "Aqua Dominion - Water & Ice Wand",
    inventory_image = "mymagic_wand_blue.png",
    wield_image = "mymagic_wand_blue.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            cracky = {
                times = { [1] = 2.0, [2] = 1.0, [3] = 0.5 },
                uses = 20,
                maxlevel = 1,
            },
        },
        damage_groups = {fleshy = 5},
    },
    
    on_use = function(itemstack, user, pointed_thing)
        freeze_player_target(user)
        return itemstack
    end,
    
    on_secondary_use = function(itemstack, user, pointed_thing)
        ice_box_target(user)
        return itemstack
    end,
})
----------------------------------------------------------------------------------
-- Globalstep: Turn water into ice beneath (and around) players holding the water wand.
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        if player:get_wielded_item():get_name() == "mymagic_wands:water_wand" then
            local pos = player:get_pos()
            local center = {
                x = math.floor(pos.x + 0.5),
                y = math.floor(pos.y),
                z = math.floor(pos.z + 0.5)
            }
            -- Loop through a 3x3 area beneath/around the player
            for dx = -1, 1 do
                for dz = -1, 1 do
                    local nodepos = {
                        x = center.x + dx,
                        y = center.y,
                        z = center.z + dz
                    }
                    local node = minetest.get_node(nodepos)
                    if node.name == "default:water_source" or node.name == "default:water_flowing" then
                        minetest.set_node(nodepos, {name = "default:ice"})
                    end
                end
            end
        end
    end
end)

-- Air Wand: Gust and Updraft Abilities
minetest.register_tool("mymagic_wands:air_wand", {
    description = "Zephyr's Gale - Air Wand",
    inventory_image = "mymagic_wand_green.png",
    wield_image = "mymagic_wand_green.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            crumbly = {
                times = { [1] = 2.0, [2] = 1.0, [3] = 0.5 },
                uses = 20,
                maxlevel = 1,
            },
        },
        damage_groups = { fleshy = 2 },
    },

    -- PRIMARY USE: Gust - Pushes target away and deals minor damage
    on_use = function(itemstack, user, pointed_thing)
        local caster = user:get_player_name()
        local origin = vector.add(user:get_pos(), {x = 0, y = 1.5, z = 0})
        local dir = user:get_look_dir()
        local max_distance = 20
        local ray = minetest.raycast(origin, vector.add(origin, vector.multiply(dir, max_distance)), true, false)
        local target = nil

        for pointed in ray do
            if pointed.type == "object" and pointed.ref and pointed.ref:is_player() and pointed.ref:get_player_name() ~= caster then
                target = pointed.ref
                break
            end
        end

        if not target then
            minetest.chat_send_player(caster, "No valid target for Gust!")
            return itemstack
        end

        -- Push the target away from the caster
        local push_dir = vector.normalize(vector.subtract(target:get_pos(), user:get_pos()))
        local velocity = vector.multiply(push_dir, 8)
        velocity.y = 3  -- Add a bit of upward force
        target:add_player_velocity(velocity)
        target:set_hp(target:get_hp() - 0.5)
        minetest.chat_send_player(caster, "Gust cast on " .. target:get_player_name() .. "!")
        minetest.chat_send_player(target:get_player_name(), "You are blasted by a gust of wind!")
        minetest.add_particlespawner({
            amount = 40,
            time = 0.5,
            minpos = vector.subtract(target:get_pos(), {x=0.5, y=0, z=0.5}),
            maxpos = vector.add(target:get_pos(), {x=0.5, y=2, z=0.5}),
            minvel = {x=-2, y=2, z=-2},
            maxvel = {x=2, y=4, z=2},
            minexptime = 0.3,
            maxexptime = 0.7,
            minsize = 2,
            maxsize = 4,
            texture = "mymagic_wand_green2.png",
        })
        return itemstack
    end,

    -- SECONDARY USE: Updraft - Launches entities upward at target location
    on_secondary_use = function(itemstack, user, pointed_thing)
        local caster = user:get_player_name()
        local origin = vector.add(user:get_pos(), {x = 0, y = 1.5, z = 0})
        local dir = user:get_look_dir()
        local max_distance = 20
        local ray = minetest.raycast(origin, vector.add(origin, vector.multiply(dir, max_distance)), false, true)
        local updraft_pos = nil

        for pointed in ray do
            if pointed.type == "node" and pointed.under then
                updraft_pos = pointed.above
                break
            end
        end

        if not updraft_pos then
            minetest.chat_send_player(caster, "No valid location for Updraft!")
            return itemstack
        end

        -- Launch all players/mobs in a 2-block radius upward
        local objs = minetest.get_objects_inside_radius(updraft_pos, 2)
        for _, obj in ipairs(objs) do
            if obj:is_player() or obj:get_luaentity() then
                obj:add_player_velocity({x=0, y=12, z=0})
                if obj:is_player() then
                    minetest.chat_send_player(obj:get_player_name(), "You are launched by an updraft!")
                end
            end
        end

        minetest.add_particlespawner({
            amount = 60,
            time = 1,
            minpos = vector.subtract(updraft_pos, {x=1, y=0, z=1}),
            maxpos = vector.add(updraft_pos, {x=1, y=3, z=1}),
            minvel = {x=0, y=2, z=0},
            maxvel = {x=0, y=6, z=0},
            minexptime = 0.5,
            maxexptime = 1.0,
            minsize = 2,
            maxsize = 5,
            texture = "mymagic_wand_green2.png",
        })
        minetest.chat_send_player(caster, "Updraft created!")
        return itemstack
    end,
})

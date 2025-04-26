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

local frozen_players = {}

minetest.register_tool("mymagic_wands:freeze_wand", {
    description = "Glacial Grip - Freeze Wand",
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
        damage_groups = { fleshy = 5 },
    },
    on_use = function(itemstack, user, pointed_thing)
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
                if frozen_players[pname] then
                    return itemstack
                end
                frozen_players[pname] = true

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
                        texture = "freeze_particle.png",
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
                        texture = "freeze_particle.png",
                    })
                end
                obj:set_physics_override({speed = 0, jump = 0})

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
                    frozen_players[pname] = nil
                    if obj then
                        obj:set_physics_override({speed = 1, jump = 1})
                    end
                end)
            end
        end
        return itemstack
    end,
})
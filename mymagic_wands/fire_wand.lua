local powers = {}

-- Cooldown table for all powers except passive
local wand_cooldowns = {}

local function check_and_set_cooldown(player_name)
    local now = minetest.get_us_time()
    local cooldown_time = 2 * 1e6 -- 2 seconds in microseconds
    if wand_cooldowns[player_name] and now - wand_cooldowns[player_name] < cooldown_time then
        return false
    end
    wand_cooldowns[player_name] = now
    return true
end

-- Fireball: Shoots a fireball that sets fire and damages entities
powers.fireball = function(itemstack, user, pointed_thing)
    local player_name = user:get_player_name()
    if not check_and_set_cooldown(player_name) then return itemstack end
    local pos = vector.add(user:get_pos(), {x=0, y=1.5, z=0})
    local dir = user:get_look_dir()
    local fireball_speed = 15
    local fireball = minetest.add_entity(pos, "mymagic_wands:fireball_entity")
    if fireball then
        fireball:set_velocity(vector.multiply(dir, fireball_speed))
        fireball:set_acceleration({x=0, y=-5, z=0})
        fireball:get_luaentity().owner = player_name
    end
    return itemstack
end

-- Toggle stone/cobble <-> lava using raycast and also check node above for lava
powers.toggle_stone_lava = function(itemstack, user, pointed_thing)
    local player_name = user:get_player_name()
    if not check_and_set_cooldown(player_name) then return itemstack end

    -- Use raycast to find the first node hit
    local eye_pos = vector.add(user:get_pos(), {x=0, y=1.5, z=0})
    local dir = user:get_look_dir()
    local ray = minetest.raycast(eye_pos, vector.add(eye_pos, vector.multiply(dir, 8)), false, false)
    local hit
    for pointed in ray do
        if pointed.type == "node" then
            hit = pointed
            break
        end
    end
    if not hit then return itemstack end

    local pos_under = hit.under
    local pos_above = hit.above
    if minetest.is_protected(pos_under, player_name) then return itemstack end

    local node_under = minetest.get_node(pos_under)
    local node_above = minetest.get_node(pos_above)

    -- Stone/cobble to lava (use under)
    if node_under.name == "default:stone" or node_under.name == "default:cobble" then
        minetest.set_node(pos_under, {name="default:lava_source"})
    -- Lava to stone (use above if above is lava)
    elseif node_above.name == "default:lava_source" or node_above.name == "default:lava_flowing" then
        minetest.set_node(pos_above, {name="default:stone"})
    end
    return itemstack
end

-- Ring of fire around the player
powers.ring_of_fire = function(itemstack, user, pointed_thing)
    local pos = vector.round(user:get_pos())
    local player_name = user:get_player_name()
    for dx = -2,2 do
        for dz = -2,2 do
            if math.abs(dx) == 2 or math.abs(dz) == 2 then
                local fire_pos = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
                local node = minetest.get_node(fire_pos).name
                if node == "air" and not minetest.is_protected(fire_pos, player_name) then
                    minetest.set_node(fire_pos, {name="fire:basic_flame"})
                end
            end
        end
    end
    return itemstack
end

-- Ring of fire around the pointed player (only if it's a player)
powers.ring_of_fire_pointed_player = function(itemstack, user, pointed_thing)
    if pointed_thing.type ~= "object" or not pointed_thing.ref or not pointed_thing.ref:is_player() then
        return itemstack
    end
    local target = pointed_thing.ref
    local pos = vector.round(target:get_pos())
    local player_name = user:get_player_name()
    for dx = -2,2 do
        for dz = -2,2 do
            if math.abs(dx) == 2 or math.abs(dz) == 2 then
                local fire_pos = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
                local node = minetest.get_node(fire_pos).name
                if node == "air" and not minetest.is_protected(fire_pos, player_name) then
                    minetest.set_node(fire_pos, {name="fire:basic_flame"})
                end
            end
        end
    end
    return itemstack
end

-- Ring of fire around the pointed player or mob (but not the user)
powers.ring_of_fire_pointed_entity = function(itemstack, user, pointed_thing)
    local player_name = user:get_player_name()
    if not check_and_set_cooldown(player_name) then return itemstack end
    if pointed_thing.type ~= "object" or not pointed_thing.ref then
        return itemstack
    end
    local target = pointed_thing.ref
    -- Don't allow targeting yourself
    if target:is_player() and target:get_player_name() == player_name then
        return itemstack
    end
    local pos = vector.round(target:get_pos())
    for dx = -2,2 do
        for dz = -2,2 do
            if math.abs(dx) == 2 or math.abs(dz) == 2 then
                local fire_pos = {x=pos.x+dx, y=pos.y, z=pos.z+dz}
                local node = minetest.get_node(fire_pos).name
                if node == "air" and not minetest.is_protected(fire_pos, player_name) then
                    minetest.set_node(fire_pos, {name="fire:basic_flame"})
                end
            end
        end
    end
    return itemstack
end

-- Register fireball entity
minetest.register_entity("mymagic_wands:fireball_entity", {
    initial_properties = {
        physical = false,
        collide_with_objects = true,
        pointable = false,
        visual = "sprite",
        textures = {"fire_basic_flame.png"},
        visual_size = {x=0.7, y=0.7},
        damage = 4,
    },
    timer = 0,
    owner = "",
    on_step = function(self, dtime)
        self.timer = self.timer + dtime
        local pos = self.object:get_pos()
        if not pos then self.object:remove() return end
        -- Set fire to nodes and remove 4 nodes in a square if hit ground
        local node = minetest.get_node(pos).name
        if node ~= "air" and node ~= "fire:basic_flame" then
            -- Remove 4 nodes in a 2x2 square centered on impact
            local base = vector.round(pos)
            for dx = 0,1 do
                for dz = 0,1 do
                    local rem_pos = {x=base.x+dx, y=base.y, z=base.z+dz}
                    local rem_node = minetest.get_node(rem_pos).name
                    if rem_node ~= "air" and rem_node ~= "ignore" and rem_node ~= "fire:basic_flame" then
                        minetest.remove_node(rem_pos)
                    end
                end
            end
            minetest.set_node(base, {name="fire:basic_flame"})
            self.object:remove()
            return
        end
        if self.timer > 3 then self.object:remove() end
    end,
    on_punch = function(self, hitter)
        -- Damage the hitter if not the owner
        if hitter and hitter:is_player() and hitter:get_player_name() ~= self.owner then
            hitter:set_hp(hitter:get_hp() - 4)
            self.object:remove()
        elseif hitter and hitter:get_luaentity() then
            hitter:punch(self.object, 1.0, {full_punch_interval=1.0, damage_groups={fleshy=4}}, nil)
            self.object:remove()
        end
    end,
    on_activate = function(self, staticdata, dtime_s)
        self.object:set_armor_groups({immortal = 1})
    end,
    on_collision = function(self, obj)
        -- Called when colliding with an object
        if obj and obj:is_player() and obj:get_player_name() ~= self.owner then
            obj:set_hp(obj:get_hp() - 4)
            self.object:remove()
        elseif obj and obj:get_luaentity() then
            obj:punch(self.object, 1.0, {full_punch_interval=1.0, damage_groups={fleshy=4}}, nil)
            self.object:remove()
        end
    end,
})

-- Register the wand
local wand = {
    name = "fire_wand",
    description = "Inferno's Embrace",
    wield_image = "mymagic_wand_red.png",
    on_use = powers.fireball,
    on_use_sneak = powers.toggle_stone_lava,
    on_secondary_use = powers.ring_of_fire_pointed_entity,
}

mymagic_wands.register(wand)
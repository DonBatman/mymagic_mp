-- light_wand.lua
local powers = {}

-- 1. MAGIC FLARE (Left Click)
-- Shoots a glowing entity that places a temporary light node on impact
core.register_node("mymagic_wands:light_orb", {
    description = "Magic Light",
    drawtype = "airlike",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    light_source = 14,
    groups = {not_in_creative_inventory = 1},
    on_construct = function(pos)
        core.get_node_timer(pos):start(30) -- Light lasts 30 seconds
    end,
    on_timer = function(pos)
        core.remove_node(pos)
    end,
})

core.register_entity("mymagic_wands:flare_entity", {
    initial_properties = {
        visual = "sprite",
        textures = {"default_glass.png^[colorize:#FFFFAA:200"},
        visual_size = {x=0.3, y=0.3},
        glow = 14,
    },
    on_step = function(self, dtime)
        local pos = self.object:get_pos()
        if core.get_node(pos).name ~= "air" then
            local p = vector.round(pos)
            if core.get_node(p).name == "air" then
                core.set_node(p, {name="mymagic_wands:light_orb"})
            end
            self.object:remove()
        end
    end,
})

powers.flare = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 10) then return itemstack end
    local pos = vector.add(user:get_pos(), {x=0, y=1.5, z=0})
    local flare = core.add_entity(pos, "mymagic_wands:flare_entity")
    if flare then
        flare:set_velocity(vector.multiply(user:get_look_dir(), 25))
    end
    return itemstack
end

-- 2. ILLUMINATED HEAL (Shift + Left Click)
powers.heal = function(itemstack, user, pointed_thing)
    local hp = user:get_hp()
    if hp >= 20 then return itemstack end
    if not mymagic_wands.use_mana(user, 40) then return itemstack end
    
    user:set_hp(math.min(20, hp + 4))
    core.add_particlespawner({
        amount = 20, time = 0.5,
        minpos = {x=-0.5, y=0, z=-0.5}, maxpos = {x=0.5, y=2, z=0.5},
        attached = user,
        texture = "default_glass.png^[colorize:#FFFFFF:200",
    })
    core.chat_send_player(user:get_player_name(), "§eLux Sanat!")
    return itemstack
end

-- 3. HOLY NOVA (Right Click)
powers.nova = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 30) then return itemstack end
    local pos = user:get_pos()
    local level = math.max(1, itemstack:get_meta():get_int("wand_level"))
    local radius = 5 + math.floor(level/10)

    core.add_particle({
        pos = pos,
        velocity = {x=0, y=0, z=0},
        expirationtime = 0.4,
        size = radius * 10,
        texture = "default_glass.png^[colorize:#FFFFFF:150",
    })

    for _, obj in ipairs(core.get_objects_inside_radius(pos, radius)) do
        if obj ~= user then
            local opos = obj:get_pos()
            local dir = vector.direction(pos, opos)
            obj:add_velocity({x=dir.x*15, y=3, z=dir.z*15})
        end
    end
    return itemstack
end

mymagic_wands.register({
    name = "light_wand",
    description = "Solari's Guidance",
    wield_image = "mymagic_wand_yellow.png",
    on_use = powers.flare,
    on_use_sneak = powers.heal,
    on_secondary_use = powers.nova,
})

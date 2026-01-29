
local powers = {}
local stealth_active = {}

core.register_entity("mymagic_wands:shadow_bolt", {
    initial_properties = {
        visual = "sprite",
        textures = {"wool_black.png"},
        visual_size = {x=0.4, y=0.4},
    },
    on_step = function(self, dtime)
        local pos = self.object:get_pos()
        for _, obj in ipairs(core.get_objects_inside_radius(pos, 1.5)) do
            if obj ~= self.owner_obj then
                obj:punch(self.owner_obj, 1.0, {full_punch_interval=1.0, damage_groups={fleshy=5}})
                self.object:remove()
                return
            end
        end
        if core.get_node(pos).name ~= "air" then self.object:remove() end
    end,
})

powers.bolt = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 12) then return itemstack end
    local pos = vector.add(user:get_pos(), {x=0, y=1.5, z=0})
    local ent = core.add_entity(pos, "mymagic_wands:shadow_bolt")
    if ent then
        ent:get_luaentity().owner_obj = user
        ent:set_velocity(vector.multiply(user:get_look_dir(), 18))
    end
    return itemstack
end

powers.stealth = function(itemstack, user, pointed_thing)
    local name = user:get_player_name()
    if not mymagic_wands.use_mana(user, 50) then return itemstack end

    user:set_properties({ visual_size = {x=0, y=0} })
    core.chat_send_player(name, "You vanish into the shadows...")
    
    core.after(10, function()
        local p = core.get_player_by_name(name)
        if p then
            p:set_properties({ visual_size = {x=1, y=1} })
            core.chat_send_player(name, "You are visible again.")
        end
    end)
    return itemstack
end

powers.snare = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 25) then return itemstack end
    local pos = vector.round(user:get_pos())
    
    core.add_particlespawner({
        amount = 50, time = 5,
        minpos = vector.subtract(pos, 3), maxpos = vector.add(pos, 3),
        texture = "wool_black.png",
        glow = 0,
    })

    core.after(0.1, function()
        for i=1, 50 do
            core.after(i*0.1, function()
                local objs = core.get_objects_inside_radius(pos, 4)
                for _, obj in ipairs(objs) do
                    if obj ~= user then
                        local v = obj:get_velocity()
                        obj:set_velocity({x=v.x*0.5, y=v.y, z=v.z*0.5})
                    end
                end
            end)
        end
    end)
    return itemstack
end

mymagic_wands.register({
    name = "shadow_wand",
    description = "Umbral Weaver",
    wield_image = "mymagic_wand_dark.png",
    on_use = powers.bolt,
    on_use_sneak = powers.stealth,
    on_secondary_use = powers.snare,
})

local powers = {}

powers.dig_tunnel = function(itemstack, user, pointed_thing)
    if pointed_thing.type ~= "node" then return itemstack end
    local level = math.max(1, itemstack:get_meta():get_int("wand_level"))
    if not mymagic_wands.use_mana(user, 30) then return itemstack end

    local start_pos = pointed_thing.under
    local dir = vector.normalize(user:get_look_dir())
    local length = 5 + math.floor(level / 2)

    for i = 0, length do
        local p = vector.round(vector.add(start_pos, vector.multiply(dir, i)))
        core.after(i * 0.1, function()
            for dy = 0, 1 do
                local np = {x=p.x, y=p.y+dy, z=p.z}
                if not core.is_protected(np, user:get_player_name()) then
                    local node = core.get_node(np)
                    if node.name ~= "air" and node.name ~= "ignore" then
                        local drops = core.get_node_drops(node.name, "")
                        for _, item in ipairs(drops) do
                            core.add_item(np, item)
                        end
                        core.remove_node(np)
                    end
                end
            end
        end)
    end
    return itemstack
end

powers.toggle_dirt = function(itemstack, user, pointed_thing)
    if pointed_thing.type ~= "node" then return itemstack end
    if not mymagic_wands.use_mana(user, 5) then return itemstack end
    local node = core.get_node(pointed_thing.under).name
    if node == "default:dirt" then
        core.set_node(pointed_thing.under, {name="default:dirt_with_grass"})
    elseif node == "default:dirt_with_grass" then
        core.set_node(pointed_thing.under, {name="default:dirt"})
    end
    return itemstack
end

powers.stone_wall = function(itemstack, user, pointed_thing)
    if not mymagic_wands.use_mana(user, 40) then return itemstack end
    
    local pos = vector.round(user:get_pos())
    local dir = user:get_look_dir()
    local level = math.max(1, itemstack:get_meta():get_int("wand_level"))
    
    local yaw = user:get_look_yaw()
    local wall_dir = {x = -math.sin(yaw), y = 0, z = math.cos(yaw)}
    
    local half_width = 1 + math.floor(level / 4)
    local height = 2 + math.floor(level / 10)
    
    local center = vector.add(pos, vector.multiply(vector.normalize({x=dir.x, y=0, z=dir.z}), 3))
    
    for w = -half_width, half_width do
        for h = 0, height do
            local wpos = vector.round({
                x = center.x + (wall_dir.x * w),
                y = center.y + h,
                z = center.z + (wall_dir.z * w)
            })
            
            if core.get_node(wpos).name == "air" and not core.is_protected(wpos, user:get_player_name()) then
                core.set_node(wpos, {name = "default:cobble"})
            end
        end
    end
    
    core.chat_send_player(user:get_player_name(), "Terra Murus!")
    return itemstack
end

mymagic_wands.register({
    name = "earth_wand",
    description = "Terra Shaper",
    wield_image = "mymagic_wand_orange.png",
    on_use = powers.dig_tunnel,
    on_use_sneak = powers.toggle_dirt,
    on_secondary_use = powers.stone_wall,
})

core.register_craft({
    output = "mymagic_wands:earth_wand",
    recipe = {
        {"default:glass", "default:diamond", "default:glass"},
        {"", "default:steel_ingot", ""},
        {"", "wool:orange", ""}, 
    }
})

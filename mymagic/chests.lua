local item1 = "mymagic:empty_bottle 2"
local item2 = "mymagic:orb_orange 1"
local item3 = "mymagic:orb_green 1"
local item4 = "mymagic:orb_blue 1"
local item5 = "mymagic:orb_red 1"

local item_spawn = function(pos, node)
    pos.y = pos.y - 0.3
    local objs = {
        core.spawn_item(pos, item1),
        core.spawn_item(pos, item2),
        core.spawn_item(pos, item3),
        core.spawn_item(pos, item4),
        core.spawn_item(pos, item5)
    }
    pos.y = pos.y + 0.3
    core.set_node(pos, {name="mymagic:chest_open_storage", param2=node.param2})
    core.set_node({x=pos.x, y=pos.y+1, z=pos.z}, {name="mymagic:chest_formspec", param2=node.param2})

    for _, object in pairs(objs) do
        if object then
            object:set_velocity({x=0, y=4.5, z=0})
        end
    end
end

local check_air = function(itemstack, placer, pointed_thing)
    local pos = pointed_thing.above
    local nodea = core.get_node({x=pos.x, y=pos.y+1, z=pos.z})

    if nodea.name ~= "air" then
        core.chat_send_player(placer:get_player_name(), "§cNeed room above chest!")
        return itemstack
    end
    return core.item_place(itemstack, placer, pointed_thing)
end

local dig_it = function(pos, node, digger)
    local meta = core.get_meta({x=pos.x, y=pos.y+1, z=pos.z})
    local inv = meta:get_inventory()
    local nodeu = core.get_node({x=pos.x, y=pos.y+1, z=pos.z})

    if nodeu.name == "mymagic:chest_formspec" and inv:is_empty("main") then
        core.remove_node({x=pos.x, y=pos.y+1, z=pos.z})
        core.remove_node(pos)
        core.spawn_item(pos, "mymagic:chest_storage")
    else
        core.chat_send_player(digger:get_player_name(), "§cChest is not empty!")
    end
end

local closed_box = {
    type = "fixed",
    fixed = {{-0.5, -0.5, -0.3125, 0.5, 0.3125, 0.375}}
}

local open_box = {
    type = "fixed",
    fixed = {
        {-0.5, -0.5, -0.3125, 0.5, -0.4375, 0.375},
        {-0.5, -0.5, 0.3125, 0.5, 0.1875, 0.375},
        {-0.5, -0.5, -0.3125, -0.4375, 0.1875, 0.375},
        {0.4375, -0.5, -0.3125, 0.5, 0.1875, 0.375},
        {-0.5, -0.5, -0.3125, 0.5, 0.1875, -0.25},
        {-0.5, 0.1875, 0.4375, 0.5, 0.875, 0.5},
        {-0.5, 0.1875, 0.375, 0.5, 0.25, 0.5},
        {-0.5, 0.8125, 0.375, 0.5, 0.875, 0.5},
        {-0.5, 0.1875, 0.375, -0.4375, 0.875, 0.5},
        {0.4375, 0.1875, 0.375, 0.5, 0.875, 0.5},
    }
}

local chest_formspec =
    "size[8,9]" ..
    "list[current_name;main;0,0.3;8,4;]" ..
    "list[current_player;main;0,4.85;8,1;]" ..
    "list[current_player;main;0,6.08;8,3;8]" ..
    "listring[current_name;main]" ..
    "listring[current_player;main]"

core.register_node("mymagic:chest", {
    description = "Magic Loot Chest",
    tiles = {
        "mymagic_chest_top.png", "mymagic_chest_top.png",
        "mymagic_chest_side.png^[transformFX", "mymagic_chest_side.png",
        "mymagic_chest_back.png", "mymagic_chest_front.png"
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2},
    node_box = closed_box,
    selection_box = closed_box,
    on_place = check_air,
    on_rightclick = item_spawn,
})

core.register_node("mymagic:chest_storage", {
    description = "Storage Chest",
    tiles = {
        "mymagic_chest_top.png", "mymagic_chest_top.png",
        "mymagic_chest_side.png^[transformFX", "mymagic_chest_side.png",
        "mymagic_chest_back.png", "mymagic_chest_front.png"
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2},
    node_box = closed_box,
    on_place = check_air,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        local node = core.get_node(pos)
        core.set_node({x=pos.x, y=pos.y+1, z=pos.z}, {name = "mymagic:chest_formspec", param2 = node.param2})
    end,
    on_dig = dig_it,
    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
        core.get_node_timer(pos):start(5)
        core.swap_node(pos, {name="mymagic:chest_open_storage", param2=node.param2})
    end,
})

core.register_node("mymagic:chest_open_storage", {
    tiles = {
        "mymagic_chest_open_top.png", "mymagic_chest_open_top.png",
        "mymagic_chest_side.png^[transformFx", "mymagic_chest_side.png",
        "mymagic_chest_back.png", "mymagic_chest_front_open.png"
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    drop = "mymagic:chest_storage",
    groups = {choppy = 2, not_in_creative_inventory=1},
    node_box = open_box,
    selection_box = open_box,
    on_dig = dig_it,
    on_rightclick = function(pos, node)
        core.swap_node(pos, {name="mymagic:chest_storage", param2=node.param2})
    end,
    on_timer = function(pos, elapsed)
        local node = core.get_node(pos)
        core.swap_node(pos, {name = "mymagic:chest_storage", param2=node.param2})
    end,
})

core.register_node("mymagic:chest_formspec", {
    drawtype = "airlike",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2, not_in_creative_inventory=1},
    on_construct = function(pos)
        local meta = core.get_meta(pos)
        meta:set_string("formspec", chest_formspec)
        meta:set_string("infotext", "Chest")
        meta:get_inventory():set_size("main", 8*4)
    end,
    on_dig = function(pos, node, digger)
        local inv = core.get_meta(pos):get_inventory()
        if inv:is_empty("main") then
            local below = {x=pos.x, y=pos.y-1, z=pos.z}
            core.remove_node(below)
            core.remove_node(pos)
            core.spawn_item(pos, "mymagic:chest_storage")
        end
    end,
})

core.register_node("mymagic:chest_wands_closed", {
    description = "Ancient Wand Cache",
    tiles = {
        "mymagic_chest_top.png", "mymagic_chest_top.png",
        "mymagic_chest_side.png^[transformFX", "mymagic_chest_side.png",
        "mymagic_chest_back.png", "mymagic_chest_front.png"
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {unbreakable=1},
    node_box = closed_box,
    on_rightclick = function(pos, node, player)
        local rand = math.random(4)
        core.get_node_timer(pos):start(30)
        core.swap_node(pos, {name = "mymagic:chest_wands_open", param2=node.param2})
        
        local wands = {
            "mymagic_wands:water_wand",
            "mymagic_wands:earth_wand",
            "mymagic_wands:air_wand",
            "mymagic_wands:fire_wand"
        }
        core.spawn_item(pos, wands[rand])
    end,
})

core.register_node("mymagic:chest_wands_open", {
    tiles = {
        "mymagic_chest_open_top.png", "mymagic_chest_open_top.png",
        "mymagic_chest_side.png^[transformFx", "mymagic_chest_side.png",
        "mymagic_chest_back.png", "mymagic_chest_front_open.png"
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {unbreakable=1, not_in_creative_inventory=1},
    node_box = open_box,
    on_timer = function(pos, elapsed)
        local node = core.get_node(pos)
        core.swap_node(pos, {name = "mymagic:chest_wands_closed", param2=node.param2})
    end,
})

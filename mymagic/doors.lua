-- Compatibility for Lua versions
local unpack = table.unpack or unpack

-- Nodebox definitions
local door_bottom_box_closed = {
    type = "fixed",
    fixed = {
        {-0.5, -0.5, -0.5, -0.25, 0.5, 0.5},
        {-0.5, -0.5, -0.1875, 0.5, 0.5, 0.1875},
    },
}
local door_bottom_box_open = {
    type = "fixed",
    fixed = {
        {-0.5, -0.5, -0.5, -0.25, 0.5, 0.5},
        {-0.5, -0.5, -0.1875, 0, 0.5, 0.1875},
    },
}
local door_top_box_closed = {
    type = "fixed",
    fixed = {
        {-0.5, -0.5, -0.5, -0.25, 0.5, 0.5},
        {-0.5, -0.5, -0.1875, 0.5, 0.5, 0.1875},
        {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
        {-0.5, 0.375, -0.5, 0.1875, 0.5, 0.5},
        {-0.5, 0.3125, -0.5, 0.0625, 0.5, 0.5},
        {-0.5, 0, -0.5, -0.1875, 0.5, 0.5},
        {-0.5, 0.125, -0.5, -0.125, 0.5, 0.5},
        {-0.5, 0.1875, -0.5, -0.0625, 0.5, 0.5},
        {-0.5, 0.25, -0.5, 0, 0.5, 0.5},
    },
}
local door_top_box_open = {
    type = "fixed",
    fixed = {
        {-0.5, -0.5, -0.5, -0.25, 0.5, 0.5},
        {-0.5, -0.5, -0.1875, 0, 0.5, 0.1875},
        {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
        {-0.5, 0.375, -0.5, 0.1875, 0.5, 0.5},
        {-0.5, 0.3125, -0.5, 0.0625, 0.5, 0.5},
        {-0.5, 0, -0.5, -0.1875, 0.5, 0.5},
        {-0.5, 0.125, -0.5, -0.125, 0.5, 0.5},
        {-0.5, 0.1875, -0.5, -0.0625, 0.5, 0.5},
        {-0.5, 0.25, -0.5, 0, 0.5, 0.5},
    },
}
local door_box = {
    type = "fixed",
    fixed = {
        {-0.5, -0.5, -0.1875, 1.5, 1.5, 0.1875},
    },
}
local nobox = {
    type = "fixed",
    fixed = {
        {0, 0, 0, 0, 0, 0},
    },
}

-- Helpers and mappings
local directions = {
    [0] = {x = 1, y = 0, z = 0},
    [1] = {x = 0, y = 0, z = -1},
    [2] = {x = -1, y = 0, z = 0},
    [3] = {x = 0, y = 0, z = 1},
}
local function opp(d)
    return (d + 2) % 4
end

local toggle_open = {
    ["mymagic:door_dungeon"]       = "mymagic:door_bottom_open2",
    ["mymagic:door_bottom_closed"] = "mymagic:door_bottom_open",
    ["mymagic:door_top_closed"]    = "mymagic:door_top_open",
}
local toggle_close = {
    ["mymagic:door_bottom_open2"] = "mymagic:door_dungeon",
    ["mymagic:door_bottom_open"]  = "mymagic:door_bottom_closed",
    ["mymagic:door_top_open"]     = "mymagic:door_top_closed",
}
local valid_orbs = {
    ["mymagic:orb_orange"] = true,
    ["mymagic:orb_green"]  = true,
    ["mymagic:orb_blue"]   = true,
    ["mymagic:orb_red"]    = true,
}

-- Register door nodes (data: {id, description, creative_flag, tiles, node_box, selection_box})
local door_nodes = {
    {"dungeon",       "Magic Door", 0, {"default_stone_brick.png"}, door_bottom_box_closed, door_box},
    {"bottom_closed", "a",          1, {"default_stone_brick.png"}, door_bottom_box_closed, nobox},
    {"bottom_open",   "a",          1, {"default_stone_brick.png"}, door_bottom_box_open,   nobox},
    {"bottom_open2",  "a",          1, {"default_stone_brick.png"}, door_bottom_box_open,   door_box},
    {"top_closed",    "a",          1, {"default_stone_brick.png"}, door_top_box_closed,    nobox},
    {"top_open",      "a",          1, {"default_stone_brick.png"}, door_top_box_open,      nobox},
}
for _, d in ipairs(door_nodes) do
    local id, desc, nc, tiles, nbox, sbox = unpack(d)
    core.register_node("mymagic:door_" .. id, {
        description = desc,
        tiles = tiles,
        drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
        groups = { unbreakable = 1, not_in_creative_inventory = 1 },
        node_box = nbox,
        selection_box = sbox,
    })
end

-- Helper: checks if a given position is empty or buildable_to.
local function can_place(pos)
    local name = core.get_node(pos).name
    if name == "air" then return true end
    local def = core.registered_nodes[name]
    return def and def.buildable_to
end

-- Main door placement with floor support check.
core.override_item("mymagic:door_dungeon", {
    on_place = function(stack, placer, pointed)
        local d = core.dir_to_facedir(placer:get_look_dir())
        local pos = pointed.above
        local off = directions[d] or {x = 0, y = 0, z = 0}

        -- Positions for lower door parts and their respective upper nodes.
        local pos_main = pos
        local pos_adj = { x = pos.x + off.x, y = pos.y, z = pos.z + off.z }
        local pos_main_up = { x = pos_main.x, y = pos_main.y + 1, z = pos_main.z }
        local pos_adj_up = { x = pos_adj.x, y = pos_adj.y + 1, z = pos_adj.z }

        -- Floor support: ensure both lower positions have a block beneath.
        local floor_main = { x = pos_main.x, y = pos_main.y - 1, z = pos_main.z }
        local floor_adj = { x = pos_adj.x, y = pos_adj.y - 1, z = pos_adj.z }
        if core.get_node(floor_main).name == "air" or core.get_node(floor_adj).name == "air" then
            return stack
        end

        -- Check that all four positions are available.
        if not (can_place(pos_main) and can_place(pos_main_up)
            and can_place(pos_adj) and can_place(pos_adj_up)) then
            return stack
        end

        local od = opp(d)
        core.set_node(pos_main, { name = "mymagic:door_dungeon", param2 = d })
        core.set_node(pos_adj, { name = "mymagic:door_bottom_closed", param2 = od })
        core.set_node(pos_main_up, { name = "mymagic:door_top_closed", param2 = d })
        core.set_node(pos_adj_up, { name = "mymagic:door_top_closed", param2 = od })
        return stack
    end,

    -- Activate door on right-click when holding an orb.
    on_rightclick = function(pos, node, clicker, itemstack, pointed)
        if valid_orbs[clicker:get_wielded_item():get_name()] then
            -- Remove one orb from the player's hand
            itemstack:take_item(1)
            clicker:set_wielded_item(itemstack)

            for _, p in ipairs(core.find_nodes_in_area(
                { x = pos.x - 1, y = pos.y,   z = pos.z - 1 },
                { x = pos.x + 1, y = pos.y + 1, z = pos.z + 1 },
                {"mymagic:door_dungeon", "mymagic:door_bottom_closed", "mymagic:door_top_closed"}
            )) do
                local cn = core.get_node(p)
                if toggle_open[cn.name] then
                    core.swap_node(p, { name = toggle_open[cn.name], param2 = cn.param2 })
                end
            end
            core.get_node_timer(pos):start(3)
        else
            core.chat_send_player(clicker:get_player_name(), "You need to hold an orb to open!")
        end
    end,

    after_destruct = function(pos, oldnode)
        local d = oldnode.param2
        if d then
            local off = directions[d]
            local parts = {
                pos,
                { x = pos.x,       y = pos.y + 1, z = pos.z },
                { x = pos.x + off.x, y = pos.y,   z = pos.z + off.z },
                { x = pos.x + off.x, y = pos.y + 1, z = pos.z + off.z },
            }
            for _, p in ipairs(parts) do
                if core.get_node(p).name ~= "air" then
                    core.remove_node(p)
                end
            end
        end
    end,
})

-- Override for the open state door to revert after a timer.
core.override_item("mymagic:door_bottom_open2", {
    on_timer = function(pos)
        for _, p in ipairs(core.find_nodes_in_area(
            { x = pos.x - 1, y = pos.y,   z = pos.z - 1 },
            { x = pos.x + 1, y = pos.y + 1, z = pos.z + 1 },
            {"mymagic:door_bottom_open2", "mymagic:door_bottom_open", "mymagic:door_top_open"}
        )) do
            local cn = core.get_node(p)
            if toggle_close[cn.name] then
                core.swap_node(p, { name = toggle_close[cn.name], param2 = cn.param2 })
            end
        end
    end,

    after_destruct = function(pos, oldnode)
        for _, p in ipairs(core.find_nodes_in_area(
            { x = pos.x - 1, y = pos.y,   z = pos.z - 1 },
            { x = pos.x + 1, y = pos.y + 1, z = pos.z + 1 },
            {"mymagic:door_open2", "mymagic:door_bottom_open", "mymagic:door_top_open"}
        )) do
            core.remove_node(p)
        end
    end,
})

-- Helper: Remove the entire door if any part is broken.
local function remove_door(pos, oldnode)
    local main_pos, d
    if oldnode.name == "mymagic:door_dungeon" or oldnode.name == "mymagic:door_bottom_open2" then
        main_pos = pos
        d = oldnode.param2
    elseif oldnode.name == "mymagic:door_bottom_closed" or oldnode.name == "mymagic:door_bottom_open" then
        d = opp(oldnode.param2)
        main_pos = { x = pos.x - directions[d].x, y = pos.y, z = pos.z - directions[d].z }
    elseif oldnode.name == "mymagic:door_top_closed" or oldnode.name == "mymagic:door_top_open" then
        local below = { x = pos.x, y = pos.y - 1, z = pos.z }
        local bn = core.get_node(below)
        if bn and bn.name == "mymagic:door_dungeon" then
            main_pos = below
            d = bn.param2
        else
            d = opp(oldnode.param2)
            main_pos = { x = pos.x - directions[d].x, y = pos.y - 1, z = pos.z - directions[d].z }
        end
    else
        return
    end
    if not main_pos or not d then return end
    local off = directions[d]
    local parts = {
        main_pos,
        { x = main_pos.x,       y = main_pos.y + 1, z = main_pos.z },
        { x = main_pos.x + off.x, y = main_pos.y,   z = main_pos.z + off.z },
        { x = main_pos.x + off.x, y = main_pos.y + 1, z = main_pos.z + off.z },
    }
    for _, p in ipairs(parts) do
        if core.get_node(p).name ~= "air" then
            core.remove_node(p)
        end
    end
end

-- Apply the common removal function to all door parts.
local door_list = {
    "mymagic:door_dungeon",
    "mymagic:door_bottom_closed",
    "mymagic:door_top_closed",
    "mymagic:door_bottom_open",
    "mymagic:door_bottom_open2",
    "mymagic:door_top_open",
}
for _, name in ipairs(door_list) do
    core.override_item(name, {
        after_destruct = function(pos, oldnode)
            remove_door(pos, oldnode)
        end,
    })
end

-- Craft recipe registration
core.register_craft({
    output = "mymagic:door_dungeon",
    recipe = {
        {"default:stonebrick", "default:stonebrick", "default:stonebrick"},
        {"default:stonebrick", "mymagic:orb_orange",  "default:stonebrick"},
        {"default:stonebrick", "default:stonebrick", "default:stonebrick"},
    },
})

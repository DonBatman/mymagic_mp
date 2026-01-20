local blocks = {
    {"Orange", "orange", "sword", {magic_sword = 4}},
    {"Green",  "green",  "sword", {magic_sword = 3}},
    {"Blue",   "blue",   "sword", {magic_sword = 2}},
    {"Red",    "red",    "sword", {magic_sword = 1}},
    {"Orange", "orange", "axe",   {magic_axe = 4}},
    {"Green",  "green",  "axe",   {magic_axe = 3}},
    {"Blue",   "blue",   "axe",   {magic_axe = 2}},
    {"Red",    "red",    "axe",   {magic_axe = 1}},
}

for i in ipairs(blocks) do
    local des  = blocks[i][1]
    local col  = blocks[i][2]
    local tool = blocks[i][3]
    local mag  = blocks[i][4]

    core.register_node("mymagic:block_" .. col .. "_" .. tool, {
        description = des .. " Magic block - " .. tool,
        tiles = {"mymagic_block_" .. tool .. "_" .. col .. ".png"},
        paramtype = "light",
        drop = "",
        light_source = 12,
        groups = mag,
        on_punch = function(pos, node, puncher, pointed_thing)
            if puncher then
                core.chat_send_player(puncher:get_player_name(), 
                    "§cYou need an enchanted " .. col .. " " .. tool .. " to break this block!")
            end
        end,
    })
end

local function parti(pos)
    core.add_particlespawner({
        amount = 40,
        time = 1,
        minpos = pos,
        maxpos = pos,
        minvel = {x=-5, y=-5, z=-5},
        maxvel = {x=5, y=5, z=5},
        minacc = {x=-2, y=-2, z=-2},
        maxacc = {x=2, y=2, z=2},
        minexptime = 0.2,
        maxexptime = 2,
        minsize = 0.2,
        maxsize = 3,
        collisiondetection = false,
        texture = "mymagic_magic_parti.png",
    })
end

local tool_items = {
    {"default:sword_diamond", "sword", "Sword Block"},
    {"default:pick_diamond",  "pick",  "Pick Block"},
    {"default:axe_diamond",   "axe",   "Axe Block"},
}

for i in ipairs(tool_items) do
    local itm = tool_items[i][1]
    local nam = tool_items[i][2]
    local des = tool_items[i][3]

    core.register_node("mymagic:" .. nam .. "_block", {
        description = des,
        tiles = {"mymagic_block_" .. nam .. ".png"},
        drawtype = "nodebox",
        paramtype = "light",
        drop = "",
        groups = {magic_sword = 1, cracky = 3},
        node_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, 0.3125, -0.3125, 0.5, 0.5},
                {-0.5, -0.5, -0.5, -0.3125, 0.5, -0.3125},
                {0.3125, -0.5, -0.5, 0.5, 0.5, -0.3125},
                {0.3125, -0.5, 0.3125, 0.5, 0.5, 0.5},
                {0.3125, -0.5, -0.3125, 0.5, -0.3125, 0.3125},
                {-0.5, -0.5, -0.3125, -0.3125, -0.3125, 0.3125},
                {-0.5, 0.3125, -0.3125, -0.3125, 0.5, 0.3125},
                {0.3125, 0.3125, -0.3125, 0.5, 0.5, 0.3125},
                {-0.3125, 0.3125, 0.3125, 0.3125, 0.5, 0.5},
                {-0.3125, 0.3125, -0.5, 0.3125, 0.5, -0.3125},
                {-0.3125, -0.5, -0.5, 0.3125, -0.3125, -0.3125},
                {-0.3125, -0.5, 0.3125, 0.3125, -0.3125, 0.5},
                {-0.3125, -0.3125, -0.3125, 0.3125, 0.3125, 0.3125},
            }
        },
        on_destruct = function(pos)
            core.spawn_item(pos, itm)
            parti(pos)
        end,
    })
end

local energy_colors = {
    {"red",    { r=255, g=0,   b=0,   a=200 }},
    {"green",  { r=0,   g=255, b=0,   a=200 }},
    {"blue",   { r=0,   g=150, b=180, a=200 }},
    {"orange", { r=200, g=150, b=0,   a=200 }}
}

for i in ipairs(energy_colors) do
    local col = energy_colors[i][1]
    local rgb = energy_colors[i][2]
    local scol = 0
    if col == "red" then scol = 1
    elseif col == "blue" then scol = 2
    elseif col == "green" then scol = 3
    elseif col == "orange" then scol = 4
    end

    core.register_node("mymagic:colored_energy_" .. col, {
        description = col:gsub("^%l", string.upper) .. " Energy Block",
        tiles = {{name="mymagic_teleport_ani_" .. col .. ".png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.5}}},
        paramtype = "light",
        drawtype = "glasslike",
        post_effect_color = rgb,
        drop = "",
        light_source = 14,
        walkable = false,
        groups = {cracky = 1, magic_shovel = scol},
    })

    core.register_craft({
        type = "shapeless",
        output = "mymagic:colored_energy_" .. col,
        recipe = {
            "mymagic:orb_" .. col, "mymagic:orb_" .. col,
            "mymagic:orb_" .. col, "mymagic:orb_" .. col,
        },
    })
end

core.register_node("mymagic:hole1", {
    description = "FakeTeleport Block Type 1",
    tiles = { "mymagic_hole_in_floor.png", "mymagic_floor.png", "mymagic_floor.png", "mymagic_floor.png", "mymagic_floor.png", "mymagic_floor.png" },
    paramtype = "light",
    drop = "",
    groups = {magic_shovel = 1, not_in_creative_inventory = 1},
})

core.register_node("mymagic:hole2", {
    description = "FakeTeleport Block Type 2",
    tiles = { "mymagic_hole_in_floor.png", "mymagic_floor.png", "mymagic_floor.png", "mymagic_floor.png", "mymagic_floor.png", "mymagic_floor.png" },
    paramtype = "light",
    drop = "",
    groups = {magic_shovel = 1, not_in_creative_inventory = 1},
})

core.register_node("mymagic:stone_floor", {
    description = "Stone Floor",
    tiles = { "mymagic_floor.png" },
    paramtype = "light",
    groups = {cracky = 1},
})

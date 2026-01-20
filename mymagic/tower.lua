local blocks = {
    {"cobble",              "Cobble",             {cracky=1}},
    {"desert_cobble",       "Desert Cobble",      {cracky=1}},
    {"stone_brick",         "Stone Brick",        {cracky=1}},
    {"desert_stone_brick",  "Desert Stone Brick", {cracky=1}},
    {"stone",               "Stone",              {cracky=1}},
    {"desert_stone",        "Desert Stone",       {cracky=1}},
}

for _, b in ipairs(blocks) do
    local itm = b[1]
    local des = b[2]

    core.register_node("mymagic:tower_dark_" .. itm, {
        description = "Tower Dark " .. des,
        tiles = {"mymagic_dark_" .. itm .. ".png"},
        drawtype = "normal",
        paramtype = "light",
        groups = {unbreakable = 1, not_in_creative_inventory = 1},
    })
end

core.register_node("mymagic:glass", {
    description = "Magic Tower Glass",
    drawtype = "glasslike",
    tiles = {"mymagic_glass.png"},
    paramtype = "light",
    sunlight_propagates = true,
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    sounds = default.node_sound_glass_defaults(),
})

core.register_node("mymagic:ladder", {
    description = "Tower Ladder",
    drawtype = "mesh",
    mesh = "mymagic_ladder.obj",
    tiles = {"mymagic_ladder.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    climbable = true,
    walkable = false,
    sunlight_propagates = true,
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    selection_box = { type = "fixed", fixed = {{-0.375, -0.5, 0.375, 0.375, 0.5, 0.5}} },
    collision_box = { type = "fixed", fixed = {{-0.375, -0.5, 0.375, 0.375, 0.5, 0.5}} },
})

core.register_node("mymagic:tower_colored_energy_red", {
    description = "Tower Energy Block",
    tiles = {{
        name="mymagic_teleport_ani_red.png", 
        animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.5}
    }},
    paramtype = "light",
    drawtype = "glasslike",
    light_source = 14,
    walkable = false,
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
})

core.register_node("mymagic:tower_stone_floor", {
    description = "Stone Floor",
    tiles = {"mymagic_floor.png"},
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
})

core.register_node("mymagic:stone_floor_fall", {
    description = "Stone Floor (Trap)",
    tiles = {"mymagic_floor.png"},
    walkable = false,
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
})

core.register_node("mymagic:towernode", {
    description = "Tower Spawner",
    tiles = {"default_cobble.png^default_snowball.png"},
    groups = {not_in_creative_inventory = 1},
})

core.register_abm({
    nodenames = {"mymagic:towernode"},
    interval = 1.0,
    chance = 1,
    action = function(pos, node)
        local schem = core.get_modpath("mymagic") .. "/schems/tower.mts"
        core.place_schematic(pos, schem, "0", nil, true)
        core.log("action", "[mymagic] Tower spawned at " .. core.pos_to_string(pos))
    end,
})

local spawn_surfaces = {
    "default:dirt_with_grass", "default:dirt_with_snow", "default:sand", 
    "default:desert_sand", "default:silver_sand", "default:permafrost_with_stones",
    "default:dirt_with_coniferous_litter", "default:dirt_with_rainforest_litter",
    "default:dry_dirt_with_dry_grass"
}

for _, surface in ipairs(spawn_surfaces) do
    core.register_ore({
        ore_type       = "scatter",
        ore            = "mymagic:towernode",
        wherein        = surface,
        clust_scarcity = 60 * 60 * 60,
        clust_num_ores = 1,
        clust_size     = 1,
        y_min          = 2,
        y_max          = 100,
    })
end

core.register_node("mymagic:alter", {
    description = "Ritual Altar",
    drawtype = "nodebox",
    tiles = {"mymagic_wood.png^[transformR90", "mymagic_wood.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, 0.375, -0.375, 0.5, 0.5, 0.375},
            {-0.4375, -0.5, -0.3125, -0.3125, 0.5, 0.3125},
            {0.3125, -0.5, -0.3125, 0.4375, 0.5, 0.3125},
            {-0.4375, -0.1875, -0.0625, 0.4375, 0.125, 0.0625},
        }
    },
})

core.register_node("mymagic:candle", {
    description = "Tower Candle",
    drawtype = "nodebox",
    tiles = {
        {name="mymagic_candle_top.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.3}},
        "mymagic_candle_bottom.png",
        {name="mymagic_candle_side.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.3}},
        {name="mymagic_candle_side.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.3}},
        {name="mymagic_candle_side.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.3}},
        {name="mymagic_candle_side.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.3}},
    },
    paramtype = "light",
    paramtype2 = "facedir",
    light_source = 9,
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.0625, -0.5, -0.0625, 0.0625, 0, 0.0625},
            {-0.0625, 0.0625, -0.0625, 0.0625, 0.25, 0.0625},
            {0, 0.1875, -0.0625, 0.0625, 0.3125, 0},
            {0, 0, 0, 0.0625, 0.0625, 0.0625},
            {-0.25, -0.5, -0.125, 0.25, -0.4375, 0.125},
            {-0.1875, -0.5, -0.1875, 0.1875, -0.4375, 0.1875},
            {-0.125, -0.5, -0.25, 0.125, -0.4375, 0.25},
        }
    },
})

core.register_node("mymagic:banner_top", {
    description = "Tower Banner (Top)",
    drawtype = "nodebox",
    tiles = {"mymagic_banner.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    node_box = { type = "fixed", fixed = {{-0.3125, -0.5, 0.4375, 0.3125, 0.5, 0.5}} },
})

core.register_node("mymagic:banner_bottom", {
    description = "Tower Banner (Bottom)",
    drawtype = "nodebox",
    tiles = {"mymagic_banner.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.3125, -0.5, 0.4375, -0.25, 0.5, 0.5},
            {0.25, -0.5, 0.4375, 0.3125, 0.5, 0.5},
            {-0.25, -0.375, 0.4375, -0.1875, 0.5, 0.5},
            {0.1875, -0.375, 0.4375, 0.25, 0.5, 0.5},
            {0.125, -0.25, 0.4375, 0.1875, 0.5, 0.5},
            {-0.1875, -0.25, 0.4375, -0.125, 0.5, 0.5},
            {-0.125, -0.125, 0.4375, -0.0625, 0.5, 0.5},
            {0.0625, -0.125, 0.4375, 0.125, 0.5, 0.5},
            {-0.0625, 0, 0.4375, 0.0625, 0.5, 0.5},
        }
    },
})

core.register_node("mymagic:tower_window_sil", {
    description = "Tower Window Sill",
    tiles = {"mymagic_grey.png"},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    node_box = { type = "fixed", fixed = {{-0.5, -0.5, 0.1875, 0.5, -0.25, 0.5}} },
    on_place = core.rotate_node,
})

core.register_node("mymagic:tower_dinning_table", {
    description = "Tower Dining Table",
    tiles = {"mymagic_wood.png"},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, 0.375, -0.5, 0.5, 0.5, 0.5},
            {-0.5, -0.5, 0.375, -0.375, 0.375, 0.5},
            {0.375, -0.5, -0.5, 0.5, 0.5, -0.375},
            {0.375, -0.5, 0.375, 0.5, 0.5, 0.5},
            {-0.5, -0.5, -0.5, -0.375, 0.5, -0.375},
        }
    },
})

core.register_node("mymagic:tower_chair", {
    description = "Tower Chair",
    tiles = {"mymagic_wood.png"},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {unbreakable = 1, not_in_creative_inventory = 1},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.375, -0.125, -0.375, 0.375, 0, 0.375},
            {-0.375, -0.5, 0.25, -0.25, 0.5, 0.375},
            {0.25, -0.5, -0.375, 0.375, -0.125, -0.25},
            {0.25, -0.5, 0.25, 0.375, 0.5, 0.375},
            {-0.375, -0.5, -0.375, -0.25, -0.125, -0.25},
            {-0.375, 0.375, 0.25, 0.375, 0.5, 0.375},
        }
    },
})

core.register_node("mymagic:stairs", {
	description = "Stairs",
	drawtype = "nodebox",
	tiles = {
			"mymagic_wood.png^[transformR90",
			"mymagic_wood.png",
			"mymagic_wood.png",
			"mymagic_wood.png",
			"mymagic_wood.png",
			"mymagic_wood.png",
			},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = {unbreakable=1,not_in_creative_inventory=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.375, -0.5, 0.5, -0.3125, -0.1875},
			{-0.5, -0.125, -0.1875, 0.5, -0.0625, 0.125},
			{-0.5, 0.125, 0.125, 0.5, 0.1875, 0.5},
			{-0.375, -0.5, 0.1875, -0.3125, 0.1875, 0.4375},
			{0.3125, -0.5, 0.1875, 0.375, 0.1875, 0.4375},
			{0.3125, -0.5, -0.125, 0.375, -0.0625, 0.1875},
			{-0.375, -0.5, -0.125, -0.3125, -0.0625, 0.1875},
			{-0.375, -0.5, -0.4375, -0.3125, -0.375, -0.125},
			{0.3125, -0.5, -0.4375, 0.375, -0.375, -0.125},
		}
	},

})

core.register_node("mymagic:stand", {
	description = "Stand",
	drawtype = "nodebox",
	tiles = {
			"mymagic_wood.png",
			},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = {unbreakable=1,not_in_creative_inventory=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, 0.375, -0.375, 0.25, 0.5, 0.375},
			{-0.3125, 0.375, -0.3125, 0.3125, 0.5, 0.3125},
			{-0.375, 0.375, -0.25, 0.375, 0.5, 0.25},
			{-0.0625, -0.5, -0.0625, 0.0625, 0.375, 0.0625},
			{-0.0625, -0.5, -0.375, 0.0625, -0.375, 0.375},
			{-0.375, -0.5, -0.0625, 0.375, -0.375, 0.0625},
		}
	},

})

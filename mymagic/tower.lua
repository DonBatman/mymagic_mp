local blocks = {
	{"pick","cobble","Cobble",{unbreakable=1,not_in_creative_inventory=1}},
	{"pick","desert_cobble","Desert Cobble",{unbreakable=1,not_in_creative_inventory=1}},
	{"pick","stone_brick","Stone Brick",{unbreakable=1,not_in_creative_inventory=1}},
	{"pick","desert_stone_brick","Desert Stone Brick",{unbreakable=1,not_in_creative_inventory=1}},
	{"pick","stone","Stone Brick",{unbreakable=1,not_in_creative_inventory=1}},
	{"pick","desert_stone","Desert Stone Brick",{unbreakable=1,not_in_creative_inventory=1}},
	
	}
for i in ipairs(blocks) do
	local tl = blocks[i][1]
	local itm = blocks[i][2]
	local des = blocks[i][3]
	local gro = blocks[i][4]

minetest.register_node("mymagic:tower_dark_"..itm,{
	description = "Tower Dark "..des,
	tiles = {"mymagic_dark_"..itm..".png"},
	drawtype = "normal",
	paramtype = "light",
	groups = gro,
})
end

minetest.register_abm({
	nodenames = {"mymagic:towernode"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local schem = minetest.get_modpath("mymagic").."/schems/tower.mts"
		minetest.place_schematic(pos,schem,0, "air", true)
	end,
})

minetest.register_node("mymagic:towernode",{
	description = "Tower",
	tiles = {"default_cobble.png^default_snowball.png"},
	drawtype = "normal",
	paramtype = "light",
	groups = {not_in_creative_inventory=1},
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:dirt_with_grass",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:dirt_with_snow",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:permafrost_with_stones",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:permafrost_with_moss",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:sand",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:desert_sand",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:dirt_with_coniferous_litter",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:dirt_with_rainforest_litter",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:dry_dirt_with_dry_grass",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:towernode",
	wherein        = "default:silver_sand",
	clust_scarcity = 60*60*60,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -1,
	y_max     = 100,
})

minetest.register_node("mymagic:glass", {
	description = "Glass",
	drawtype = "glasslike",
	tiles = {"mymagic_glass.png"},
	paramtype = "light",
	sunlight_propagates = true,
	groups = {unbreakable=1,not_in_creative_inventory=1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("mymagic:ladder", {
	description = "Ladder",
	drawtype = "mesh",
	mesh = "mymagic_ladder.obj",
	tiles = {"mymagic_ladder.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	climbable = true,
	walkable = false,
	sunlight_propagates = true,
	groups = {unbreakable=1,not_in_creative_inventory=1},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, 0.375, 0.375, 0.5, 0.5},
			}
		},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, 0.375, 0.375, 0.5, 0.5},
			}
		},
})

minetest.register_node("mymagic:alter", {
	description = "Alter",
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
			{-0.5, 0.375, -0.375, 0.5, 0.5, 0.375},
			{-0.4375, -0.5, -0.3125, -0.3125, 0.5, 0.3125},
			{0.3125, -0.5, -0.3125, 0.4375, 0.5, 0.3125},
			{-0.4375, -0.1875, -0.0625, 0.4375, 0.125, 0.0625},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.375, 0.5, 0.5, 0.375},
			}
		},
})

minetest.register_node("mymagic:stairs", {
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

minetest.register_node("mymagic:banner_top", {
	description = "Banner Top",
	drawtype = "nodebox",
	tiles = {
			"mymagic_banner.png"
			},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = {unbreakable=1,not_in_creative_inventory=1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.3125, -0.5, 0.4375, 0.3125, 0.5, 0.5},
		}
	},

})

minetest.register_node("mymagic:banner_bottom", {
	description = "Banner Bottom",
	drawtype = "nodebox",
	tiles = {
			"mymagic_banner.png",
			},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = {unbreakable=1,not_in_creative_inventory=1},
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

minetest.register_node("mymagic:stand", {
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

minetest.register_node("mymagic:candle", {
	description = "Candle",
	drawtype = "nodebox",
	tiles = {
		{name="mymagic_candle_top.png", animation={type="vertical_frames",
		aspect_w=16, aspect_h=16, length=0.3}},
		"mymagic_candle_bottom.png",
		{name="mymagic_candle_side.png", animation={type="vertical_frames",
		aspect_w=16, aspect_h=16, length=0.3}},
		{name="mymagic_candle_side.png", animation={type="vertical_frames",
		aspect_w=16, aspect_h=16, length=0.3}},
		{name="mymagic_candle_side.png", animation={type="vertical_frames",
		aspect_w=16, aspect_h=16, length=0.3}},
		{name="mymagic_candle_side.png", animation={type="vertical_frames",
		aspect_w=16, aspect_h=16, length=0.3}},
	},
	paramtype = "light",
	paramtype2 = "facedir",
	light_source = 9,
	sunlight_propagates = true,
	groups = {unbreakable=1,not_in_creative_inventory=1},
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

minetest.register_node("mymagic:tower_colored_energy_red",{
	description = "Tower Energy Block",
	tiles = {{name="mymagic_teleport_ani_red.png", animation={type="vertical_frames",aspect_w=16, aspect_h=16, length=0.5}}},
	paramtype = "light",
	drawtype = "glasslike",
	post_effect_color = rgb,
	drop = "",
	light_source = 14,
	walkable = false,
	groups = {unbreakable=1,not_in_creative_inventory=1},

})

minetest.register_node("mymagic:tower_stone_floor",{
	description = "Stone Floor",
	tiles = {
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			},
	paramtype = "light",
	drop = "",
	groups = {unbreakable=1, not_in_creative_inventory = 1},
})

minetest.register_node("mymagic:stone_floor_fall",{
	description = "Stone Floor",
	tiles = {
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			},
	paramtype = "light",
	drop = "",
	walkable = false,
	groups = {unbreakable=1,not_in_creative_inventory=1},
})


--Table
core.register_node("mymagic:tower_dinning_table", {
	description = "Tower Dinning Table",
	tiles = {"mymagic_wood.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {unbreakable=1, not_in_creative_inventory = 1},
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
--Chair
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

--Bench
core.register_node("mymagic:tower_bench", {
	description = "Tower Bench",
	tiles = {
			"mymagic_wood.png",
			},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {unbreakable = 1, not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.375, -0.5, 0, -0.25, 0.125, 0.5},
			{0.25, -0.5, 0, 0.375, 0.125, 0.5},
			{-0.5, 0, 0, 0.5, 0.125, 0.5},
		}
	}
})

--Window Sil
core.register_node("mymagic:tower_window_sil", {
	description = "Tower Sil",
	tiles = {
			"mymagic_grey.png",
			},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {unbreakable = 1, not_in_creative_inventory = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.1875, 0.5, -0.25, 0.5},
		}
	},
	on_place = core.rotate_node,
})

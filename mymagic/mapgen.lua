core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:chest",
	wherein        = "air",
	clust_scarcity = 150 * 150 * 150,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min          = 1,
	y_max          = 3,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:chest",
	wherein        = "default:mossycobble",
	clust_scarcity = 30 * 30 * 30,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min          = -31000,
	y_max          = -50,
})

local tool_blocks = {"sword_block", "axe_block", "pick_block"}
for _, block in ipairs(tool_blocks) do
	core.register_ore({
		ore_type       = "scatter",
		ore            = "mymagic:" .. block,
		wherein        = "default:stone",
		clust_scarcity = 20 * 20 * 20,
		clust_num_ores = 1,
		clust_size     = 1,
		y_min          = -31000,
		y_max          = -25,
	})
end

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:dark_stone",
	wherein        = "default:stone",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min          = -31000,
	y_max          = -20,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:dark_desert_stone",
	wherein        = "default:stone",
	clust_scarcity = 20 * 20 * 20,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min          = -31000,
	y_max          = -1,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:orb_orange_in_stone",
	wherein        = "default:stone",
	clust_scarcity = 30 * 30 * 30,
	clust_num_ores = 2,
	clust_size     = 2,
	y_min          = -31000,
	y_max          = -1,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:orb_green_in_stone",
	wherein        = "default:stone",
	clust_scarcity = 30 * 30 * 30,
	clust_num_ores = 2,
	clust_size     = 2,
	y_min          = -31000,
	y_max          = -50,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:orb_blue_in_stone",
	wherein        = "default:stone",
	clust_scarcity = 30 * 30 * 30,
	clust_num_ores = 2,
	clust_size     = 2,
	y_min          = -31000,
	y_max          = -150,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:orb_red_in_stone",
	wherein        = "default:stone",
	clust_scarcity = 30 * 30 * 30,
	clust_num_ores = 2,
	clust_size     = 2,
	y_min          = -31000,
	y_max          = -250,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:crystal_orange_in_stone",
	wherein        = "default:stone",
	clust_scarcity = 30 * 30 * 30,
	clust_num_ores = 2,
	clust_size     = 2,
	y_min          = -31000,
	y_max          = -1,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:crystal_green_in_stone",
	wherein        = "default:stone",
	clust_scarcity = 30 * 30 * 30,
	clust_num_ores = 2,
	clust_size     = 2,
	y_min          = -31000,
	y_max          = -50,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:crystal_blue_in_stone",
	wherein        = "default:stone",
	clust_scarcity = 30 * 30 * 30,
	clust_num_ores = 2,
	clust_size     = 2,
	y_min          = -31000,
	y_max          = -150,
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:crystal_red_in_stone",
	wherein        = "default:stone",
	clust_scarcity = 30 * 30 * 30,
	clust_num_ores = 2,
	clust_size     = 2,
	y_min          = -31000,
	y_max          = -250,
})

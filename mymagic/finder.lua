core.register_node("mymagic:cave_finder", {
	description = "Cave Finder",
	drawtype = "normal",
	tiles = {
		"mymagic_cave_finder_top.png",
		"mymagic_cave_finder_top.png",
		"mymagic_cave_finder_top.png",
		"mymagic_cave_finder_top.png",
		"mymagic_cave_finder_front.png",
		"mymagic_cave_finder_front.png",
	},
	paramtype2 = "facedir",
	use_texture_alpha = "clip",
	groups = {handy = 1, snappy = 3, not_in_creative_inventory = 0},
})
core.register_craft({
		output = "mymagic:cave_finder",
		recipe = {
			{"group:wood","default:sand","group:wood"},
			{"default:sand","default:glass","default:sand"},
			{"group:wood","default:sand","group:wood"}
			}
})

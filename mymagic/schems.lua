minetest.register_abm({
	nodenames = {"mymagic:placer"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local rand = math.random(1,8)
		local schem = minetest.get_modpath("mymagic").."/schems/block"..rand..".mts"
			minetest.place_schematic({x=pos.x,y=pos.y,z=pos.z},schem,random, "air", true)
	end,
})
minetest.register_node("mymagic:placer",{
	description = "Place Treasure Block",
	tiles = {"default_cobble.png^default_snowball.png"},
	drawtype = "normal",
	paramtype = "light",
	light_source = 8,
	groups = {cracky = 1},
})
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic:placer",
	wherein        = "default:stone",
	clust_scarcity = 40*40*40,
	clust_num_ores = 1,
	clust_size     = 1,
	y_min     = -10000,
	y_max     = -10,
})

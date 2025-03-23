local blocks = {
	{"pick","cobble","Cobble",{cracky=1}},
	{"pick","desert_cobble","Desert Cobble",{cracky=1}},
	{"pick","stone_brick","Stone Brick",{cracky=1}},
	{"pick","desert_stone_brick","Desert Stone Brick",{cracky=1}},
	{"pick","stone","Stone Brick",{cracky=1}},
	{"pick","desert_stone","Desert Stone Brick",{cracky=1}},
	
	}
for i in ipairs(blocks) do
	local tl = blocks[i][1]
	local itm = blocks[i][2]
	local des = blocks[i][3]
	local gro = blocks[i][4]

minetest.register_node("mymagic:dark_"..itm,{
	description = "Dark "..des,
	tiles = {"mymagic_dark_"..itm..".png"},
	drawtype = "normal",
	paramtype = "light",
	light_source = 14,
	groups = {magic_pick = 1},
})
end
minetest.override_item("mymagic:dark_stone",{
	drop = "mymagic:dark_cobble",
})
minetest.override_item("mymagic:dark_desert_stone",{
	drop = "mymagic:dark_desert_cobble",
})

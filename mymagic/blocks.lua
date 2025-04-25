local blocks = {
	{"Orange",	"orange",	"sword", {magic_sword = 4}},
	{"Green",	"green",	"sword", {magic_sword = 3}},
	{"Blue",	"blue",		"sword", {magic_sword = 2}},
	{"Red",		"red",		"sword", {magic_sword = 1}},
	{"Orange",	"orange",	"axe", {magic_axe = 4}},
	{"Green",	"green",	"axe", {magic_axe = 3}},
	{"Blue",	"blue",		"axe", {magic_axe = 2}},
	{"Red",		"red",		"axe", {magic_axe = 1}},
	}
for i in ipairs (blocks) do
	local des  = blocks[i][1]
	local col  = blocks[i][2]
	local tool = blocks[i][3]
	local mag  = blocks[i][4]

minetest.register_node("mymagic:block_"..col.."_"..tool,{
	description = des.." Magic block - "..tool,
	tiles = {"mymagic_block_"..tool.."_"..col..".png"},
	paramtype = "light",
	drop = "",
	light_source = 12,
	groups = mag,
	on_punch = function(pos, node, puncher, pointed_thing)
		minetest.chat_send_player(puncher:get_player_name(), "You need an enchanted "..col.." "..tool.." to break this block")
	end,
})
end

local function parti(pos)
  	minetest.add_particlespawner(40, 1,
		pos, pos,
		{x=-5, y=-5, z=-5}, {x=5, y=5, z=5},
		{x=-2, y=-2, z=-2}, {x=2, y=2, z=2},
		0.2, 2,
		0.2, 3,
		false, "mymagic_magic_parti.png")
end

local items = {
		{"default:sword_diamond","sword","Sword Block"},
		{"default:pick_diamond","pick","Pick Block"},
		{"default:axe_diamond","axe","Axe Block"},
		}
for i in ipairs (items) do
	local itm = items[i][1]
	local nam = items[i][2]
	local des = items[i][3]

minetest.register_node("mymagic:"..nam.."_block",{
	description = des,
	tiles = {"mymagic_block_"..nam..".png"},
	drawtype = "nodebox",
	paramtype = "light",
	drop = "",
--	light_source = 12,
	groups = {magic_sword = 1,cracky=3},
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
		minetest.spawn_item(pos, itm)
		parti(pos)
	end,
})
end
local colors =	{
				{"red",{ r=255, g=0, b=0, a=200 }},
				{"green",{ r=0, g=255, b=0, a=200 }},
				{"blue",{ r=0, g=150, b=180, a=200 }},
				{"orange",{ r=200, g=150, b=0, a=200 }}
				}
for i in ipairs(colors) do
local col = colors[i][1]
local rgb = colors[i][2]
local scol = 0
if col == "red" then scol = 1
elseif col == "blue" then scol = 2
elseif col == "green" then scol = 3
elseif col == "orange" then scol = 4
end

minetest.register_node("mymagic:colored_energy_"..col,{
	description = "Energy Block",
	tiles = {{name="mymagic_teleport_ani_"..col..".png", animation={type="vertical_frames",aspect_w=16, aspect_h=16, length=0.5}}},
	paramtype = "light",
	drawtype = "glasslike",
	post_effect_color = rgb,
	drop = "",
	light_source = 14,
	walkable = false,
	groups = {cracky=1,magic_shovel = scol},

})
minetest.register_craft({
	type = "shapeless",
	output = "mymagic:colored_energy_"..col,
	recipe = {
			"mymagic:orb_"..col,"mymagic:orb_"..col,
			"mymagic:orb_"..col,"mymagic:orb_"..col,
			},
})
end
minetest.register_node("mymagic:hole1",{
	description = "FakeTeleport Block",
	tiles = {
			"mymagic_hole_in_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			},
	paramtype = "light",
	drop = "",
	groups = {magic_shovel = 1, not_in_creative_inventory = 1},
})
minetest.register_node("mymagic:hole2",{
	description = "FakeTeleport Block",
	tiles = {
			"mymagic_hole_in_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			"mymagic_floor.png",
			},
	paramtype = "light",
	drop = "",
	groups = {magic_shovel = 1, not_in_creative_inventory = 1},
})
minetest.register_node("mymagic:stone_floor",{
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
	groups = {cracky = 1, not_in_creative_inventory = 0},
})

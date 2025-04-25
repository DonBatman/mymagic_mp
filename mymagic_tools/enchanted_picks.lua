local picks = {
			{"wood",	"Wood",		"orange",	"Orange",	{fleshy=3},	{[1]=2.3,	[2]=1.7,	[3]=1.5,	[4]=1.5}, 15, 4, 0.9},
			{"wood",	"Wood",		"green",	"Green",	{fleshy=4},	{[1]=2.2,	[2]=1.6,	[3]=1.2, 	[4]=1.2}, 20, 3, 0.9},
			{"wood",	"Wood",		"blue",		"Blue",		{fleshy=5},	{[1]=2.1,	[2]=1.5, 	[3]=0.9, 	[4]=0.9}, 25, 2, 0.9},
			{"wood",	"Wood",		"red",		"Red",		{fleshy=6},	{[1]=2.0, 	[2]=1.4, 	[3]=0.6, 	[4]=0.6}, 30, 1, 0.9},
			
			{"stone",	"Stone",	"orange",	"Orange",	{fleshy=5},	{[1]=2.0,	[2]=1.5,	[3]=1.3,	[4]=1.3}, 25, 4, 0.8},
			{"stone",	"Stone",	"green",	"Green",	{fleshy=6},	{[1]=1.9,	[2]=1.4,	[3]=1.1, 	[4]=1.1}, 30, 3, 0.8},
			{"stone",	"Stone",	"blue",		"Blue",		{fleshy=7},	{[1]=1.8,	[2]=1.3, 	[3]=0.8, 	[4]=0.8}, 35, 2, 0.8},
			{"stone",	"Stone",	"red",		"Red",		{fleshy=8},	{[1]=1.7, 	[2]=1.2, 	[3]=0.6, 	[4]=0.6}, 40, 1, 0.8},
			
			{"steel",	"Steel",	"orange",	"Orange",	{fleshy=7},	{[1]=1.7,	[2]=1.3,	[3]=1.1,	[4]=1.1}, 35, 4, 0.7},
			{"steel",	"Steel",	"green",	"Green",	{fleshy=8},	{[1]=1.6,	[2]=1.2,	[3]=0.8, 	[4]=0.8}, 40, 3, 0.7},
			{"steel",	"Steel",	"blue",		"Blue",		{fleshy=9},	{[1]=1.5,	[2]=1.1, 	[3]=0.6, 	[4]=0.6}, 45, 2, 0.7},
			{"steel",	"Steel",	"red",		"Red",		{fleshy=10},{[1]=1.4, 	[2]=1.0, 	[3]=0.4, 	[4]=0.4}, 50, 1, 0.7},
			
			{"bronze",	"Bronze",	"orange",	"Orange",	{fleshy=9},	{[1]=1.4,	[2]=1.1,	[3]=0.9,	[4]=0.9}, 45, 4, 0.6},
			{"bronze",	"Bronze",	"green",	"Green",	{fleshy=10},{[1]=1.3,	[2]=1.0,	[3]=0.8, 	[4]=0.8}, 50, 3, 0.6},
			{"bronze",	"Bronze",	"blue",		"Blue",		{fleshy=11},{[1]=1.2,	[2]=0.9, 	[3]=0.6, 	[4]=0.6}, 55, 2, 0.6},
			{"bronze",	"Bronze",	"red",		"Red",		{fleshy=12},{[1]=1.1, 	[2]=0.8, 	[3]=0.4, 	[4]=0.4}, 60, 1, 0.6},
			
			{"mese",	"Mese",		"orange",	"Orange",	{fleshy=11},{[1]=1.4,	[2]=0.9,	[3]=0.7,	[4]=0.7}, 35, 4, 0.5},
			{"mese",	"Mese",		"green",	"Green",	{fleshy=12},{[1]=1.2,	[2]=0.8,	[3]=0.6, 	[4]=0.6}, 40, 3, 0.5},
			{"mese",	"Mese",		"blue",		"Blue",		{fleshy=13},{[1]=1.0,	[2]=0.7, 	[3]=0.4, 	[4]=0.4}, 45, 2, 0.5},
			{"mese",	"Mese",		"red",		"Red",		{fleshy=14},{[1]=0.8,	[2]=0.6, 	[3]=0.2, 	[4]=0.2}, 50, 1, 0.5},
			
			{"diamond",	"Diamond",	"orange",	"Orange",	{fleshy=13},{[1]=0.8,	[2]=0.7,	[3]=0.5,	[4]=0.5}, 50, 4, 0.4},
			{"diamond",	"Diamond",	"green",	"Green",	{fleshy=14},{[1]=0.6,	[2]=0.6,	[3]=0.4, 	[4]=0.4}, 60, 3, 0.4},
			{"diamond",	"Diamond",	"blue",		"Blue",		{fleshy=15},{[1]=0.4,	[2]=0.4, 	[3]=0.3, 	[4]=0.3}, 70, 2, 0.3},
			{"diamond",	"Diamond",	"red",		"Red",		{fleshy=16},{[1]=0.2,	[2]=0.2, 	[3]=0.2, 	[4]=0.2}, 80, 1, 0.3},
			}
for i in ipairs (picks) do
	local mat  = picks[i][1]
	local mdes = picks[i][2]
	local col  = picks[i][3]
	local cdes = picks[i][4]
	local fles = picks[i][5]
	local gro  = picks[i][6]
	local us  = picks[i][7]
	local ml  = picks[i][8]
	local fp  = picks[i][9]

minetest.register_tool("mymagic_tools:pick_enchanted_"..mat.."_"..col,{
	description = "Enchanted "..mdes.." Pick - "..cdes,
	inventory_image = "mymagic_pick_"..col..".png^mymagic_axe_handle_"..mat..".png^mymagic_leather_grip.png",
	wield_scale = {x=1,y=1.5,z=1.5},
	tool_capabilities = {
		full_punch_interval = fp,
		max_drop_level=1,
		groupcaps={
			cracky = {times = gro, uses = us, maxlevel=ml},
			magic_pick = {times = gro, uses = us, maxlevel=ml},
		},
		damage_groups = fles,
		},
	groups = {not_in_creative_inventory = 0},
	on_place = function(itemstack, placer, pointed_thing)
	minetest.set_node(pointed_thing.above,{name = "default:cobble"})
	end
})
end









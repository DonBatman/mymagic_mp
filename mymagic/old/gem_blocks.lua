local function parti(pos)
  	minetest.add_particlespawner(40, 1,
		pos, pos,
		{x=-5, y=-5, z=-5}, {x=5, y=5, z=5},
		{x=-2, y=-2, z=-2}, {x=2, y=2, z=2},
		0.2, 2,
		0.2, 3,
		false, "mymagic_magic_parti.png")
end

minetest.register_node("mymagic:gem_block",{
	description = "Gem Block",
	tiles = {"mymagic_gem_block_orange.png^[colorize:#000000:150"},
	light_source = 10,
	paramtype = "light",
	groups = {cracky = 1},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
	--local meta = minetest.get_meta(pos)

		minetest.show_formspec(placer:get_player_name(),"mymagic_fs",
				"size[4,4;]"..
				"image_button_exit[1,1;1,1;mymagic_crystal_orange.png;orange;]"..
				"image_button_exit[1,2;1,1;mymagic_crystal_green.png;green;]"..
				"image_button_exit[2,1;1,1;mymagic_crystal_blue.png;blue;]"..
				"image_button_exit[2,2;1,1;mymagic_crystal_red.png;red;]")

			minetest.register_on_player_receive_fields(function(player, mymagic_fs, fields)
				if fields["orange"] or fields["green"] or fields["blue"] or fields["red"] then
					if fields["orange"] then
						minetest.remove_node(pos)
						minetest.place_node(pos, {name = "mymagic:gem_block_orange"})
					end
					if fields["green"] then
						minetest.remove_node(pos)
						minetest.place_node(pos, {name = "mymagic:gem_block_green"})
					end
					if fields["blue"] then
						minetest.remove_node(pos)
						minetest.place_node(pos, {name = "mymagic:gem_block_blue"})
					end
					if fields["red"] then
						minetest.remove_node(pos)
						minetest.place_node(pos, {name = "mymagic:gem_block_red"})
					end
				end
			end)
	end,
})

minetest.register_node("mymagic:gem_block_orange",{
	description = "Orange Gem Block",
	tiles = {"mymagic_gem_block_orange.png"},
	light_source = 11,
	paramtype2 = "facedir",
	groups = {cracky = 1, not_in_creative_inventory = 1},


	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	minetest.show_formspec(player:get_player_name(),"mymagic_orange_fs",
		"size[4,5.5;]"..
		"background[-0.5,-0.5;5,6.5;mymagic_gem_block_bg_orange.png]"..
		"background[0.5,0.5;3,3;mymagic_gem_block_orange.png]"..
		"listcolors[#cf7f00;#fb9c06;#000000]"..
		"label[1,0;Insert Orange Crystal]"..
		"list[current_name;orange_gem;1.5,1.5;1,1;]"..
		"button_exit[1,3.5;2,1;orange;Activate]"..
		"list[current_player;main;0,4.5;4,1;]")
	local inv = meta:get_inventory()
		inv:set_size("orange_gem", 1)
	end,
	on_receive_fields = function(pos, mymagic_orange_fs, fields, sender)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	
		if fields["orange"] then
			if inv:is_empty("orange_gem") then
				return
			end
		local gem = inv:get_stack("orange_gem", 1)
		
			if gem:get_name() == "mymagic:crystal_orange" then
			local node = minetest.get_node(pos)
				gem:take_item()
				minetest.spawn_item({x=pos.x,y=pos.y+1,z=pos.z}, gem)
				minetest.set_node(pos,{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y-1,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y-2,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y-3,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y-4,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y-5,z=pos.z},{name="default:ladder",param2=2})
				parti(pos)
			
			end
		end
	end,
})

minetest.register_node("mymagic:gem_block_green",{
	description = "Green Gem Block",
	tiles = {"mymagic_gem_block_green.png"},
	light_source = 11,
	paramtype2 = "facedir",
	groups = {cracky = 1, not_in_creative_inventory = 1},
	
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	minetest.show_formspec(player:get_player_name(),"mymagic_green_fs",
		"size[4,5.5;]"..
		"background[-0.5,-0.5;5,6.5;mymagic_gem_block_bg_green.png]"..
		"background[0.5,0.5;3,3;mymagic_gem_block_green.png]"..
		"listcolors[#0d6601;#13a400;#000000]"..
		"label[1,0;Insert Green Crystal]"..
		"list[current_name;green_gem;1.5,1.5;1,1;]"..
		"button_exit[1,3.5;2,1;green;Activate]"..
		"list[current_player;main;0,4.5;4,1;]")
	local inv = meta:get_inventory()
		inv:set_size("green_gem", 1)
	end,
	on_receive_fields = function(pos, mymagic_green_fs, fields, sender)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	
		if fields["green"] then
			if inv:is_empty("green_gem") then
				return
			end
		local gem = inv:get_stack("green_gem", 1)
		
			if gem:get_name() == "mymagic:crystal_green" then
			local node = minetest.get_node(pos)
				gem:take_item()
				minetest.spawn_item({x=pos.x,y=pos.y+1,z=pos.z}, gem)
				minetest.set_node(pos,{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y+2,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y+3,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y+4,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y+5,z=pos.z},{name="default:ladder",param2=2})
				minetest.set_node({x=pos.x,y=pos.y+6,z=pos.z},{name="default:ladder",param2=2})
				parti(pos)
			
			end
		end
	end,
})


minetest.register_node("mymagic:gem_block_blue",{
	description = "Blue Gem Block",
	tiles = {"mymagic_gem_block_blue.png"},
	light_source = 11,
	paramtype2 = "facedir",
	groups = {cracky = 1, not_in_creative_inventory = 1},
	

	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	minetest.show_formspec(player:get_player_name(),"mymagic_orange_fs",
		"size[4,5.5;]"..
		"background[-0.5,-0.5;5,6.5;mymagic_gem_block_bg_blue.png]"..
		"background[0.5,0.5;3,3;mymagic_gem_block_blue.png]"..
		"listcolors[#030f4a;#030f7b;#000000]"..
		"label[1,0;Insert Blue Crystal]"..
		"list[current_name;blue_gem;1.5,1.5;1,1;]"..
		"button_exit[1,3.5;2,1;blue;Activate]"..
		"list[current_player;main;0,4.5;4,1;]")
	local inv = meta:get_inventory()
		inv:set_size("blue_gem", 1)
	end,
	on_receive_fields = function(pos, mymagic_orange_fs, fields, sender)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	
		if fields["blue"] then
			if inv:is_empty("blue_gem") then
				return
			end
		local gem = inv:get_stack("blue_gem", 1)
		
			if gem:get_name() == "mymagic:crystal_blue" then
			local node = minetest.get_node(pos)
				gem:take_item()
				minetest.spawn_item({x=pos.x,y=pos.y+1,z=pos.z}, gem)
				minetest.set_node(pos,{name="air",param2=node.param2})
				minetest.set_node({x=pos.x,y=pos.y-1,z=pos.z},{name="mymagic:hole1",param2=node.param2})
				parti(pos)
			
			end
		end
	end,
})

minetest.register_node("mymagic:gem_block_red",{
	description = "Red Gem Block",
	tiles = {"mymagic_gem_block_red.png"},
	light_source = 11,
	paramtype2 = "facedir",
	groups = {cracky = 1, not_in_creative_inventory = 1},
	

	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	minetest.show_formspec(player:get_player_name(),"mymagic_red_fs",
		"size[4,5.5;]"..
		"background[-0.5,-0.5;5,6.5;mymagic_gem_block_bg_red.png]"..
		"background[0.5,0.5;3,3;mymagic_gem_block_red.png]"..
		"listcolors[#910000;#d50000;#000000]"..
		"label[1,0;Insert Red Crystal]"..
		"list[current_name;red_gem;1.5,1.5;1,1;]"..
		"button_exit[1,3.5;2,1;red;Activate]"..
		"list[current_player;main;0,4.5;4,1;]")
	local inv = meta:get_inventory()
		inv:set_size("red_gem", 1)
	end,
	on_receive_fields = function(pos, mymagic_red_fs, fields, sender)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	
		if fields["red"] then
			if inv:is_empty("red_gem") then
				return
			end
		local gem = inv:get_stack("red_gem", 1)
		
			if gem:get_name() == "mymagic:crystal_red" then
			local node = minetest.get_node(pos)
				gem:take_item()
				minetest.spawn_item({x=pos.x,y=pos.y+1,z=pos.z}, gem)
				minetest.set_node(pos,{name="air",param2=node.param2})
				minetest.set_node({x=pos.x,y=pos.y-1,z=pos.z},{name="mymagic:hole2",param2=node.param2})
				parti(pos)
			
			end
		end
	end,
})

minetest.register_abm({
	nodenames = {"mymagic:hole1","mymagic:hole2"},
	interval = 0.5,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local objs = minetest.get_objects_inside_radius(pos, 1)
		for k, player in pairs(objs) do
			if player:get_player_name() then
				if node.name == "mymagic:hole1" then
					player:setpos({x=pos.x,y=pos.y+7,z=pos.z})
				elseif node.name == "mymagic:hole2" then
					player:setpos({x=pos.x,y=pos.y-3,z=pos.z})
				end
			end
		end
	end
})

local function play_drink_sound(user)
	minetest.sound_play("default_dig_glass", {
		pos = user:get_pos(),
		gain = 0.5,
		pitch = 1.2,
	})
end

local function give_empty_bottle(user)
	local inv = user:get_inventory()
	local bottle_stack = ItemStack("mymagic_potions:glass_bottle")
	if inv:room_for_item("main", bottle_stack) then
		inv:add_item("main", bottle_stack)
	else
		minetest.add_item(user:get_pos(), bottle_stack)
	end
end

minetest.register_craftitem("mymagic_potions:potion_health", {
	description = "Potion of Health\nRestores 6 HP",
	inventory_image = "mymagic_bottle_red.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if not user or not user:is_player() then return end
		local hp = user:get_hp()
		if hp >= 20 then return end
		
		user:set_hp(math.min(hp + 6, 20))
		play_drink_sound(user)
		give_empty_bottle(user)
		itemstack:take_item()
		return itemstack
	end,
})

minetest.register_craftitem("mymagic_potions:potion_mana", {
	description = "Potion of Mana\nRestores magical energy",
	inventory_image = "mymagic_bottle_blue.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if not user or not user:is_player() then return end
		local name = user:get_player_name()
		if minetest.get_modpath("mana") then
			mana.add_mana(name, 50)
		end
		play_drink_sound(user)
		give_empty_bottle(user)
		itemstack:take_item()
		return itemstack
	end,
})

minetest.register_craftitem("mymagic_potions:potion_swiftness", {
	description = "Potion of Swiftness\nIncreases movement speed for 30s",
	inventory_image = "mymagic_bottle_green.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if not user or not user:is_player() then return end
		user:set_physics_override({ speed = 2.0 })
		minetest.after(30, function()
			if user and user:is_player() then
				user:set_physics_override({ speed = 1.0 })
			end
		end)
		play_drink_sound(user)
		give_empty_bottle(user)
		itemstack:take_item()
		return itemstack
	end,
})

minetest.register_craftitem("mymagic_potions:potion_fire_res", {
	description = "Potion of Fire Resistance\nProtects from heat for 60s",
	inventory_image = "mymagic_bottle_orange.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if not user or not user:is_player() then return end
		local meta = user:get_meta()
		meta:set_int("fire_resistant", 1)
		minetest.after(60, function()
			if user and user:is_player() then
				user:get_meta():set_int("fire_resistant", 0)
			end
		end)
		play_drink_sound(user)
		give_empty_bottle(user)
		itemstack:take_item()
		return itemstack
	end,
})

minetest.register_craftitem("mymagic_potions:potion_void", {
	description = "Potion of Void\nBrief invisibility and low gravity",
	inventory_image = "mymagic_bottle_purple.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if not user or not user:is_player() then return end
		user:set_properties({ visual_size = {x=0, y=0, z=0} })
		user:set_physics_override({ gravity = 0.3 })
		minetest.after(15, function()
			if user and user:is_player() then
				user:set_properties({ visual_size = {x=1, y=1, z=1} })
				user:set_physics_override({ gravity = 1.0 })
			end
		end)
		play_drink_sound(user)
		give_empty_bottle(user)
		itemstack:take_item()
		return itemstack
	end,
})

minetest.register_craftitem("mymagic_potions:potion_night_vision", {
	description = "Potion of Night Vision\nSee in the dark for 60s",
	inventory_image = "mymagic_bottle_yellow.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if not user or not user:is_player() then return end
		
		user:override_day_night_ratio(1.0)
		
		minetest.after(60, function()
			if user and user:is_player() then
				user:override_day_night_ratio(nil)
			end
		end)
		
		play_drink_sound(user)
		give_empty_bottle(user)
		itemstack:take_item()
		return itemstack
	end,
})

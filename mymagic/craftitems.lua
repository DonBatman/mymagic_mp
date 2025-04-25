
minetest.register_craftitem("mymagic:empty_bottle",{
	inventory_image = "mymagic_empty_potion_bottle.png",
	description = "Empty Bottle",
})

minetest.register_craft({
	type = "cooking",
	output = "mymagic:empty_bottle 1",
	recipe = "default:glass"
})

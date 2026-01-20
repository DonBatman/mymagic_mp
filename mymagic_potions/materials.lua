-- MyMagic Potions: Materials and Ores

minetest.register_craftitem("mymagic_potions:mana_crystal", {
    description = "Mana Crystal",
    inventory_image = "mymagic_mana_crystal.png",
})

minetest.register_craftitem("mymagic_potions:void_orb", {
    description = "Void Orb",
    inventory_image = "mymagic_void_orb.png",
})

minetest.register_node("mymagic_potions:stone_with_mana", {
    description = "Mana Ore",
    tiles = {"default_stone.png^mymagic_mana_overlay.png"},
    groups = {cracky = 3},
    drop = "mymagic_potions:mana_crystal",
    light_source = 5,
})
core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic_potions:stone_with_mana",
	wherein        = "default:stone",
	clust_scarcity = 20*20*20,
	clust_num_ores = 5,
	clust_size     = 3,
	y_min     = -31000,
	y_max     = -50,
})

minetest.register_node("mymagic_potions:stone_with_void", {
    description = "Void Ore",
    tiles = {"default_stone.png^mymagic_void_overlay.png"},
    groups = {cracky = 2},
    drop = "mymagic_potions:void_orb",
})

core.register_ore({
	ore_type       = "scatter",
	ore            = "mymagic_potions:stone_with_void",
	wherein        = "default:stone",
	clust_scarcity = 20*20*20,
	clust_num_ores = 5,
	clust_size     = 3,
	y_min     = -31000,
	y_max     = -150,
})

minetest.register_node("mymagic_potions:glass_bottle", {
    description = "Glass Bottle",
    drawtype = "plantlike",
    tiles = {"mymagic_bottle_empty.png"},
    --inventory_image = "mymagic_bottle_empty.png",
    paramtype = "light",
    walkable = false,
    groups = {vessel = 1, dig_immediate = 3},
})

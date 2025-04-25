-- Ghost by BlockMen

dofile(minetest.get_modpath("mymagic_mobs").."/api.lua")

mymagic_mobs:register_mob("mymagic_mobs:ghost", {
	type = "monster",
	passive = false,
	damage = 2,
	attack_type = "dogfight",
	hp_min = 7,
	hp_max = 12,
	armor = 130,
	collisionbox = {-0.3, -0.5, -0.3, 0.3, 0.75, 0.3},
	visual = "mesh",
	mesh = "mymagic_ghost.x",
	textures = {
		{"mymagic_ghost.png"},
	},
	blood_texture = "mymagic_blood_drop.png",
	visual_size = {x=1, y=1},
	makes_footstep_sound = false,
	sounds = {
		random = "mymagic_ghost",
		damage = "mymagic_ghost_hit",
		death = "mymagic_ghost_death"
	},
--	drops = {
--		{name = "mymagic_mobs:orb_green", chance = 80, min = 1, max = 1},
--	},
	walk_velocity = 2,
	run_velocity = 2,
	fall_speed = 0,
	jump = true,
	fly = true,
	fly_in = "air",
	water_damage = 0,
	lava_damage = 0,
	light_damage = 2,
	view_range = 14,
	animation = {
		speed_normal = 30,		speed_run = 30,
		walk_start = 168,		walk_end = 187,

	},
})
--mobs:register_spawn(name, nodes, max_light, min_light, chance,active_object_count, max_height, day_toggle)

mymagic_mobs:register_spawn("mymagic_mobs:ghost", "mymagic:candle", 14, 0, 1, 4,200)

--mymagic_mobs:register_egg("mymagic_mobs:ghost", "Ghost", "default_cloud.png", 1)


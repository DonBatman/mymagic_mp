local crystals = {
    {"Orange Crystal - 1", "crystal_orange", 10},
    {"Green Crystal - 2", "crystal_green", 20},
    {"Blue Crystal - 3", "crystal_blue", 30},
    {"Red Crystal - 4", "crystal_red", 40},
}

for i in ipairs(crystals) do
    local des = crystals[i][1]
    local itm = crystals[i][2]
    local man = crystals[i][3]

    core.register_node("mymagic:" .. itm .. "_in_stone", {
        description = "Crystal in Stone",
        tiles = {"default_stone.png^mymagic_" .. itm .. "_in_stone.png"},
        paramtype = "light",
        drop = "mymagic:" .. itm,
        light_source = 5,
        groups = {cracky = 2, not_in_creative_inventory = 1},
    })

    core.register_craftitem("mymagic:" .. itm, {
        description = des,
        inventory_image = "mymagic_" .. itm .. ".png",
        groups = {magic_crystal = 1},
    })
end

local orbs = {
    {"Orange Energy Orb - 1", "orb_orange", 20},
    {"Green Energy Orb - 2", "orb_green", 40},
    {"Blue Energy Orb - 3", "orb_blue", 60},
    {"Red Energy Orb - 4", "orb_red", 80},
}

for i in ipairs(orbs) do
    local des = orbs[i][1]
    local itm = orbs[i][2]
    local man = orbs[i][3]

    core.register_node("mymagic:" .. itm .. "_in_stone", {
        description = "Orb in Stone",
        tiles = {"default_stone.png^mymagic_" .. itm .. "_in_stone.png"},
        paramtype = "light",
        drop = "mymagic:" .. itm,
        light_source = 5,
        groups = {cracky = 2, not_in_creative_inventory = 1},
    })

    core.register_craftitem("mymagic:" .. itm, {
        description = des,
        inventory_image = "mymagic_" .. itm .. ".png",
        groups = {magic_orb = 1},
    })

    core.register_craftitem("mymagic:powder_" .. itm, {
        description = des .. " Powder",
        inventory_image = "mymagic_" .. itm .. "_powder.png",
        groups = {magic_powder = 1},
    })
end

for i in ipairs(orbs) do
    local itm = orbs[i][2]
    core.register_craft({
        type = "shapeless",
        output = "mymagic:powder_" .. itm .. " 4",
        recipe = {"mymagic:" .. itm, "default:stone_sharp"},
    })
end

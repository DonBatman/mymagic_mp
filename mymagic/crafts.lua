core.register_craft({
    output = "mymagic:stone_floor 4",
    recipe = {
        {"",                "default:cobble", "default:cobble"},
        {"",                "default:cobble", ""},
        {"default:cobble", "default:cobble", ""},
    }
})

local orb_colors = {"orange", "green", "blue", "red"}

for _, col in ipairs(orb_colors) do
    core.register_craft({
        type = "cooking",
        output = "mymagic:powder_orb_" .. col,
        recipe = "mymagic:orb_" .. col,
        cooktime = 5,
    })
end

core.register_craft({
    type = "cooking",
    output = "mymagic:dark_stone",
    recipe = "mymagic:dark_cobble",
    cooktime = 5,
})

core.register_craft({
    type = "cooking",
    output = "mymagic:dark_desert_stone",
    recipe = "mymagic:dark_desert_cobble",
    cooktime = 5,
})

core.register_craft({
    type = "shapeless",
    output = "mymagic:dark_stone_brick 4",
    recipe = {
        "mymagic:dark_stone", "mymagic:dark_stone",
        "mymagic:dark_stone", "mymagic:dark_stone"
    }
})

core.register_craft({
    type = "shapeless",
    output = "mymagic:dark_desert_stone_brick 4",
    recipe = {
        "mymagic:dark_desert_stone", "mymagic:dark_desert_stone",
        "mymagic:dark_desert_stone", "mymagic:dark_desert_stone"
    }
})

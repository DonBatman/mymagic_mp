local orbs = {
    {"orange", "Earth Orb", "wool:orange"},
    {"green",  "Nature Orb", "wool:green"},
    {"blue",   "Water Orb", "wool:blue"},
    {"red",    "Fire Orb",  "wool:red"},
}

for _, data in ipairs(orbs) do
    local id, desc, material = unpack(data)
    
    core.register_craftitem("mymagic:orb_" .. id, {
        description = desc,
        inventory_image = "mymagic_orb_" .. id .. ".png",
        groups = {magic_orb = 1},
    })

    core.register_craft({
        output = "mymagic:orb_" .. id,
        recipe = {
            {"default:glass", "default:glass", "default:glass"},
            {"default:glass", material,        "default:glass"},
            {"default:glass", "default:glass", "default:glass"},
        }
    })
end

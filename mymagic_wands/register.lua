mymagic_wands.register = function(wand)
    minetest.register_tool("mymagic_wands:" .. wand.name, {
        description = wand.description,
        inventory_image = wand.wield_image,
        wield_image = wand.wield_image,
        tool_capabilities = {
            full_punch_interval = 1.0,
            max_drop_level = 1,
            groupcaps = {
                cracky = {
                    times = { [1] = 2.0, [2] = 1.0, [3] = 0.5 },
                    uses = 20,
                    maxlevel = 1,
                },
            },
            damage_groups = { fleshy = 5 },
        },
        on_use = wand.on_use,
        on_secondary_use = wand.on_secondary_use
    })
end

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
        on_use = function(itemstack, user, pointed_thing)
            if core.is_player(user) then
                local ctrl = user:get_player_control()
                if not ctrl.sneak then
                    wand.on_use(itemstack, user, pointed_thing)
                else
                    wand.on_use_sneak(itemstack, user, pointed_thing)
                end
            end
        end,
        on_secondary_use = function(itemstack, user, pointed_thing)
            if core.is_player(user) then
                wand.on_secondary_use(itemstack, user, pointed_thing)
            end
        end,
    }) 
end

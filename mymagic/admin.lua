core.register_tool("mymagic:admin_tool", {
    description = "Admin Tool",
    inventory_image = "mymagic_admin_tool.png",
    groups = {not_in_creative_inventory = 0},
    tool_capabilities = {
        full_punch_interval = 0.2,
        max_drop_level = 3,
        groupcaps = {
            unbreakable = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            fleshy = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            choppy = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            bendy = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            cracky = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            crumbly = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            snappy = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            magic_sword = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            magic_axe = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            magic_shovel = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            magic_pick = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
        }
    },
    on_drop = function(itemstack, dropper, pos)
        if not drops then
            dropper:remove_item("myadmintools:ut",itemstack,false);
            core.chat_send_player(dropper:get_player_name(), "This tool cannot be dropped.")
        end
    end,
})

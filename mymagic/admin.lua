local god_mode = {}

core.register_tool("mymagic:admin_tool", {
    description = "§dAdmin Tool\n§7Instantly breaks everything.\n§bLeft-Click: Long-range Transform (Stone -> Diamond)\n§eSneak + Left: Revert (Diamond -> Stone)\n§bRight-Click: Refill Mana & Toggle Fly",
    inventory_image = "mymagic_admin_tool.png",
    groups = {not_in_creative_inventory = 0},
    tool_capabilities = {
        full_punch_interval = 0.1,
        max_drop_level = 3,
        groupcaps = {
            unbreakable  = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            fleshy       = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            choppy       = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            bendy        = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            cracky       = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            crumbly      = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            snappy       = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            magic_sword  = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            magic_axe    = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            magic_shovel = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
            magic_pick   = {times = {[1] = 0, [2] = 0, [3] = 0}, uses = 0, maxlevel = 3},
        },
        damage_groups = {fleshy = 1000},
    },

    on_use = function(itemstack, user, pointed_thing)
        local start_pos = vector.add(user:get_pos(), { x = 0, y = 1.5, z = 0 })
        local direction = user:get_look_dir()
        local ray = core.raycast(start_pos, vector.add(start_pos, vector.multiply(direction, 50)), false, false)
        
        local ctrl = user:get_player_control()
        local from = ctrl.sneak and "default:diamond_block" or "default:stone"
        local to = ctrl.sneak and "default:stone" or "default:diamond_block"
        local tex = ctrl.sneak and "default_stone.png" or "default_diamond_block.png"

        core.add_particle({
            pos = start_pos,
            velocity = vector.multiply(direction, 20),
            expirationtime = 0.5,
            size = 4,
            texture = tex,
            glow = 14,
        })

        for pointed in ray do
            if pointed.type == "node" then
                local hit_pos = vector.round(pointed.under)

                for dx = -1, 1 do
                    for dy = -1, 1 do
                        for dz = -1, 1 do
                            local p = vector.add(hit_pos, {x=dx, y=dy, z=dz})
                            if core.get_node(p).name == from then
                                core.set_node(p, {name = to})
                            end
                        end
                    end
                end
                break
            end
        end
        return itemstack
    end,

    on_place = function(itemstack, user, pointed_thing)
        if user and user:is_player() then
            local name = user:get_player_name()
            
            if mymagic_wands and mymagic_wands.mana then
                mymagic_wands.mana[name] = 100
            end

            local privs = core.get_privs(name)
            if not god_mode[name] then
                privs.fly = true
                privs.fast = true
                core.set_privs(name, privs)
                god_mode[name] = true
                core.chat_send_player(name, "Admin Mode: FLY ENABLED | MANA RESTORED")
            else
                privs.fly = nil
                privs.fast = nil
                core.set_privs(name, privs)
                god_mode[name] = nil
                core.chat_send_player(name, "Admin Mode: FLY DISABLED")
            end
        end
        return itemstack
    end,

    on_drop = function(itemstack, dropper, pos)
        core.chat_send_player(dropper:get_player_name(), "The Admin Tool cannot be dropped.")
        return itemstack
    end,
})

local function gain_wand_xp(itemstack, user)
    local meta = itemstack:get_meta()
    local xp = meta:get_int("wand_xp") + 1
    local level = meta:get_int("wand_level")
    if level < 1 then level = 1 end

    local next_level_xp = level * 20

    if xp >= next_level_xp then
        level = level + 1
        xp = 0
        core.chat_send_player(user:get_player_name(), "Your Wand reached Level " .. level .. "!")
    end

    meta:set_int("wand_xp", xp)
    meta:set_int("wand_level", level)
    
    local base_desc = meta:get_string("base_desc")
    meta:set_string("description", base_desc .. "\nLevel: " .. level .. " [" .. xp .. "/" .. next_level_xp .. "]")
    
    return itemstack
end

mymagic_wands.register = function(wand)
    core.register_tool("mymagic_wands:" .. wand.name, {
        description = wand.description,
        inventory_image = wand.wield_image,
        wield_image = wand.wield_image,
        tool_capabilities = {
            full_punch_interval = 1.0,
            damage_groups = { fleshy = 5 },
        },
        on_use = function(itemstack, user, pointed_thing)
            if not core.is_player(user) then return itemstack end
            
            local meta = itemstack:get_meta()
            if meta:get_string("base_desc") == "" then
                meta:set_string("base_desc", wand.description)
            end

            local ctrl = user:get_player_control()
            local success = false
            
            if not ctrl.sneak then
                if wand.on_use then
                    local res = wand.on_use(itemstack, user, pointed_thing)
                    if res then itemstack = res success = true end
                end
            else
                if wand.on_use_sneak then
                    local res = wand.on_use_sneak(itemstack, user, pointed_thing)
                    if res then itemstack = res success = true end
                end
            end

            if success then return gain_wand_xp(itemstack, user) end
            return itemstack
        end,
        on_place = function(itemstack, user, pointed_thing)
            if not core.is_player(user) then return itemstack end
            if wand.on_secondary_use then
                local res = wand.on_secondary_use(itemstack, user, pointed_thing)
                if res then 
                    itemstack = res 
                    return gain_wand_xp(itemstack, user)
                end
            end
            return itemstack
        end,
    })
end

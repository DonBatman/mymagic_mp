-- hud.lua
-- Integrated with myprogress and myxp mods, with a standalone fallback if they're missing.

local player_huds = {}

-- Function to create a simple text-based progress bar
local function get_progress_bar(current, max)
    local percent = math.min(current / math.max(max, 1), 1)
    local portion = math.floor(percent * 10)
    local bar = ""
    for i = 1, 10 do
        bar = bar .. (i <= portion and "|" or ".")
    end
    return bar
end

-- Function to update or create a standalone HUD for a player
local function update_standalone_hud(player)
    local name = player:get_player_name()
    local mana = mymagic_wands.mana[name] or 0
    local max_mana = 100
    
    local bar = get_progress_bar(mana, max_mana)
    local hud_text = string.format("Mana [%s] %d/%d", bar, math.floor(mana), max_mana)

    if not player_huds[name] then
        player_huds[name] = player:hud_add({
            hud_elem_type = "text",
            position = {x = 0, y = 1}, -- Bottom Left
            alignment = {x = 1, y = -1}, 
            offset = {x = 20, y = -20}, 
            text = hud_text,
            number = 0x00A0FF, 
            scale = {x = 100, y = 100},
        })
    else
        player:hud_change(player_huds[name], "text", hud_text)
    end
end

-- Refresh logic
local timer = 0
core.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer > 0.2 then
        for _, player in ipairs(core.get_connected_players()) do
            local name = player:get_player_name()
            local mana = mymagic_wands.mana[name] or 0
            local max_mana = 100
            local integrated = false
            
            -- Priority 1: Try to integrate with myprogress
            if myprogress and myprogress.players and myprogress.players[name] then
                local stats = myprogress.players[name]
                stats.mana = math.floor(mana)
                stats.max_mana = max_mana
                
                local huds = myprogress.player_huds and myprogress.player_huds[name]
                if huds then
                    local bar = get_progress_bar(mana, max_mana)
                    local display_text = string.format("Mana [%s] %d/%d", bar, stats.mana, stats.max_mana)
                    
                    if huds["mana"] then
                        player:hud_change(huds["mana"], "text", display_text)
                    else
                        huds["mana"] = player:hud_add({
                            type = "text",
                            position = {x = 0, y = 1},
                            offset = {x = 20, y = -160},
                            text = display_text,
                            number = 0x00A0FF,
                            alignment = {x = 1, y = -1},
                        })
                    end
                end
                
                if myprogress.update_hud then
                    myprogress.update_hud(player)
                end
                integrated = true
            
            -- Priority 2: Try to integrate with myxp
            elseif myxp then
                local bar = get_progress_bar(mana, max_mana)
                local display_text = "Mana: " .. math.floor(mana) .. " [" .. bar .. "]"
                
                -- Updated offset to y = -40 for mana to sit above myxp
                if not player_huds[name] then
                    player_huds[name] = player:hud_add({
                        hud_elem_type = "text",
                        position = {x = 0, y = 1},
                        offset = {x = 40, y = -40},
                        text = display_text,
                        alignment = {x = 1, y = 0},
                        number = 0x32CD32, 
                        scale = {x = 100, y = 100},
                    })
                else
                    player:hud_change(player_huds[name], "text", display_text)
                end
                integrated = true
            end

            -- Handle Cleanup if no longer integrated or switching to myprogress
            if integrated then
                if myprogress and myprogress.players and myprogress.players[name] and player_huds[name] then
                    player:hud_remove(player_huds[name])
                    player_huds[name] = nil
                end
            else
                update_standalone_hud(player)
            end
        end
        timer = 0
    end
end)

-- Cleanup on leave
core.register_on_leaveplayer(function(player)
    player_huds[player:get_player_name()] = nil
end)

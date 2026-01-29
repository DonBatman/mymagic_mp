mymagic_wands.mana = {}
local MAX_MANA = 100
local REGEN_RATE = 4

function mymagic_wands.use_mana(player, amount)
    if not player or not player:is_player() then return false end
    
    local name = player:get_player_name()
    local current = mymagic_wands.mana[name] or 0
    
    if current >= amount then
        mymagic_wands.mana[name] = current - amount
        return true
    end
    
    core.chat_send_player(name, "§cNot enough mana!")
    return false
end

core.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    mymagic_wands.mana[name] = MAX_MANA
end)

core.register_globalstep(function(dtime)
    for _, player in ipairs(core.get_connected_players()) do
        local name = player:get_player_name()
        if mymagic_wands.mana[name] and mymagic_wands.mana[name] < MAX_MANA then
            mymagic_wands.mana[name] = math.min(MAX_MANA, mymagic_wands.mana[name] + (REGEN_RATE * dtime))
        end
    end
end)

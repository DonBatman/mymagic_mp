local COLOR_TIMES = { orange = 5, green = 10, blue = 15, red = 20 }
local materials = { "wood", "stone", "steel", "bronze", "mese", "diamond" }
local toolTypes = { "axe", "pick", "shovel", "sword", "knife" }
local candidate_map = {}

for _, t in ipairs(toolTypes) do
    for _, col in ipairs({ "orange", "green", "blue", "red" }) do
        for _, mat in ipairs(materials) do
            local tool_name = "mymagic_tools:" .. t .. "_enchanted_" .. mat .. "_" .. col
            candidate_map[tool_name] = col
        end
    end
end

for _, mat in ipairs(materials) do
    for _, t in ipairs({ "axe", "pick", "shovel", "sword" }) do
        local tool_name = "default:" .. t .. "_" .. mat
        candidate_map[tool_name] = "orange"
    end
end

candidate_map["mymagic_tools:diamond_helmet_orange"]    = "orange"
candidate_map["mymagic_tools:diamond_chestplate_orange"] = "orange"
candidate_map["mymagic_tools:diamond_leggings_orange"]    = "orange"
candidate_map["mymagic_tools:diamond_boots_orange"]      = "orange"

candidate_map["mymagic_tools:diamond_helmet_green"]      = "green"
candidate_map["mymagic_tools:diamond_chestplate_green"]   = "green"
candidate_map["mymagic_tools:diamond_leggings_green"]      = "green"
candidate_map["mymagic_tools:diamond_boots_green"]        = "green"

candidate_map["mymagic_tools:diamond_helmet_blue"]      = "red"
candidate_map["mymagic_tools:diamond_chestplate_blue"]    = "red"
candidate_map["mymagic_tools:diamond_leggings_blue"]      = "red"
candidate_map["mymagic_tools:diamond_boots_blue"]         = "red"

local function get_formspec(countdown, msg)
    local timer_label = ""
    if countdown and countdown > 0 then
        timer_label = "label[5,0.5;Charging: " .. countdown .. " sec remaining]"
    end
    local message_label = ""
    if msg then
        message_label = "label[5,1;" .. msg .. "]"
    end
    return "size[9,8]" ..
        "background[0,0;8,8;mymagic_gem_block_bg.png;true]" ..
        "listcolors[#5e4300;#936800;#000000]" ..
        "label[1,1;Tool]" ..
        "label[2,1;Orb]" ..
        "list[current_name;tool;1,2;1,1;]" ..
        "list[current_name;orb;2,2;1,1;]" ..
        "button[3,2;1,1;button;Charge]" ..
        "list[current_name;output;4,2;1,1;]" ..
        "list[current_player;main;0.5,4;8,4;]" ..
        timer_label ..
        message_label
end

core.register_node("mymagic:tool_recharge", {
    description = "Tool Recharging Station",
    tiles = {
        "mymagic_tool_recharge_top.png", "mymagic_tool_recharge_top.png",
        "mymagic_tool_recharge.png",      "mymagic_tool_recharge.png",
        "mymagic_tool_recharge.png",      "mymagic_tool_recharge.png",
    },
    drawtype = "normal",
    paramtype = "light",
    paramtype2 = "facedir",
    light_source = 7,
    groups = { cracky = 1 },

    after_place_node = function(pos, placer)
        local meta = core.get_meta(pos)
        meta:set_string("infotext", "Tool Recharging Station")
        meta:set_string("formspec", get_formspec())
    end,

    can_dig = function(pos, player)
        local inv = core.get_meta(pos):get_inventory()
        return inv:is_empty("tool") and inv:is_empty("orb") and inv:is_empty("output")
    end,

    on_construct = function(pos)
        local meta = core.get_meta(pos)
        meta:set_string("formspec", get_formspec())
        meta:set_string("infotext", "Tool Recharging Station")
        local inv = meta:get_inventory()
        inv:set_size("tool", 1)
        inv:set_size("orb", 1)
        inv:set_size("output", 1)
    end,

    on_receive_fields = function(pos, formname, fields, sender)
        if not fields.button then return end
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()
        
        if inv:is_empty("tool") or inv:is_empty("orb") or not inv:is_empty("output") then return end

        local toolStack = inv:get_stack("tool", 1)
        local orbStack  = inv:get_stack("orb", 1)
        local tool_name = toolStack:get_name()
        local expected_color = candidate_map[tool_name]

        if not expected_color or orbStack:get_name() ~= "mymagic:orb_" .. expected_color then
            meta:set_string("formspec", get_formspec(nil, "Invalid tool or orb!"))
            meta:set_string("infotext", "Invalid tool or orb!")
            return
        end

        if toolStack:get_wear() == 0 then
            meta:set_string("formspec", get_formspec(nil, "Recharge not possible: Tool is undamaged!"))
            meta:set_string("infotext", "Recharge not possible: Tool is undamaged!")
            return
        end

        local delay = COLOR_TIMES[expected_color] or 5

        local function update_timer(remaining)
            local meta_after = core.get_meta(pos)
            meta_after:set_string("formspec", get_formspec(remaining))
            if remaining > 0 then
                core.after(1, function() update_timer(remaining - 1) end)
            else
                local inv_after = meta_after:get_inventory()
                local currentTool = inv_after:get_stack("tool", 1)
                local currentOrb  = inv_after:get_stack("orb", 1)
                if currentTool:get_name() == tool_name and currentOrb:get_name() == "mymagic:orb_" .. expected_color then
                    currentTool:add_wear(-10000)
                    inv_after:set_stack("output", 1, currentTool)
                    currentOrb:take_item()
                    inv_after:set_stack("orb", 1, currentOrb)
                    currentTool:take_item()
                    inv_after:set_stack("tool", 1, currentTool)
                end
                meta_after:set_string("formspec", get_formspec())
            end
        end

        update_timer(delay)
    end,
})

core.register_craft({
    output = "mymagic:tool_recharge",
    recipe = {
        {"default:steel_ingot", "mymagic:orb_orange", "default:steel_ingot"},
        {"default:steel_ingot", "default:brick",      "default:steel_ingot"},
        {"default:steel_ingot", "default:steel_ingot","default:steel_ingot"},
    },
})

local colors = {"orange", "green", "blue", "red"}
local enchantment_map = {}

local function addMapping(base, reqColor, result)
    enchantment_map[base] = enchantment_map[base] or {}
    enchantment_map[base][reqColor] = result
end

for _, tool in ipairs({"pick", "axe", "shovel", "sword"}) do
    for _, mat in ipairs({"wood", "stone", "steel", "bronze", "mese", "diamond"}) do
        local base = "default:" .. tool .. "_" .. mat
        addMapping(base, colors[1], "mymagic_tools:" .. tool .. "_enchanted_" .. mat .. "_" .. colors[1])
        for i = 1, #colors - 1 do
            local prev = "mymagic_tools:" .. tool .. "_enchanted_" .. mat .. "_" .. colors[i]
            addMapping(prev, colors[i+1], "mymagic_tools:" .. tool .. "_enchanted_" .. mat .. "_" .. colors[i+1])
        end
    end
end

for _, mat in ipairs({"wood", "stone", "steel", "bronze", "mese", "diamond"}) do
    local base = "mymagic_tools:knife_" .. mat
    addMapping(base, colors[1], "mymagic_tools:knife_enchanted_" .. mat .. "_" .. colors[1])
    for i = 1, #colors - 1 do
        local prev = "mymagic_tools:knife_enchanted_" .. mat .. "_" .. colors[i]
        addMapping(prev, colors[i+1], "mymagic_tools:knife_enchanted_" .. mat .. "_" .. colors[i+1])
    end
end

for _, armor in ipairs({"helmet", "chestplate", "leggings", "boots"}) do
    local base = "3d_armor:" .. armor .. "_diamond"
    addMapping(base, colors[1], "mymagic_tools:diamond_" .. armor .. "_" .. colors[1])
    for i = 1, #colors - 1 do
        local prev = "mymagic_tools:diamond_" .. armor .. "_" .. colors[i]
        addMapping(prev, colors[i+1], "mymagic_tools:diamond_" .. armor .. "_" .. colors[i+1])
    end
end

local wands = {
    {base = "mymagic_wands:fire_wand", color = "red"},
    {base = "mymagic_wands:ice_wand", color = "blue"},
    {base = "mymagic_wands:glassweaver", color = "orange"},
    {base = "mymagic_wands:meadow_maker", color = "green"},
}

for _, w in ipairs(wands) do
    addMapping(w.base, w.color, w.base .. "_enchanted")
end

local enchantmentTableDef = {
    description = "Enchantment Table",
    tiles = {
        {name = "mymagic_enchantment_table_top_ani.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 0.3}},
        "mymagic_enchantment_table_bottom.png",
        {name = "mymagic_enchantment_table_side_ani.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 0.3}},
        {name = "mymagic_enchantment_table_side_ani.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 0.3}},
        {name = "mymagic_enchantment_table_side_ani.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 0.3}},
        {name = "mymagic_enchantment_table_side_ani.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 0.3}},
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    light_source = 7,
    groups = {choppy = 2},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.4375, -0.5, 0.25, -0.25, 0.125, 0.4375},
            {0.25, -0.5, 0.25, 0.4375, 0.125, 0.4375},
            {-0.4375, -0.5, -0.4375, -0.25, 0.125, -0.25},
            {0.25, -0.5, -0.4375, 0.4375, 0.125, -0.25},
            {-0.5, 0.125, -0.5, 0.5, 0.25, 0.5},
            {-0.375, -0.0625, -0.375, 0.375, 0.125, 0.375},
            {-0.4375, 0.25, 0.125, -0.375, 0.5, 0.1875},
            {0.375, 0.25, 0.125, 0.4375, 0.5, 0.1875},
            {-0.0625, 0.25, 0.375, 0, 0.5, 0.4375},
            {-0.25, 0.25, -0.375, -0.1875, 0.5, -0.3125},
            {0.1875, 0.25, -0.375, 0.25, 0.5, -0.3125},
        }
    },
    after_place_node = function(pos)
        local meta = core.get_meta(pos)
        meta:set_string("infotext", "Enchantment Table")
    end,
    can_dig = function(pos)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()
        return inv:is_empty("tool") and inv:is_empty("orb1")
           and inv:is_empty("orb2") and inv:is_empty("orb3")
           and inv:is_empty("orb4") and inv:is_empty("output")
    end,
    on_construct = function(pos)
        local meta = core.get_meta(pos)
        meta:set_string("formspec",
            "size[10,8;]" ..
            "background[-2,-2;13,12;mymagic_enchantment_table_bg.png]" ..
            "listcolors[#00000000;#00000000;#000000]" ..
            "label[1,0.5;Tool]label[3,0.5;Orbs]" ..
            "list[current_name;tool;1,1;1,1;]list[current_name;orb1;3,1;1,1;]" ..
            "list[current_name;orb2;4,1;1,1;]list[current_name;orb3;3,2;1,1;]" ..
            "list[current_name;orb4;4,2;1,1;]button[5.5,1;2,1;button;Enchant]" ..
            "list[current_name;output;6,2;1,1;]list[current_player;main;0.5,4;8,4;]"
        )
        meta:set_string("infotext", "Tool Upgrade")
        local inv = meta:get_inventory()
        inv:set_size("tool", 1)
        inv:set_size("orb1", 1)
        inv:set_size("orb2", 1)
        inv:set_size("orb3", 1)
        inv:set_size("orb4", 1)
        inv:set_size("output", 1)
    end,
    on_receive_fields = function(pos, _, fields)
        local meta = core.get_meta(pos)
        local inv = meta:get_inventory()
        if fields["button"] then
            if not (inv:is_empty("tool") or inv:is_empty("orb1")
                or inv:is_empty("orb2") or inv:is_empty("orb3")
                or inv:is_empty("orb4")) then
                local tool = inv:get_stack("tool", 1)
                local orb1 = inv:get_stack("orb1", 1)
                local orb2 = inv:get_stack("orb2", 1)
                local orb3 = inv:get_stack("orb3", 1)
                local orb4 = inv:get_stack("orb4", 1)
                
                local orbColor = orb1:get_name():match("mymagic:orb_(%a+)")
                if orbColor and orb2:get_name() == "mymagic:orb_" .. orbColor
                   and orb3:get_name() == "mymagic:orb_" .. orbColor
                   and orb4:get_name() == "mymagic:orb_" .. orbColor then
                    
                    local mapping = enchantment_map[tool:get_name()]
                    if mapping and mapping[orbColor] then
                        local wear = tool:get_wear()
                        local old_meta = tool:get_meta():to_table()
                        
                        inv:add_item("output", mapping[orbColor])
                        local output = inv:get_stack("output", 1)
                        output:set_wear(wear)
                        
                        output:get_meta():from_table(old_meta)
                        
                        inv:set_stack("output", 1, output)
                        
                        orb1:take_item(1); inv:set_stack("orb1", 1, orb1)
                        orb2:take_item(1); inv:set_stack("orb2", 1, orb2)
                        orb3:take_item(1); inv:set_stack("orb3", 1, orb3)
                        orb4:take_item(1); inv:set_stack("orb4", 1, orb4)
                        tool:take_item(1); inv:set_stack("tool", 1, tool)
                        
                        core.sound_play("default_cool_lava", {pos = pos, gain = 1.0})
                    end
                end
            end
        end
    end,
}

core.register_node("mymagic:enchantment_table", enchantmentTableDef)

core.register_craft({
    output = "mymagic:enchantment_table",
    recipe = {
        {"default:torch", "mymagic:orb_red", "default:torch"},
        {"default:wood", "default:wood", "default:wood"},
        {"default:stick", "", "default:stick"}
    }
})

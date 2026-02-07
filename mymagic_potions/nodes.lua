minetest.register_node("mymagic_potions:brewing_stand", {
    description = "Magic Brewing Stand",
    drawtype = "mesh",
    mesh = "mymagic_brewing_stand.obj",
    tiles = {"mymagic_brewing_stand.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2, oddly_breakable_by_hand = 1},
    
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        
        local formspec = ""
        if mymagic_potions.get_formspec then
            formspec = mymagic_potions.get_formspec(0)
        else
            formspec = "size[8,5]label[1,1;Error: Brewing logic missing!]"
        end
        
        meta:set_string("formspec", formspec)
        meta:set_string("infotext", "Brewing Stand")
        
        local inv = meta:get_inventory()
        inv:set_size("src", 1)
        inv:set_size("bottle", 1)
        inv:set_size("fuel", 1)
        inv:set_size("dst", 1)
    end,

    on_timer = function(pos, elapsed)
        if mymagic_potions.run_brew then
            return mymagic_potions.run_brew(pos)
        end
        return false
    end,
})

-- MyMagic Potions: Basic Ingredients

local ingredients = {
    {"blood_root", "Blood Root", "mymagic_root_red.png"},
    {"wind_petal", "Wind Petal", "mymagic_petal_green.png"},
    {"magma_core", "Magma Core", "mymagic_core_orange.png"},
    {"glow_dust", "Glow Dust", "mymagic_dust_yellow.png"},
}

for _, ing in ipairs(ingredients) do
    minetest.register_craftitem("mymagic_potions:" .. ing[1], {
        description = ing[2],
        inventory_image = ing[3],
    })
end



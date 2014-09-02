
function bk_game.register_sea_grass(name, def)

	minetest.register_node(":sea:grass_"..name, {
		description = def.description.." Seagrass",
		drawtype = "plantlike",
		tiles = {"sea_grass__"..name..".png"},
		inventory_image = "sea_grass__"..name..".png",
		wield_image = "sea_grass__"..name..".png",
		paramtype = "light",
		walkable = false,
		climbable = true,
		is_ground_content = true,
		--[[
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, 0.3, 0.3}
		},
		]]--
		post_effect_color = {a=64, r=100, g=100, b=200},
		groups = {snappy=3, grass=1, sea=1},
		sounds = default.node_sound_leaves_defaults(),
		on_use = minetest.item_eat(1)
	})

	table.insert(registered_plants_list, "sea:grass_"..name)

end

local grass_list = {
		["green"] = {description="Green"},
		["red"] = {description="Red"},
}

for grass, desc in pairs(grass_list) do
	bk_game.register_sea_grass(grass, desc)
end

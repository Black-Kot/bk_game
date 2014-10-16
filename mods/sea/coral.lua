
function bk_game.register_coral(name, def)

	minetest.register_node(":sea:coral_"..name, {
		description = def.description.." Coral",
		drawtype = "plantlike",
		tiles = {"sea_coral_"..name..".png"},
		inventory_image = "sea_coral_"..name..".png",
		wield_image = "sea_coral_"..name..".png",
		paramtype = "light",
		walkable = false,
		climbable = true,
		is_ground_content = true,
		--[[
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.3, -0.3, 0.3, 0.3, 0.3}
		},
		]]--
		post_effect_color = {a=64, r=100, g=100, b=200},
		groups = {snappy=3, coral=1, sea=1},
		sounds = default.node_sound_leaves_defaults(),
	})

	table.insert(registered_plants_list, "sea:coral_"..name)

end

local coral_list = {
		aqua = {description="Aqua"},
		cyan = {description="Cyan"},
		lime = {description="Lime"},
		magenta = {description="Magenta"},
		redviolet = {description="Redviolet"},
		skyblue = {description="Skyblue"}
}

for coral, desc in pairs(coral_list) do
	bk_game.register_coral(coral, desc)
end

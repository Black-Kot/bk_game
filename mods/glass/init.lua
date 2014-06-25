-- colored glass

for _, row in ipairs(bk_game.colors) do
	local name = row[1]
	local desc = row[2]
	local craft_color_group = row[3]
	-- Node Definition

	bk_game.register_nodes("glass_"..name, {
		stair = true,
		slab = true,
		description = desc.." Glass",
		tiles = {"glass_"..name..".png"},
        inventory_image = minetest.inventorycube("glass_"..name..".png"),
		drawtype = "glasslike",
		paramtype = "light",
		sunlight_propagates = true,
		groups = {cracky=6,oddly_breakable_by_hand=3,glass=1},
		sounds = default.node_sound_glass_defaults(),
	})
	
	if craft_color_group then
		-- Crafting from dye and white glass
		minetest.register_craft({
			type = "shapeless",
			output = "blocks:glass_"..name,
			recipe = {"group:dye,"..craft_color_group, "group:glass"},
		})
	end
end

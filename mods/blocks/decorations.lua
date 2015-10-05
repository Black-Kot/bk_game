function bk_game.register_column(name, def)
	minetest.register_node(":blocks:"..name.."_column", {
		description = def.description.." Column",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.2, 0.5, 0.5, 0.2},
				{-0.4, -0.5, -0.3, 0.4, 0.5, 0.3},
				{-0.3, -0.5, -0.4, 0.3, 0.5, 0.4},
				{-0.2, -0.5, -0.5, 0.2, 0.5, 0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.2, 0.5, 0.5, 0.2},
				{-0.4, -0.5, -0.3, 0.4, 0.5, 0.3},
				{-0.3, -0.5, -0.4, 0.3, 0.5, 0.4},
				{-0.2, -0.5, -0.5, 0.2, 0.5, 0.5},
			},
		},
		tiles = {def.default_texture},
		particle_image = def.default_texture,
		groups = def.groups,
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_craft({
		output = "blocks:"..name.."_column 5",
		recipe = {
			{"","blocks:"..name,""},
			{"blocks:"..name,"blocks:"..name,"blocks:"..name},
			{"","blocks:"..name,""},
		}
	})

	minetest.register_craft({
		output = "blocks:"..name.." 4",
		recipe = {
			{"blocks:"..name.."_column", "blocks:"..name.."_column"},
			{"blocks:"..name.."_column", "blocks:"..name.."_column"},
		},
	})
end

function bk_game.register_pyramid(name, def)
	minetest.register_node(":blocks:"..name.."_pyramid", {
		description = def.description.." Pyramid",
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
				{-0.4, -0.3, -0.4, 0.4, -0.1, 0.4},
				{-0.3, -0.1, -0.3, 0.3, 0.1, 0.3},
				{-0.2, 0.1, -0.2, 0.2, 0.3, 0.2},
				{-0.1, 0.3, -0.1, 0.1, 0.5, 0.1},
			},
		},
		tiles = {def.default_texture},
		particle_image = def.default_texture,
		groups = def.groups,
		sounds = default.node_sound_stone_defaults(),
	})

	minetest.register_craft({
		output = "blocks:"..name.."_pyramid 16",
		recipe = {
			{"","blocks:"..name,""},
			{"blocks:"..name,"blocks:"..name,"blocks:"..name},
		}
	})

	minetest.register_craft({
		output = "blocks:"..name.." 1",
		recipe = {
			{"blocks:"..name.."_pyramid", "blocks:"..name.."_pyramid"},
			{"blocks:"..name.."_pyramid", "blocks:"..name.."_pyramid"},
		},
	})
end

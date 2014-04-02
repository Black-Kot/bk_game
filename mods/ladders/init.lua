function bk_game.register_ladder(name, def)
	minetest.register_node(":ladder:"..name, {
		description = def.description.." Ladder",
		drawtype = "signlike",
		tiles = {"ladder_"..name..".png"},
		inventory_image = "ladder_"..name..".png",
		wield_image = "ladder_"..name..".png",
		paramtype = "light",
		paramtype2 = "wallmounted",
		walkable = false,
		climbable = true,
		selection_box = {
			type = "wallmounted",
		},
		groups = {choppy=2,oddly_breakable_by_hand=1,flammable=2},
		legacy_wallmounted = true,
		sounds = default.node_sound_wood_defaults(),
	})
	minetest.register_craft({
		output = "ladder:"..name,
		recipe = {
			{def.source, '', def.source},
			{def.source, def.source, def.source},
			{def.source, '', def.source},
		}
	})
end

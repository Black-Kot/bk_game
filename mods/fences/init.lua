

function register_fence(name, def) 

minetest.register_node(":fence:"..name, {
	description = def.description.." Fence",
	drawtype = "fencelike",
	tiles = {"fence_"..name..".png"},
	inventory_image ="fence_"..name..".png",
	wield_image = "fence_"..name..".png",
	paramtype = "light",
	selection_box = {
		type = "fixed",
		fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_craft({
	output = 'fence:'..name..' 2',
	recipe = {
		{def.source, def.source, def.source},
		{def.source, def.source, def.source},
	}
})

end

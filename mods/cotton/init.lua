
bk_game.register_flower("cotton", {
	description = "Cotton",
	interval=7200,
	chance = 16,
	spacing = 30,
	nodenames={"default:dirt_with_grass", "default:desert_sand"}
})

minetest.register_craftitem("cotton:cotton", {
	description = "Cotton",
	inventory_image = "cotton.png",
})

minetest.register_craft({
	output = "cotton:cotton 12",
	recipe = {{"flowers:cotton", "flowers:cotton", ""}, {"flowers:cotton", "flowers:cotton", ""}}
})

minetest.register_craft({
	output = "cotton:white 1",
	recipe = {{"cotton:cotton", "cotton:cotton", ""}, {"cotton:cotton", "cotton:cotton", ""}}
})

for _, row in ipairs(bk_game.colors) do
	local name = row[1]
	local desc = row[2]
	local craft_color_group = row[3]
	-- Node Definition
	minetest.register_node("cotton:"..name, {
		description = desc.." cotton",
		tiles = {"cotton_"..name..".png"},
		groups = {snappy=5,choppy=5,oddly_breakable_by_hand=3,cotton=1},
		sounds = default.node_sound_defaults(),
	})
	if craft_color_group then
		-- Crafting from dye and white cotton
		minetest.register_craft({
			type = "shapeless",
			output = 'cotton:'..name,
			recipe = {'group:dye,'..craft_color_group, 'group:cotton'},
		})
	end
end


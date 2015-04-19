function bk_game.register_block(name, def)
	-- we use copy table from real block
	local block = copy_table(def)
	block.description = def.description
	minetest.register_node(":blocks:"..name, block)

	if def.source then
		minetest.register_craft({
			output = "blocks:"..name,
			recipe = {
				{def.source, def.source, ""},
				{def.source, def.source, ""},
			}
		})

		minetest.register_craft({
			output = def.source.." 4",
			recipe = {
				{"blocks:"..name},
			}
		})

	end

end

dofile(minetest.get_modpath(minetest.get_current_modname()).."/slabs.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/stairs.lua")
dofile(minetest.get_modpath(minetest.get_current_modname()).."/decorations.lua")

function bk_game.register_nodes(name, def)
	if not def.tiles then
		def.tiles = {"blocks_"..name..".png"}
	end

	if not def.default_texture then
		def.default_texture = def.tiles[1]
	end

	if not def.level then
		def.level=5
	end

	if not def.groups then
		def.groups = {cracky=def.level}
		def.is_ground_content = true
	end

	if not def.sounds then
		def.sounds = default.node_sound_stone_defaults()
	end

	bk_game.register_block(name, def)
	
	def.source = "blocks:"..name

	if def.slab then
		bk_game.register_slab(name, def)
	end

	if def.stair then
		bk_game.register_stair(name, def)
		bk_game.register_slope(name, def)
	end

	if def.column then
		bk_game.register_column(name, def)
	end

	if def.pyramid then
		bk_game.register_pyramid(name, def)
	end
end

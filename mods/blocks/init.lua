bk_game = {}

function bk_game.register_block(name, def)

-- we use copy table from real block
local block = copy_table(def)
block.description = def.description.." Block"
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

function bk_game.register_stair(name, def)
	local name = name:remove_modname_prefix()
	minetest.register_node(":blocks:"..name.."_stair", {
		description = def.description.." Stair",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,

		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			if p0.y-1 == p1.y then
				local fakestack = ItemStack("blocks:"..name.."_stair_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end

			-- Otherwise place regularly
			return minetest.item_place(itemstack, placer, pointed_thing)
		end,
	})

	minetest.register_node(":blocks:"..name.."_stair_upside_down", {
		drop = "blocks:"..name.."_stair",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, 0, -0.5, 0.5, 0.5, 0.5},
				{-0.5, -0.5, 0, 0.5, 0, 0.5},
			},
		},
	})
	if def.without_craft == true then

	else
	minetest.register_craft({
		output = "blocks:"..name.."_stair 8",
		recipe = {
			{"blocks:"..name, "", ""},
			{"blocks:"..name, "blocks:"..name, ""},
			{"blocks:"..name, "blocks:"..name, "blocks:"..name},
		},
	})

	-- Flipped recipe for the silly minecrafters
	minetest.register_craft({
		output = "blocks:"..name.."_stair 8",
		recipe = {
			{"", "", "blocks:"..name},
			{"", "blocks:"..name, "blocks:"..name},
			{"blocks:"..name, "blocks:"..name, "blocks:"..name},
		},
	})

	minetest.register_craft({
		output = "blocks:"..name.." 3",
		recipe = {
			{"blocks:"..name.."_stair", "blocks:"..name.."_stair"},
			{"blocks:"..name.."_stair", "blocks:"..name.."_stair"},
		},
	})
	end
end

function bk_game.register_slab(name, def)

	minetest.register_node(":blocks:"..name.."_slab",{
		description = def.description.." Slab",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		sunlight_propagates = def.sunlight_propagates,
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end

			-- If it"s being placed on an another similar one, replace it with
			-- a full block
			local slabpos = nil
			local slabnode = nil
			local p0 = pointed_thing.under
			local p1 = pointed_thing.above
			local n0 = minetest.get_node(p0)
			if n0.name == "blocks:"..name.."_slab" and
					p0.y+1 == p1.y then
				slabpos = p0
				slabnode = n0
			end
			--[[if slabpos then
					minetest.remove_node(p0)
					itemstack:take_item(1)
					minetest.set_node(p0,{name=name})
				return itemstack
			end]]--
			-- Upside down slabs
			if p0.y-1 == p1.y then
				-- Turn into full block if pointing at a existing slab
				--[[if n0.name == "blocks:"..name.."_slab_upside_down" or "blocks:"..name.."_slab_upside_down" then
					minetest.remove_node(p0)
					itemstack:take_item(1)
					minetest.set_node(p0,{name=name})
				end]]--

				-- Place upside down slab
				local fakestack = ItemStack("blocks:"..name.."_slab_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end

			-- If pointing at the side of a upside down slab
			if n0.name == "blocks:"..name.."_slab_upside_down" and
					p0.y+1 ~= p1.y then
				-- Place upside down slab
				local fakestack = ItemStack("blocks"..name.."_slab_upside_down")
				local ret = minetest.item_place(fakestack, placer, pointed_thing)
				if ret:is_empty() then
					itemstack:take_item()
					return itemstack
				end
			end

			-- Otherwise place regularly
			return minetest.item_place(itemstack, placer, pointed_thing)
		end,
	})

	minetest.register_node(":blocks:"..name.."_slab_upside_down", {
		drop = "blocks:"..name.."_slab",
		drawtype = "nodebox",
		tiles = def.tiles,
		paramtype = "light",
		is_ground_content = true,
		groups = def.groups,
		sounds = def.sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, 0, -0.5, 0.5, 0.5, 0.5},
		},
	})
	if def.without_craft == true then

	else
	minetest.register_craft({
		output = "blocks:"..name.."_slab 6",
		recipe = {
			{"blocks:"..name, "blocks:"..name, "blocks:"..name},
		},
	})

	minetest.register_craft({
		output = "blocks:"..name.." 2",
		recipe = {
			{"blocks:"..name.."_slab", "blocks:"..name.."_slab"},
			{"blocks:"..name.."_slab", "blocks:"..name.."_slab"},
		},
	})
	end
end

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

	if def.slab == true then
		bk_game.register_slab(name, def)
	end

	if def.stair == true then
		bk_game.register_stair(name, def)
	end

	if def.column == true then
		bk_game.register_column(name, def)
	end

	if def.pyramid == true then
		bk_game.register_pyramid(name, def)
	end

	if def.flat then
		bk_game.register_nodes(name.."_flat", {
			description = "Flat "..def.description,
			source = nil,
			brick = true,
			flat = false,
			stair = def.stair or true,
			slab = def.slab or true,
			column = def.column or true,
			pyramid = def.pyramid or true,
		})
	end 

	if def.brick then
		bk_game.register_nodes(name.."_brick", {
			description = def.description.." Brick",
			source = nil,
			brick = false,
			flat = false,
			stair = def.stair or true,
			slab = def.slab or true,
			column = def.column or true,
			pyramid = def.pyramid or true,
		})
	end
	
	print("Blocks "..def.description.." [OK]")
end
